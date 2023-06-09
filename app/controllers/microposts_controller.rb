# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  def on_save
    flash[:success] = 'Micropost created!'
    redirect_to root_url
  end

  def on_failed
    # 投稿失敗した時のためにfeedを与えておく
    @feed_items = current_user.feed.page(params[:page])
    render 'static_pages/home', status: :unprocessable_entity
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    @micropost.save ? on_save : on_failed
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    if request.referer.nil?
      redirect_to root_url, status: :see_other
    else
      # 元のページに戻る
      redirect_to request.referer, status: :see_other
    end
  end

  private

  # strong parameter
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @micropost.nil?
  end
end
