module Admin
  class ProjectsController < BaseController
    before_action :set_project, only: [:edit, :update, :destroy, :move_higher, :move_lower]

    def index
      @settings = SiteSetting.current
      @projects = Project.ordered
    end

    def update_section
      @settings = SiteSetting.current

      if @settings.update(projects_section_params)
        redirect_to admin_projects_path, notice: "Projects section updated."
      else
        @projects = Project.ordered
        render :index, status: :unprocessable_entity
      end
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)

      if @project.save
        redirect_to admin_projects_path, notice: "Project created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @project.update(project_params)
        redirect_to admin_projects_path, notice: "Project updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
      redirect_to admin_projects_path, notice: "Project deleted."
    end

    def move_higher
      moved = @project.move_higher!
      respond_to_reorder(moved ? "Project moved up." : "Project is already first.")
    end

    def move_lower
      moved = @project.move_lower!
      respond_to_reorder(moved ? "Project moved down." : "Project is already last.")
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :description, :technologies, :live_url, :source_url, :preview_style, :sort_order, :image)
    end

    def projects_section_params
      params.require(:site_setting).permit(:projects_kicker, :projects_title, :projects_body)
    end

    def respond_to_reorder(message)
      @projects = Project.ordered

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = message
          render turbo_stream: [
            turbo_stream.replace("projects-list", partial: "admin/projects/projects_list", locals: { projects: @projects }),
            turbo_stream.replace("admin-flashes", partial: "admin/shared/flashes")
          ]
        end
        format.html { redirect_to admin_projects_path, notice: message }
      end
    end
  end
end
