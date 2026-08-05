module Admin
  class ContactLinksController < BaseController
    before_action :set_contact_link, only: [:edit, :update, :destroy]

    def index
      @contact_links = ContactLink.ordered
    end

    def new
      @contact_link = ContactLink.new
    end

    def create
      @contact_link = ContactLink.new(contact_link_params)

      if @contact_link.save
        redirect_to edit_admin_contact_section_path, notice: "Contact link created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @contact_link.update(contact_link_params)
        redirect_to edit_admin_contact_section_path, notice: "Contact link updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @contact_link.destroy
      redirect_to edit_admin_contact_section_path, notice: "Contact link deleted."
    end

    private

    def set_contact_link
      @contact_link = ContactLink.find(params[:id])
    end

    def contact_link_params
      params.require(:contact_link).permit(:label, :url, :sort_order)
    end
  end
end
