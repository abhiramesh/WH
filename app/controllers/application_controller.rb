class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
  	user_path(current_user)
  end

  def authorize
  	unless current_user && current_user.email == "abhiramesh@gmail.com"
  		redirect_to root_path
  	end
  end

end
