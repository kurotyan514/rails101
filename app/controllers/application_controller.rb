class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_paramsters,if: :devise_controller?

  protected
  def configure_permitted_paramsters
  	#疑問！！
  	#下面三種寫法哪裡不一樣，還有就是為什麼不加入strong_parameters，name的屬性就會寫不進db裡？


  	# devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  	
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  	devise_parameter_sanitizer.for(:account_updaye) { |u| u.permit(:name, :email, :password, :password_confirmation,:current_password) }

 #  	devise_parameter_sanitizer.permit(:sign_in) do |user_params|
 #    	user_params.permit(:name, :email, :password, :password_confirmation)
	# end
  end
end
