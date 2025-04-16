require 'rails_helper'


RSpec.describe "ProductsController", type: :request do
  let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
  let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
  let(:product) { create(:product,name: "テスト商品", taxons: [child_taxon]) }

  describe "GET /products/:id" do
    before do
      get product_path(product.id)
    end

    it "ステータスコードが200であること" do
      expect(response).to have_http_status(200)
    end

    it "商品名が表示されること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が表示されること" do
      expect(response.body).to include(product.price.to_s)
    end

    it "パンくずリストに正しいカテゴリ名が表示されること" do
      expect(response.body).to include("ホーム")
      expect(response.body).to include(parent_taxon.name)
      expect(response.body).to include(child_taxon.name)
      expect(response.body).to include(product.name)
    end
  end
end
