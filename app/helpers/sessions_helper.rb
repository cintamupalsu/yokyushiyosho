module SessionsHelper
   
   # Logs in the given user.
   # Logging a user in is simple with the help of the session method defined by Rails.
   def log_in(user)
      session[:user_id] = user.id # This places a temporary cookie on the user’s browser containing an encrypted version of the user’s id, which allows us to retrieve the id on subsequent pages using session[:user_id].
   end
   
   # Returns the current logged-in user (if any)
   def current_user
      if session[:user_id]
         @current_user ||= User.find_by(id: session[:user_id])
      end
   end
   
   def logged_in?
      !current_user.nil?
   end
   
   # Logs out the current user.
   def log_out
      session.delete(:user_id)
      @current_user = nil
   end
end
