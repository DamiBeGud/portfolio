module Admin
  class AboutSectionsController < BaseController
    def edit
      @settings = SiteSetting.current
      @experience_entries = TimelineEntry.experience
      @education_entries = TimelineEntry.education
      @info_cards = InfoCard.ordered
    end

    def update
      @settings = SiteSetting.current

      if @settings.update(about_params)
        redirect_to edit_admin_about_section_path, notice: "About section updated."
      else
        @experience_entries = TimelineEntry.experience
        @education_entries = TimelineEntry.education
        @info_cards = InfoCard.ordered
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def about_params
      params.require(:site_setting).permit(:about_kicker, :about_title, :about_body)
    end
  end
end
