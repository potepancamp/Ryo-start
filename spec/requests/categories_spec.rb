require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  describe "GET /categories/:id" do
    let!(:product) { create(:product) }
    let!(:taxon)   { create(:taxon, products: [product]) }
    let!(:image)   { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    it "ステータスコードが200であること" do
      expect(response).to have_http_status(:ok)
    end

    it "ページタイトルが表示されること" do
      expect(response.body).to include("#{taxon.name} - BIGBAG Store")
    end

    it "パンくずリストが正しく表示されること" do
      expect(response.body).to include("ホーム")
      expect(response.body).to include(taxon.name)
      expect(response.body).not_to include("Categories")
      expect(response.body).not_to include("Brand")
    end

    it "商品名が表示されること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が表示されること" do
      expect(response.body).to include(product.display_price.to_s)
    end
  end
end
