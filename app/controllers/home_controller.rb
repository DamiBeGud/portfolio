class HomeController < ApplicationController
  def index
    @settings = SiteSetting.current
    @experience_entries = TimelineEntry.experience
    @education_entries = TimelineEntry.education
    @info_cards = InfoCard.ordered
    @projects = Project.ordered
    @contact_links = ContactLink.ordered
  end
end
