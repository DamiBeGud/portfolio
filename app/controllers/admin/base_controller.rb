module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_admin

    private

    def require_admin
      return if session[:admin_authenticated]

      redirect_to new_admin_session_path, alert: "Enter the admin password to continue."
    end
  end
end
