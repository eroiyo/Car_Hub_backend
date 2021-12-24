# frozen_string_literal: true

class MembersController < ApplicationController
  def show
    if user_signed_in?
      render json: { message: "If you see this, you're in!", status: 200 }, status: 200
    else
      render json: { message: 'You are not connected', status: 401 }, status: 401
    end
  end
end
