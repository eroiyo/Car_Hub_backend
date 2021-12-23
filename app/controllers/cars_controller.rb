# frozen_string_literal: true

class CarsController < ApplicationController
  def index
    render json: Car.all
  end

  def car_params
    params.permit(:name, :description, :background_color, :price, :image, :horse_power, :id, :car_id)
  end

  def show
    render json: Car.find(params[:id])
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
      render json: result
    else
      render json: Car.all
    end
  end

  def create
    car = Car.new
    car.name = params[:name]
    car.description = params[:description]
    car.background_color = params[:background_color]
    car.price = params[:price]
    car.image.attach.(io: params[:image], filename: "#{params[:name]}.png")
    car.horse_power = (params[:horse_power])
    if car.save
      render json: { message: 'Car saved!' }
    else
      render json: { message: 'invalid parameters' }
    end
  end

  def custom_index
    if user_signed_in?
      banneds_ids = current_user.banneds.pluck(:car_id)
      render json: Car.where.not(id: banneds_ids)
    else
      render json: Car.all
    end
  end
end
