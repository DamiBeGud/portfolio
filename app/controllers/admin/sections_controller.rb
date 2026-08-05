module Admin
  class SectionsController < BaseController
    def index
      @settings = SiteSetting.current
      @sections = [
        ["Home", "Hero, page title, meta text, and brand", edit_admin_home_section_path],
        ["About", "About text, work experience, education, and capability cards", edit_admin_about_section_path],
        ["Projects", "Project cards, links, technologies, order, and uploaded images", admin_projects_path],
        ["Contact", "Contact heading, email, form target, and social links", edit_admin_contact_section_path],
        ["Settings", "Visitor controls, light/dark mode defaults, and color palette", edit_admin_settings_path]
      ]
    end
  end
end
