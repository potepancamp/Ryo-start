require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  describe "GET #show" do
    context "通常のカテゴリ（id が 1, 2 以外）" do
      let(:taxon) { create(:taxon, id: 3, name: "通常カテゴリ") }
      let(:product) { create(:product, taxons: [taxon]) }

      before do
        get category_path(taxon.id)
      end

      it "ステータスの確認" do
        expect(response).to have_http_status(200)
      end

      it "商品名がレスポンスに含まれていること" do
        expect(response.body).to include(taxon.name)
        taxon.products.includes(variants: [:prices, { images: :attachment_blob }]).each do |product|
          expect(response.body).to include(product.name)
          expect(response.body).to include(product.display_price.to_s)
        end
      end

      it "パンくずにカテゴリ名が含まれる" do
        expect(response.body).to include("ホーム")
        expect(response.body).to include(taxon.name)
      end
    end

    context "特殊カテゴリ（id が 1 または 2）" do
      let(:taxon) { create(:taxon, id: 1, name: "特別カテゴリ") }
      let!(:product) { create(:product, taxons: [taxon]) }

      before do
        get category_path(taxon.id)
      end

      it "パンくずにカテゴリ名が含まれない" do
        expect(response.body).to include("ホーム")
        expect(response.body).not_to include(taxon.name)
      end
    end
  end
end
