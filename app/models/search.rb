class Search
  CATEGORIES = %w(Questions Answers Comments Users)

  def self.find(query, category)
    secure_query = ThinkingSphinx::Query.escape(query)
    if CATEGORIES.include?(category)
      model = category.singularize.classify.constantize
      model.search secure_query
    else
      ThinkingSphinx.search secure_query
    end
  end
end