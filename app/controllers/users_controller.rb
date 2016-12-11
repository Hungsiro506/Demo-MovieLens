class UsersController < ApplicationController
  def show
    @categories = Category.all.where.not(id: current_user.category_users.pluck(:category_id).uniq)
    @ratings = Movie.where(id: current_user.rateds.pluck(:movie_id))
    @category_users = current_user.category_users.like
    @un_category_users = current_user.category_users.un_like
  end
end
