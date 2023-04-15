class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def search
    if params[:query].present?
      @articles = Article.where("lower(title) LIKE ?", "%#{params[:query].downcase}%")
    else
      @articles = Article.all
    end
  
    respond_to do |format|
      format.js
    end
  end

  def show
    @search_data = current_user.searches.group("date_trunc('day', search_time)").count
    @user_search_data = current_user.searches.select(:query, :user_id).group(:query, :user_id).count(:query)
    @most_searched_terms = current_user.searches.group(:query).order('count_all DESC').limit(10).count
  
    render json: {
      search_data: @search_data,
      user_search_data: @user_search_data,
      most_searched_terms: @most_searched_terms
    }
  end
  
end
