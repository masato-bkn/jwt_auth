# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    render json: user
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
