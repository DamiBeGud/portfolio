module Admin
  class SettingsController < BaseController
    def edit
      @settings = SiteSetting.current
    end

    def update
      @settings = SiteSetting.current

      if @settings.update(settings_params)
        redirect_to edit_admin_settings_path, notice: "Settings updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def reset_colors
      SiteSetting.current.update!(SiteSetting::DEFAULT_COLORS)
      redirect_to edit_admin_settings_path, notice: "Colors reset to defaults."
    end

    def reset_color
      color_field = params[:color_field].to_s

      unless SiteSetting::COLOR_FIELDS.include?(color_field)
        redirect_to edit_admin_settings_path, alert: "Unknown color field."
        return
      end

      SiteSetting.current.update!(color_field => SiteSetting::DEFAULT_COLORS[color_field.to_sym])
      redirect_to edit_admin_settings_path, notice: "#{color_field.humanize} reset to default."
    end

    private

    def settings_params
      params.require(:site_setting).permit(
        :show_animation_toggle, :show_theme_toggle, :theme_mode, :background_pattern,
        :light_grid_thickness, :dark_grid_thickness, :light_background, :light_text,
        :light_surface, :light_muted, :light_border, :dark_background,
        :dark_text, :dark_surface, :dark_muted, :dark_border
      )
    end
  end
end
