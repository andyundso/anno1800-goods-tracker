class AvailableGoodsController < ApplicationController
  def graph
    render json: GoodFlowGraph.new(AvailableGood.find(params[:id])).render
  end

  def show
    @available_good = AvailableGood.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("modal", template: "available_goods/show")
        ]
      end
      format.html { render :show }
    end
  end
end
