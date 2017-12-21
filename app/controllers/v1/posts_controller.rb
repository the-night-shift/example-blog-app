class V1::PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    posts = Post.all
    render json: posts.as_json
  end

  def create
    post = Post.new(
      title: params[:title],
      body: params[:body],
      image: "https://picsum.photos/200/300/?random",
      user_id: current_user.id
    )
    if post.save
      render json: post.as_json
    else
      render json: {errors: post.errors.full_messages}, status: :bad_request
    end
  end

  def show
    post = Post.find_by(id: params[:id])
    render json: post.as_json
  end

  def update
    post = Post.find_by(id: params[:id])
    post.title = params[:title] || post.title
    post.body = params[:body] || post.body
    if post.save
      render json: post.as_json
    else
      render json: {errors: post.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
    render json: {message: "Post successfully destroyed!"}
  end
end
