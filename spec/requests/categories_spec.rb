require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  describe "GET /categories/:id" do
    let(:product) { create(:product) }
    let(:taxon)   { create(:taxon, products: [product]) }
    let(:image)   { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    describe "レスポンスステータス" do
      it "200 OKであること" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "ページタイトル" do
      it "にカテゴリ名が含まれていること" do
        expect(response.body).to include("#{taxon.name} - BIGBAG Store")
      end
    end

    describe "パンくずリスト" do
      it "ホームリンクが含まれていること" do
        expect(response.body).to include("ホーム")
      end

      it "カテゴリ名が含まれていること" do
        expect(response.body).to include(taxon.name)
      end

      it "Categoriesが含まれていないこと" do
        expect(response.body).not_to include("Categories")
      end

      it "Brandが含まれていないこと" do
        expect(response.body).not_to include("Brand")
      end
    end

    describe "商品情報" do
      it "商品名が含まれていること" do
        expect(response.body).to include(product.name)
      end

      it "商品価格が含まれていること" do
        expect(response.body).to include(product.price.to_s)
      end
    end
  end
end
