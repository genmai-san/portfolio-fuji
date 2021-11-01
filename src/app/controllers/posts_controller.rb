class PostsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @post = Post.new(post_params)
    redirect_to root_path
    if @post.save
      flash[:notice] = "投稿が保存されました"
    else
      flash[:alert] = "投稿に失敗しました"
    end
  end

  def index
    @post = Post.new
    @post.photos.build
    @post.build_map
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).limit(10).includes(:map, :photos, :user).order('created_at DESC')
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      flash[:notice] = "投稿が削除されました" if @post.destroy
    else
      flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:caption, map_attributes: %i[address latitude longitude], photos_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end
