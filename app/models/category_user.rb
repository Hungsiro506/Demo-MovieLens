class CategoryUser < ActiveRecord::Base
  scope :like, -> { where(like: true) }
  scope :un_like, -> { where(like: false) }

  belongs_to :category
  belongs_to :user
end
