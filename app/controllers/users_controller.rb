class UsersController < ApplicationController
  def show
    @categories_like = Category.all.where.not(id: current_user.category_users.like.pluck(:category_id).uniq)
    @categories_unlike = Category.all.where.not(id: current_user.category_users.un_like.pluck(:category_id).uniq)
    @category_users = current_user.category_users.like
    @un_category_users = current_user.category_users.un_like
    p @category_users
  end
end
