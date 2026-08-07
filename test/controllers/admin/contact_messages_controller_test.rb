require "test_helper"

module Admin
  class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
    def sign_in_admin
      post admin_session_path, params: { password: "test-password" }
    end

    test "index lists all messages in a table" do
      sign_in_admin
      get admin_contact_messages_path

      assert_response :success
      assert_select "table.admin-table tbody tr", count: ContactMessage.count
      assert_select "td", text: "Ada Lovelace"
      assert_select "td.admin-message-date", text: /\d{2} \w{3} \d{4}, \d{2}:\d{2}/
    end

    test "show renders the message detail frame" do
      sign_in_admin
      get admin_contact_message_path(contact_messages(:one))

      assert_response :success
      assert_select "turbo-frame#message-detail"
      assert_select "h2", text: "Ada Lovelace"
    end

    test "update marks a message as viewed with a turbo stream" do
      sign_in_admin
      message = contact_messages(:one)

      patch admin_contact_message_path(message),
        params: { contact_message: { viewed: true } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      assert_response :success
      assert message.reload.viewed?
      assert_match(/messages-table-body/, response.body)
      assert_match(/admin-message-count/, response.body)
      assert_match(/admin-messages-count/, response.body)
      assert_match(/0 unviewed/, response.body)
    end

    test "update toggles responded status" do
      sign_in_admin
      message = contact_messages(:one)

      patch admin_contact_message_path(message),
        params: { contact_message: { responded: true } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      assert_response :success
      assert message.reload.responded?
    end

    test "update falls back to a redirect for plain html" do
      sign_in_admin
      message = contact_messages(:one)

      patch admin_contact_message_path(message),
        params: { contact_message: { viewed: true } }

      assert_redirected_to admin_contact_messages_path
      assert message.reload.viewed?
    end

    test "requires admin authentication" do
      get admin_contact_messages_path
      assert_redirected_to new_admin_session_path
    end
  end
end
