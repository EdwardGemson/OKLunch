class RestaurantsController < ApplicationController


  skip_before_action :ensure_current_user

  def index
    # @restaurants = Restaurant.all
    unless current_user
      redirect_to about_path
    else
      if params[:search] != nil
        search_filter = params[:searchfield].to_sym
        target = params[:search]
        @filtered_restaurants = Restaurant.where("#{search_filter} LIKE ?", "%#{target}%")

        @target_restaurant = @filtered_restaurants.next(current_user)
        nil_check
      else
        @target_restaurant = Restaurant.next(current_user)
      end
    end
  end

  def next_unswiped
    render :json => Restaurant.next(current_user).to_json
  end

  def nil_check
    if @target_restaurant == nil
      flash[:alert] = "There are no restaurants under that parameter: please rephrase your search terms and try again."
    end
  end
end

