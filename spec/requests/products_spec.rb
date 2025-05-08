require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /products/:id" do
    let(:ancestor) { create(:taxon, name: "親カテゴリー") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let(:related_products) { create_list(:product, 5, taxons: [taxon]) }

    # 画像を関連商品に紐づける
    before do
      # 画像をメイン商品に追加
      product.images << create(:image)

      # 画像を関連商品に追加
      related_products.each do |related_product|
        related_product.images << create(:image)
      end

      get product_path(product.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリ商品のタイトルが含まれていること" do
      expect(response.body).to include("#{product.name} - BIGBAG Store")
    end

    it "カテゴリ商品が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにテストカテゴリーが含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "関連商品の名前、価格、画像が最大4件含まれていること" do
      related_products.first(4).all? do |related_product|
        expect(response.body).to include(related_product.name)
        expect(response.body).to include(related_product.display_price.to_s)
        expect(response.body).to include("<img alt=\"#{related_product.name}\"")
      end
    end

    it "関連商品の5件目が含まれないこと" do
      expect(response.body).not_to include(related_products[4].name)
    end
  end
end
