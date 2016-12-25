class Category < ActiveRecord::Base
  scope :like, lambda { joins(:category_users).merge(CategoryUser.like) }
  scope :un_like, lambda { joins(:category_users).merge(CategoryUser.un_like) }

  has_many :category_users
  has_many  :users, through: :category_users
end
