require "test_helper"

module Admin
  class HomeSectionsControllerTest < ActionDispatch::IntegrationTest
    def sign_in_admin
      post admin_session_path, params: { password: "test-password" }
    end

    test "edit renders the hero kicker field" do
      sign_in_admin
      get edit_admin_home_section_path

      assert_response :success
      assert_select "input[name='site_setting[hero_kicker]']"
    end

    test "update saves the hero kicker" do
      sign_in_admin

      patch admin_home_section_path, params: {
        site_setting: { hero_kicker: "Senior Software Engineer" }
      }

      assert_redirected_to edit_admin_home_section_path
      assert_equal "Senior Software Engineer", SiteSetting.current.hero_kicker
    end

    test "update ignores unpermitted attributes" do
      sign_in_admin
      settings = SiteSetting.current

      patch admin_home_section_path, params: {
        site_setting: { hero_kicker: "Lead Developer", admin: true, role: "superadmin" }
      }

      assert_redirected_to edit_admin_home_section_path
      assert_equal "Lead Developer", settings.reload.hero_kicker
      assert_not settings.respond_to?(:role)
    end

    test "requires admin authentication" do
      get edit_admin_home_section_path
      assert_redirected_to new_admin_session_path
    end
  end
end
