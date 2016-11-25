class CategoriesController < ApplicationController
  def create
    @category = Category.new(name: params[:category])
    if @category.valid?
      @category.save
      redirect_to user_path(current_user.id)
    else
      redirect_to user_path(current_user.id)
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.delete
    redirect_to user_path(current_user.id)
  end

  def like
    @category_user = current_user.category_users.new(category_id: params[:category])
    if @category_user.valid?
      @category_user.save
      redirect_to user_path(current_user.id)
    else
      redirect_to user_path(current_user.id)
    end
  end

  def unlike
    @category_user = current_user.category_users.new(category_id: params[:category])
    if @category_user.valid?
      @category_user.like = false
      @category_user.save
      redirect_to user_path(current_user.id)
    else
      redirect_to user_path(current_user.id)
    end
  end

  def remove_like
    @category_user = CategoryUser.find(params[:id])
    @category_user.delete
    redirect_to user_path(current_user.id)
  end

end
