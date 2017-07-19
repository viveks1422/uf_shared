class ApplicationController < ActionController::Base
  # prepend_before_action :configure_permitted_params
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :set_layout
  rescue_from ActionController::RoutingError, with: -> { render_404  }
  include DeviseTokenAuth::Concerns::SetUserByToken
  # protect_from_forgery with: :exception

  protected
  def render_404
    respond_to do |format|
      format.html { redirect_to '/#/404' }
      format.all { render nothing: true, status: 404 }
    end
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,:email,:password,:password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name,:last_name,:email,:gender,:relation_status,:location,:password,:password_confirmation,:mobile,:image,:wizard])
  end
  def set_layout
  	if  :devise_controller?
  		false
  	else
  		'application'
  	end	
  end
end
