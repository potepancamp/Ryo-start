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

    it "レスポンスが200 OKであること" do
      expect(response).to have_http_status(:ok)
    end

    it "レスポンスにページタイトルが含まれていること" do
      expect(response.body).to include("#{taxon.name} - BIGBAG Store")
    end

    it "レスポンスにパンくずリストが正しく含まれていること" do
      expect(response.body).to include("ホーム")
      expect(response.body).to include(taxon.name)
      expect(response.body).not_to include("Categories")
      expect(response.body).not_to include("Brand")
    end

    it "レスポンスに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "レスポンスに商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end
  end
end
