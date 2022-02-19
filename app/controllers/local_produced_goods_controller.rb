class LocalProducedGoodsController < ApplicationController
  before_action :set_island

  def create
    @local_produced_good = LocalProducedGood.new(local_produced_goods_params)
    @local_produced_good.island = @island

    if @local_produced_good.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash",
              locals: {message: "#{@local_produced_good.good.name} auf #{@local_produced_good.island.name} wurde erfasst."})
          ]
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @local_produced_good = LocalProducedGood.new
  end

  private

  def local_produced_goods_params
    params.require(:local_produced_good).permit(
      :production,
      :consumption,
      :good_id,
      :island_id,
      input_goods_attributes: %i[id input_good_id good_id _destroy]
    )
  end

  def set_island
    @island = Island.find(params[:island_id])
  end
end
