class GamesController < ApplicationController
  before_action :store_username, only: %i[create show]

  def show
    begin
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @non_existing = true
      render "new"
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create!
    render json: { id: @game.id }
  end

  private

  def store_username
    unless params[:username].blank?
      session[:username] = params[:username]
    end
  end
end
