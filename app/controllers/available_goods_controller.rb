class AvailableGoodsController < ApplicationController
  def graph
    render json: GoodFlowGraph.new(AvailableGood.find(params[:id])).render
  end

  def show
    @available_good = AvailableGood.find(params[:id])
  end
end
