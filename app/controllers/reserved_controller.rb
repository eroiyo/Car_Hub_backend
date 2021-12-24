# frozen_string_literal: true

class ReservedController < ApplicationController
  def index
    if user_signed_in?
      render json: current_user.reserved_cars
    else
      render json: { message: 'You are not connected' }, status: 401
    end
  end

  def create
    if user_signed_in?
      reserved_car = ReservedCar.new(reserved_params)
      reserved_car.user = current_user
      if reserved_car.save
        render json: { message: 'Car Reserved' }, status: 200
      else
        render json: { message: 'Invalid Data' }, status: 500
      end
    else
      render json: { message: 'You are not connected' }
    end
  end

  def delete
    if user_signed_in?
      if current_user.reserved_cars.find(params[:reserved_id])
        current_user.reserved_cars.delete_by(id: params[:reserved_id])
        render json: { message: 'Reservation Deleted' }, status: 200
      else
        render json: { message: 'Reservation Not Found' }, status: 404
      end
    else
      render json: { message: 'You are not connected' }, status: 401
    end
  end

  private

  def reserved_params
    params.permit(:car_id, :country, :date)
  end
end
