class TradesController < ApplicationController
  before_action :set_island

  def new
    @trade = Trade.new
  end

  def edit
    @trade = Trade.find(params[:id])
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.island = @island

    if @trade.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash",
              locals: {message: "Speicherstadt-Handel erfolgreich erfasst."})
          ]
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @trade = Trade.find(params[:id])

    if @trade.update(trade_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash",
              locals: {message: "Speicherstadt-Handel wurde aktualisiert."})
          ]
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Trade.find(params[:id]).destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("flash", partial: "shared/flash", locals: {message: "Speicherstadt-Handel gelöscht"})
        ]
      end
    end
  end

  private

  def set_island
    @island = Island.find(params[:island_id])
  end

  def trade_params
    params.require(:trade).permit(:input_good_quantity, :input_good_id, :output_good_quantity, :output_good_id)
  end
end
