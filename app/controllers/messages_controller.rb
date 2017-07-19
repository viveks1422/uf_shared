class MessagesController < ApplicationController
	def reply_back
		# initial params
		user=User.find_by({:mobile=>from})
		if user.present?
			begin
				body=params["Body"]
				obj=body.split(":")
				key=obj.first.downcase
				key=(key=="relation" ? 'relation_status' : key)
				value=obj.first
				from=params["From"]
				if key.include?('ques')
					id=key.split('_')
					basic_ques=BasicQuestion.find(id.last)
					unless basic_ques.blank?
						user.profile_questions.build({profile_id: user.profile.id, basic_question_id: id, answer: value}).save!
					end
				elsif key=='mobile'
					user.update_attribute(:verified,true)
				elsif ['title','description'].include?(key)
					profile=user.profile
					profile.update_attribute(key,value)
				else
					user.update_attribute(key,value)
				end	
				respond_to do |format|
					format.json{json: {message: "Value #{value} updated successfully to #{key} in user #{user.email} account" }}
				end
			rescue Exception => e
				respond_to do |format|
					format.json{json: {message: "Error: #{e}" }}
				end	
			end
		
		else
			respond_to do |format|
				format.json{json: {message: "Error: User can't find"}}
			end
		end
	end
end
	