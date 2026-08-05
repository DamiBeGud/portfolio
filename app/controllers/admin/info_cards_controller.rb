module Admin
  class InfoCardsController < BaseController
    before_action :set_info_card, only: [:edit, :update, :destroy]

    def index
      @info_cards = InfoCard.ordered
    end

    def new
      @info_card = InfoCard.new
    end

    def create
      @info_card = InfoCard.new(info_card_params)

      if @info_card.save
        redirect_to edit_admin_about_section_path, notice: "Info card created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @info_card.update(info_card_params)
        redirect_to edit_admin_about_section_path, notice: "Info card updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @info_card.destroy
      redirect_to edit_admin_about_section_path, notice: "Info card deleted."
    end

    private

    def set_info_card
      @info_card = InfoCard.find(params[:id])
    end

    def info_card_params
      params.require(:info_card).permit(:title, :body, :tags, :sort_order)
    end
  end
end
