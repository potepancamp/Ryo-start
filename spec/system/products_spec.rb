require 'rails_helper'

RSpec.describe "Products Show Page", type: :system do
  shared_examples "パンくずリストの表示内容（Systemテスト版）" do
    it "ホームリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link 'ホーム', href: root_path
      end
    end

    it "商品名がパンくずリストに表示されること（リンクではない）" do
      within(all('.breadcrumb').first) do
        expect(page).to have_content product.name
        expect(page).not_to have_link product.name
      end
    end
  end

  shared_examples "パンくずリストのリンク遷移" do
    it "ホームリンクが機能すること" do
      within(all('.breadcrumb').first) { click_link 'ホーム' }
      expect(current_path).to eq root_path
    end
  end

  shared_examples "商品情報の表示確認" do
    it "ページタイトルが表示されること" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
    end

    it "商品名が表示されること" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示されること" do
      expect(page).to have_content product.price.to_s
    end
  end

  context "【3階層構成】親カテゴリ → 子カテゴリ → 商品カテゴリ → 商品名" do
    let(:grandparent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:parent_taxon) { create(:taxon, name: "子カテゴリ", parent: grandparent_taxon) }
    let(:taxon) { create(:taxon, name: "商品カテゴリ", parent: parent_taxon) }
    let(:product) { create(:product, name: "商品名", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    include_examples "パンくずリストの表示内容（Systemテスト版）"
    include_examples "パンくずリストのリンク遷移"
    include_examples "商品情報の表示確認"
  end

  context "【2階層構成】親カテゴリ → 商品名" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { parent_taxon }
    let(:product) { create(:product, name: "商品名", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    include_examples "パンくずリストの表示内容（Systemテスト版）"
    include_examples "パンくずリストのリンク遷移"
    include_examples "商品情報の表示確認"
  end
end
