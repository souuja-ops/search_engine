

class SearchesController < ApplicationController
    before_action :authenticate_user!
  
    def create
        if current_user
          query = search_params[:query]
          article = Article.where("lower(title) = ?", query.downcase).first
      
          if article.present?
            current_user.searches.create(query: query, search_time: Time.now)
            render json: { message: 'Search saved successfully' }, status: :ok
          else
            render json: { error: 'Invalid search query' }, status: :unprocessable_entity
          end
        else
          redirect_to new_user_session_path
        end
    end



    private
  
    def search_params
      params.permit(:query)
    end
end
  
  
  

  