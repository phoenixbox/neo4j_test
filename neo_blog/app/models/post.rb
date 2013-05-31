class Post < Neo4j::Rails::Model
  property :title, :type => String
  property :description, :type => String
  property :content, :type => String
  property :published_at, :type => Date

  has_n(:comments).to(Comment)
end
