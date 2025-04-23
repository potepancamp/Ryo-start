module CategoryConstants
  extend ActiveSupport::Concern

  CATEGORY_NAMES = %w(Clothing Caps Bags Mugs).freeze

  CATEGORY_IMAGE_MAP = {
    'Clothing' => 'cloth.jpg',
    'Caps' => 'cap.jpg',
    'Bags' => 'bag.jpg',
    'Mugs' => 'tableware.jpg',
  }.freeze
end
