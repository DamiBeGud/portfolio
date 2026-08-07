module Admin
  class ContactMessagesController < BaseController
    before_action :set_message, only: [:show, :update]

    def index
      @messages = ContactMessage.ordered
    end

    def show
    end

    def update
      @message.update(message_params)

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Message updated."
          render turbo_stream: [
            turbo_stream.replace("message-detail", partial: "admin/contact_messages/message_detail", locals: { message: @message }),
            turbo_stream.replace("messages-table-body", partial: "admin/contact_messages/messages_table_body", locals: { messages: ContactMessage.ordered }),
            turbo_stream.replace("admin-message-count", partial: "admin/contact_messages/message_count"),
            turbo_stream.replace("admin-messages-count", partial: "admin/shared/messages_count_badge"),
            turbo_stream.replace("admin-flashes", partial: "admin/shared/flashes")
          ]
        end
        format.html { redirect_to admin_contact_messages_path, notice: "Message updated." }
      end
    end

    private

    def set_message
      @message = ContactMessage.find(params[:id])
    end

    def message_params
      params.require(:contact_message).permit(:viewed, :responded)
    end
  end
end
