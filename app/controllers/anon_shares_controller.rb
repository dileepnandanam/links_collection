class AnonSharesController < ApplicationController
  def show
    @anon_share = AnonShare.decrypt(params[:says])
  end

  def create
    redirect_to anon_share_path(says: AnonShare.new(params.require(:anon_share).permit(:title, :user_name, :text)).encrypt)
  end

  def edit
    if params[:says].present?
      @anon_share = AnonShare.decrypt(params[:says])
    else
      @anon_share = AnonShare.new
    end
  end

  layout 'network'
end