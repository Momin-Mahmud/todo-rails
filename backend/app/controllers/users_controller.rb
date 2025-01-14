class UsersController < ApplicationController
  before_action :authorized, only: [ :auto_login ]

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created
    else
      render json: { error: "failed to create user" }, status: :not_acceptable
    end
  end

  def login
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :accepted
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def auto_login
    render json: @user
  end

  def user_params
    params.permit(:username, :password, :email, :age)
  end
end
