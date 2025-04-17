require 'rails_helper'

RSpec.describe "ProductsController", type: :request do
  let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
  let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
  let(:product) { create(:product, name: "テスト商品", taxons: [child_taxon]) }

  describe "GET /products/:id" do
    before do
      get product_path(product.id)
    end

    it "レスポンスが200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "レスポンスに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "レスポンスに商品価格が含まれていること" do
      expect(response.body).to include(product.price.to_s)
    end

    it "レスポンスにパンくずリストのカテゴリ名が含まれていること" do
      expect(response.body).to include("ホーム")
      expect(response.body).to include(parent_taxon.name)
      expect(response.body).to include(child_taxon.name)
      expect(response.body).to include(product.name)
    end
  end
end
