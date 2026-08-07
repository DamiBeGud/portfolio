class SiteSetting < ApplicationRecord
  THEME_MODES = %w[system light dark].freeze
  GRID_THICKNESS_RANGE = 1..8
  DEFAULT_COLORS = {
    light_background: "#f8f8f5",
    light_text: "#050505",
    light_surface: "#f8f8f5",
    light_muted: "#696963",
    light_border: "#050505",
    dark_background: "#050505",
    dark_text: "#f8f8f5",
    dark_surface: "#1c1c1a",
    dark_muted: "#a7a7a0",
    dark_border: "#f8f8f5"
  }.freeze
  COLOR_FIELDS = DEFAULT_COLORS.keys.map(&:to_s).freeze

  validates :brand, :page_title, :meta_description, :role, :hero_title, :hero_intro,
    :hero_body, :about_kicker, :about_title, :about_body, :projects_kicker,
    :projects_title, :projects_body, :contact_kicker, :contact_title,
    :contact_email, presence: true
  validates :theme_mode, inclusion: { in: THEME_MODES }
  validates :light_background, :light_text, :light_surface, :light_muted,
    :light_border, :dark_background, :dark_text, :dark_surface, :dark_muted,
    :dark_border, format: { with: /\A#[0-9a-fA-F]{6}\z/ }
  validates :light_grid_thickness, :dark_grid_thickness,
    numericality: { only_integer: true, in: GRID_THICKNESS_RANGE }

  def self.current
    first_or_create!(default_attributes)
  end

  def self.default_attributes
    {
      show_animation_toggle: true,
      show_theme_toggle: true,
      background_pattern: true,
      light_grid_thickness: 1,
      dark_grid_thickness: 1,
      **DEFAULT_COLORS,
      hero_intro: "A software developer focused on building reliable, maintainable applications across the web stack.",
      hero_body: "I enjoy turning product ideas into practical software, with attention to clean architecture, readable code, performance, and user experience.",
      about_title: "I build software with a focus on clarity, reliability, and long-term maintainability.",
      about_body: "My work spans frontend interfaces, backend systems, databases, integrations, and deployment workflows. I value pragmatic technical decisions, strong communication, and steady delivery.",
      projects_title: "Selected software projects and technical work.",
      projects_body: "These projects highlight practical problem-solving, full-stack development, thoughtful implementation, and the ability to turn requirements into working products.",
      contact_title: "Interested in working together or discussing a project?"
    }
  end
end
