module Admin
  class HomeSectionsController < BaseController
    def edit
      @settings = SiteSetting.current
    end

    def update
      @settings = SiteSetting.current

      if @settings.update(home_params)
        redirect_to edit_admin_home_section_path, notice: "Home section updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def home_params
      params.require(:site_setting).permit(:brand, :page_title, :meta_description, :hero_kicker, :hero_title, :hero_intro, :hero_body)
    end
  end
end
