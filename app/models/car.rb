# frozen_string_literal: true

class Car < ApplicationRecord
  has_one_attached :image
  validates :image, {
    presence: true
  }
  validates :name, presence: true, length: { maximum: 100, too_long: 'the name must not exceed 100 characters' }
  validates :description, presence: true, length: { maximum: 250, too_long: 'the description must not exceed 250 characters' }
  validates :price, numericality: { greater_than: 0 }
  validates :fee, numericality: { greater_than: 0 }
  validates :horse_power, numericality: { greater_than: 0 }
  validates :background_color, presence: true, format: { with: /\A#[0123456789ABCDEFabcdef]{6}\Z/, message: 'please enter keywords in correct format' }
  before_save :parse

  def image_url
    image.service_url
  end

  def total_price
    price + fee
  end

  def as_json(_options = {})
    { id: id,
      name: name,
      description: description,
      background_color: background_color,
      price: price,
      fee: fee,
      total_price: total_price,
      image: image_url,
      horse_power: horse_power }
  end

  private

  def parse
    self.fee = fee.to_f
    self.price = price.to_f
    self.horse_power = horse_power.to_f
  end
end
