require 'rails_helper'

RSpec.describe "Categoriesのrequest spec", type: :request do
  describe " GET /Categories/:id" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: parent_taxon) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリーページタイトルが含まれていること" do
      expect(response.body).to include("#{taxon.name} - BIGBAG Store")
    end

    it "カテゴリ商品が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにテストカテゴリー名が含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストにテストカテゴリーへのリンクが含まれていること" do
      expect(response.body).to include(category_path(taxon.id))
    end
  end
end
