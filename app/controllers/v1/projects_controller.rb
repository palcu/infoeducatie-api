module V1
  class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user_from_token!, only: [:create, :finish, :screenshots]

    respond_to :json

    # GET /v1/projects.json
    def index
      # TODO @palcu write a test for this
      current_edition = Edition.get_current
      @projects = Project.active
                         .joins(:contestants)
                         .where(:contestants => { :edition => current_edition })
    end

    # GET /v1/projects/1.json
    def show
    end

    # POST /v1/projects/:id/finish
    def finish
      contestants = current_user.contestants

      project = Project.joins(:contestants).where(:contestants => { :id => current_user.contestants }).where(id: params[:id]).first

      if project.nil?
        render :json => {}, status: :bad_request
      else
        project.update_attribute(:finished, true)
        render :json => {}, status: :ok
      end
    end

    # POST /v1/projects/:id/screenshots
    def screenshots
      @project = Project
        .joins(:contestants)
        .where(:contestants => { :id => current_user.contestants })
        .where(id: params[:id])
        .first

      @project.screenshots << params[:screenshots].map do |key, value|
        Screenshot.new(screenshot: value)
      end

      render :show, status: :created
    end

    # POST /v1/project.json
    def create
      category = Category.find_by(name: params[:project][:category])
      current_edition = Edition.get_current
      contestant = current_user.get_current_contestant

      @project = Project.new(
        project_params.merge({
          category: category,
          contestants: [ contestant ]
        })
      )

      if @project.save
        render :show, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:project).permit(
          :title,
          :description,
          :technical_description,
          :system_requirements,
          :source_url,
          :homepage,
          :category
        )
      end
  end
end
