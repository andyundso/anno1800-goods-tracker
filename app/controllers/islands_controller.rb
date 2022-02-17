class IslandsController < ApplicationController
  before_action :set_game

  def create
    @island = Island.new(island_params)
    @island.game = @game

    if @island.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash",
              locals: {message: "#{@island.name} wurde angelegt."})
          ]
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Island.find(params[:id]).destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("flash", partial: "shared/flash", locals: {message: "Insel wurde gelöscht."})
        ]
      end
    end
  end

  def edit
    @island = Island.find(params[:id])
  end

  def new
    @island = Island.new
  end

  def update
    @island = Island.find(params[:id])

    if @island.update(island_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash",
              locals: {message: "#{@island.name} wurde aktualisiert."})
          ]
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def island_params
    params.require(:island).permit(:name, :region_id)
  end
end
