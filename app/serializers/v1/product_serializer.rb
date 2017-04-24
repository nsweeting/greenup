module V1
  class ProductSerializer < ApplicationSerializer
    attributes :id, :title, :product_type, :slug, :vendor, :published,
               :published_scope, :published_at, :created_at, :updated_at
  end
end
