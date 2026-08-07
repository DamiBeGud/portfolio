module Admin
  class TimelineEntriesController < BaseController
    before_action :set_timeline_entry, only: [ :edit, :update, :destroy, :move_higher, :move_lower ]

    def index
      @timeline_entries = TimelineEntry.ordered
    end

    def new
      @timeline_entry = TimelineEntry.new(category: "experience")
    end

    def create
      @timeline_entry = TimelineEntry.new(timeline_entry_params)

      if @timeline_entry.save
        redirect_to edit_admin_about_section_path, notice: "Timeline entry created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @timeline_entry.update(timeline_entry_params)
        redirect_to edit_admin_about_section_path, notice: "Timeline entry updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @timeline_entry.destroy
      redirect_to edit_admin_about_section_path, notice: "Timeline entry deleted."
    end

    def move_higher
      moved = @timeline_entry.move_higher!
      respond_to_reorder(moved, moved ? "Timeline entry moved up." : "Timeline entry is already first.")
    end

    def move_lower
      moved = @timeline_entry.move_lower!
      respond_to_reorder(moved, moved ? "Timeline entry moved down." : "Timeline entry is already last.")
    end

    private

    def set_timeline_entry
      @timeline_entry = TimelineEntry.find(params[:id])
    end

    def timeline_entry_params
      params.require(:timeline_entry).permit(:category, :meta, :title, :description, :start_month, :start_year, :end_month, :end_year, :current)
    end

    def respond_to_reorder(_moved, message)
      @experience_entries = TimelineEntry.experience
      @education_entries = TimelineEntry.education

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = message
          render turbo_stream: [
            turbo_stream.replace("timeline-list", partial: "admin/about_sections/timeline_list", locals: { experience_entries: @experience_entries, education_entries: @education_entries }),
            turbo_stream.replace("admin-flashes", partial: "admin/shared/flashes")
          ]
        end
        format.html { redirect_to edit_admin_about_section_path, notice: message }
      end
    end
  end
end
