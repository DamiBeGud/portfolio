require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  test "is valid with name, email, and message" do
    message = ContactMessage.new(name: "Ada", email: "ada@example.com", message: "Hello")
    assert message.valid?
  end

  test "requires name, email, and message" do
    message = ContactMessage.new
    assert_not message.valid?
    assert_includes message.errors[:name], "can't be blank"
    assert_includes message.errors[:email], "can't be blank"
    assert_includes message.errors[:message], "can't be blank"
  end

  test "requires a valid email" do
    message = ContactMessage.new(name: "Ada", email: "not-an-email", message: "Hello")
    assert_not message.valid?
    assert_includes message.errors[:email], "is invalid"
  end

  test "defaults to unviewed and unresponded" do
    message = ContactMessage.create!(name: "Ada", email: "ada@example.com", message: "Hello")
    assert_not message.viewed?
    assert_not message.responded?
  end

  test "ordered scope returns newest first" do
    older = contact_messages(:one)
    older.update_column(:created_at, 2.days.ago)

    assert_equal contact_messages(:two).id, ContactMessage.ordered.first.id
  end

  test "unviewed scope returns only unviewed messages" do
    assert_equal [contact_messages(:one).id], ContactMessage.unviewed.pluck(:id)
  end
end
