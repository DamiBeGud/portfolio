module Admin
  class SessionsController < ApplicationController
    layout "admin"

    def new
    end

    def create
      if valid_password?(params[:password].to_s)
        session[:admin_authenticated] = true
        redirect_to admin_root_path, notice: "Signed in."
      else
        redirect_to new_admin_session_path, alert: "Invalid password."
      end
    end

    def destroy
      reset_session
      redirect_to root_path, notice: "Signed out."
    end

    private

    def valid_password?(candidate)
      password = ENV["ADMIN_PASSWORD"].to_s
      return false if password.blank? || candidate.blank? || candidate.bytesize != password.bytesize

      ActiveSupport::SecurityUtils.secure_compare(candidate, password)
    end
  end
end
