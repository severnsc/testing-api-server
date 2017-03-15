require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(email: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should have an email" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should be valid" do
    bad_emails = %w[me@example meatexample.com at@example.com. me@exampledotcom]
    bad_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} shouldn't be valid"
    end
  end

  test "email should be max 255 chars" do
    @user.email = "a"*255 + "@example.com"
    assert_not @user.valid?
  end

  test "should have password" do
    @user.password = " "
    assert_not @user.valid?
  end

  test "password should be at least 8 chars" do
    @user.password = "a"*7
    @user.password_confirmation = "a"*7
    assert_not @user.valid?
  end
end
