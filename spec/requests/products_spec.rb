# spec/requests/products_show_spec.rb
require 'rails_helper'

RSpec.describe "Products Show Page", type: :request do
  let!(:product) { create(:product) }  # FactoryBotを使って製品データを作成
  
  describe "GET /products/:id" do
    before do
      get product_path(product.id) # 製品ページをリクエスト
    end

    it "returns a successful response" do
      expect(response).to have_http_status(200) # レスポンスが成功か確認
    end

    it "displays the product name" do
      expect(response.body).to include(product.name) # 商品名が表示されているか確認
    end

    it "displays the product price" do
      expect(response.body).to include(product.price.to_s) # 商品価格が表示されているか確認
    end
  end
end
