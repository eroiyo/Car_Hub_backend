# frozen_string_literal: true

class BannedsController < ApplicationController
  def toggle
    if user_signed_in?
      if current_user.banneds.find_by(car_id: params[:car_id])
        current_user.banneds.delete_by(car_id: params[:car_id])
        render json: { message: 'The car will appear in the list' }
      else
        banned = Banned.new
        banned.user_id = current_user.id
        banned.car_id = params[:car_id]
        if banned.save
          render json: { message: 'The car will not appear in the list' }
        else
          render json: { message: 'invalid car_id' }
        end
      end
    else
      render json: { message: 'You are not connected' }
    end
  end
end
