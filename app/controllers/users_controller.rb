# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create!(user_params)

    response.headers['Jwt-Token'] = jwt_token

    render json: @user
  end

  def show
    if Auth::Jwt.valid_user?(jwt: request.headers['Jwt-Token'])
      user = User.find(params[:id])
      render json: user
    else
      render status: 403, json: { message: 'unauthorized user' }
    end
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
