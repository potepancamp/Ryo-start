require 'rails_helper'

RSpec.describe "CategoriesController", type: :system do
  shared_examples "商品情報の表示確認" do
    it "ページタイトルが表示されること" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
    end

    it "商品名が表示されていること" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示されていること" do
      expect(page).to have_content product.price.to_s
    end
  end

  shared_examples "ホームリンクの表示/遷移確認" do
    it "ホームリンクが表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link 'ホーム', href: root_path
      end
    end

    it "ホームへのリンクが機能すること" do
      within('.breadcrumb') do
        click_on 'ホーム'
      end
      expect(current_path).to eq root_path
    end
  end

  context "taxonが最上位親カテゴリではない場合" do
    let(:parent_taxon) { create(:taxon, name: "最上位カテゴリ") }
    let(:taxon)        { create(:taxon, name: "カテゴリ", parent: parent_taxon) }
    let(:product)      { create(:product, name: "下位カテゴリ商品", taxons: [taxon]) }
    let(:image)        { create(:image) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    include_examples "商品情報の表示確認"
    include_examples "ホームリンクの表示/遷移確認"

    it "カテゴリ名のリンクが表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link taxon.name, href: category_path(taxon.id)
      end
    end

    it "カテゴリ名へのリンクが機能すること" do
      within('.breadcrumb') do
        click_on taxon.name
      end
      expect(current_path).to eq category_path(taxon.id)
    end
  end

  context "taxonが最上位親カテゴリの場合" do
    let(:taxon)   { create(:taxon, name: "最上位カテゴリ名", parent: nil) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let(:image)   { create(:image) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    include_examples "商品情報の表示確認"
    include_examples "ホームリンクの表示/遷移確認"

    it "カテゴリ名がパンくずリストに表示されないこと" do
      within('.breadcrumb') do
        expect(page).to have_no_content taxon.name
      end
    end
  end
end
