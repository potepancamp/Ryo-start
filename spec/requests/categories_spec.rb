require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
  let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: parent_taxon) }
  let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
  let(:image) { create(:image) }

  before do
    product.images << image
    get category_path(taxon.id)
  end

  describe "共通レスポンスチェック" do
    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリーページタイトルが含まれていること" do
      expect(response.body).to include("#{taxon.name} - BIGBAG Store")
    end

    it "商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにホームへのリンクが含まれていること" do
      expect(response.body).to include('<a href="/">ホーム</a>')
    end

    it "パンくずリストにtaxon名が含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストにtaxon名へのリンクが含まれていること" do
      expect(response.body).to include(category_path(taxon.id))
    end
  end
end
