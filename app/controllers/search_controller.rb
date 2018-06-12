class SearchController < ApplicationController
    def search
      @query = params[:query]
      @category = params[:category]
      @results = Search.find(@query, @category) if @query.present?
    end
end