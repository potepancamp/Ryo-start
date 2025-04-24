require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  shared_examples "共通レスポンスチェック" do
    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルが含まれていること" do
      expect(response.body).to include("#{taxon.name} - BIGBAG Store")
    end

    it "商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.price.to_s)
    end

    it "ホームが含まれていること" do
      expect(response.body).to include("ホーム")
    end
  end

  context "taxonが最上位親カテゴリではない場合" do
    let(:parent_taxon) { create(:taxon, name: "最上位カテゴリ") }
    let(:taxon) { create(:taxon, name: "カテゴリ", parent: parent_taxon) }
    let(:product) { create(:product, name: "下位カテゴリ商品", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    include_examples "共通レスポンスチェック"

    it "カテゴリ名がレスポンスに含まれていること（親カテゴリがある場合）" do
      breadcrumb_html = response.body[/<!-- BEGIN breadcrumb -->(.*?)<!-- END breadcrumb -->/m, 1]
      expect(breadcrumb_html).to include(taxon.name)
    end
  end

  context "taxonが最上位親カテゴリの場合" do
    let(:taxon) { create(:taxon, name: "最上位カテゴリ", parent: nil) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    include_examples "共通レスポンスチェック"

    it "最上位カテゴリ名がレスポンスに含まれていないこと" do
      breadcrumb_html = response.body[/<!-- BEGIN breadcrumb -->(.*?)<!-- END breadcrumb -->/m, 1]
      expect(breadcrumb_html).not_to include(taxon.name)
    end
  end
end
