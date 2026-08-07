class ContactMessagesController < ApplicationController
  def create
    @message = ContactMessage.new(contact_message_params)

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path(anchor: "contact"), notice: "Thanks, your message has been sent." }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html do
          flash.now[:alert] = @message.errors.full_messages.to_sentence
          load_home_data
          render "home/index", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :message)
  end

  def load_home_data
    @settings = SiteSetting.current
    @experience_entries = TimelineEntry.experience
    @education_entries = TimelineEntry.education
    @info_cards = InfoCard.ordered
    @projects = Project.ordered
    @contact_links = ContactLink.ordered
  end
end
