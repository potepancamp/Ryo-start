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

  # -----------------------------------
  context "taxonが最上位親カテゴリではない場合" do
    let(:parent_taxon) { create(:taxon, name: "最上位カテゴリ") }
    let(:taxon)        { create(:taxon, name: "カテゴリ", parent: parent_taxon) }
    let(:product)      { create(:product, name: "下位カテゴリ商品", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    include_examples "共通レスポンスチェック"

    it "カテゴリ名がパンくずに表示されていること" do
      breadcrumb = Nokogiri::HTML(response.body).css('.breadcrumb')
      expect(breadcrumb.to_s).to include(taxon.name)
    end
  end

  # -----------------------------------
  context "taxonが最上位親カテゴリの場合" do
    let(:taxon)   { create(:taxon, name: "最上位カテゴリ", parent: nil) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get category_path(taxon.id)
    end

    include_examples "共通レスポンスチェック"

    it "カテゴリ名がパンくずリストに表示されないこと" do
      breadcrumb = Nokogiri::HTML(response.body).css('.breadcrumb')
      expect(breadcrumb.to_s).not_to include(taxon.name)
    end
  end
end
