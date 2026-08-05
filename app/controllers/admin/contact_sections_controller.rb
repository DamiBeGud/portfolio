module Admin
  class ContactSectionsController < BaseController
    def edit
      @settings = SiteSetting.current
      @contact_links = ContactLink.ordered
    end

    def update
      @settings = SiteSetting.current

      if @settings.update(contact_params)
        redirect_to edit_admin_contact_section_path, notice: "Contact section updated."
      else
        @contact_links = ContactLink.ordered
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def contact_params
      params.require(:site_setting).permit(:contact_kicker, :contact_title, :contact_email)
    end
  end
end
