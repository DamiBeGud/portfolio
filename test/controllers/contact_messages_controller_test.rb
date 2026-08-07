require "test_helper"

class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  test "creates a message and redirects to the contact section" do
    assert_difference("ContactMessage.count", 1) do
      post contact_messages_path, params: {
        contact_message: { name: "Ada", email: "ada@example.com", message: "Hello" }
      }
    end

    assert_redirected_to root_path(anchor: "contact")
    assert_equal "Thanks, your message has been sent.", flash[:notice]
  end

  test "re-renders the home page with errors on invalid submission" do
    assert_no_difference("ContactMessage.count") do
      post contact_messages_path, params: {
        contact_message: { name: "", email: "", message: "" }
      }
    end

    assert_response :unprocessable_entity
    assert_match(/be blank/, response.body)
  end

  test "ignores unpermitted parameters" do
    assert_difference("ContactMessage.count", 1) do
      post contact_messages_path, params: {
        contact_message: { name: "Ada", email: "ada@example.com", message: "Hello", viewed: true }
      }
    end

    assert_redirected_to root_path(anchor: "contact")
    assert_equal "Thanks, your message has been sent.", flash[:notice]
    assert_not ContactMessage.last.viewed?
  end

  test "responds with a turbo stream success message without navigating" do
    assert_difference("ContactMessage.count", 1) do
      post contact_messages_path, params: {
        contact_message: { name: "Ada", email: "ada@example.com", message: "Hello" }
      }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success
    assert_match(/turbo-stream/, response.body)
    assert_match(/Thanks, your message has been sent/, response.body)
    assert_match(/contact-form/, response.body)
  end

  test "responds with a turbo stream error message keeping the form" do
    assert_no_difference("ContactMessage.count") do
      post contact_messages_path, params: {
        contact_message: { name: "", email: "", message: "" }
      }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success
    assert_match(/turbo-stream/, response.body)
    assert_match(/contact-form-status/, response.body)
    assert_match(/be blank/, response.body)
  end
end
