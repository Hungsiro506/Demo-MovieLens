class CategoryUser < ActiveRecord::Base
  scope :like, -> { where(like: true) }
  scope :un_like, -> { where(like: false) }
end
