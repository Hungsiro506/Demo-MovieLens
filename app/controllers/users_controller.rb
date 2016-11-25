class UsersController < ApplicationController
  def show
    @categories = Category.all
    @category_users = current_user.category_users.like
    @un_category_users = current_user.category_users.un_like
    p @category_users
  end
end
