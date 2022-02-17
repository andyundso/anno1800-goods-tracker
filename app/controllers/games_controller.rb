class GamesController < ApplicationController
  def create
    @game = Game.create!
    redirect_to @game
  end

  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end
end
