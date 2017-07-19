class BasicQuestionsController < ApplicationController
	before_action :authenticate_user!
	def index
		@basic_questions=BasicQuestion.all
		respond_to do |format|
			format.json{render json: @basic_questions}
		end
	end
end
