# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create!(user_params)

    response.headers['Jwt-Token'] = jwt_token

    # render json: @user
    render :template => "user.json.jb"
  end

  def show
    Auth::Jwt.valify(jwt: request.headers['Jwt-Token'])

    @user = User.find(params[:id])
    render :template => "user.json.jb"
  rescue JWT::ExpiredSignature
    render status: 403, json: { message: '有効期限切れのトークンです' }
  rescue JWT::DecodeError
    render status: 403, json: { message: '認証に失敗しました' }
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def jwt_token
    Auth::Jwt.issue_token(user_info: user_info)
  end

  def user_info
    {
      user_id: @user.id,
      password_digest: @user.password_digest,
      email: @user.email
    }
  end
end
