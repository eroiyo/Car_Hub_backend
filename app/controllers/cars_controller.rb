# frozen_string_literal: true

class CarsController < ApplicationController
  def index
    render json: Car.all, status: 200
  end

  def show
    render json: Car.find(params[:id]), status: 200
  end

  def list
    if user_signed_in?
      banneds_ids = current_user.banneds.pluck(:car_id)
      all = Car.all
      result = []
      car_struct = Struct.new(:id, :name, :description, :background_color, :price, :image, :horse_power, :banned)
      all.each do |car|
        ncar = car_struct.new
        ncar.id = car.id
        ncar.name = car.name
        ncar.description = car.description
        ncar.background_color = car.background_color
        ncar.price = car.price
        ncar.horse_power = car.horse_power
        ncar.banned = banneds_ids.include? car.id
        ncar.image = car.image_url
        result.push(ncar)
      end
      render json: result, status: 200
    else
      render json: Car.all, status: 401
    end
  end

  def create
    car = Car.new(car_params)
    car.image.attach(params[:image])
    if car.valid?
      car.save
      render json: { message: 'Car saved!', status: 200 }, status: 200
    else
      render json: { message: car.errors.full_messages, status: 500 }, status: 500
    end
  end

  def custom_index
    if user_signed_in?
      banneds_ids = current_user.banneds.pluck(:car_id)
      render json: Car.where.not(id: banneds_ids), status: 200
    else
      render json: Car.all, status: 401
    end
  end

  private

  def car_params
    params.permit(:name, :description, :background_color, :price, :horse_power, :id, :car_id, :fee, :image)
  end
end
