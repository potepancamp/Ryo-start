require 'rails_helper'

RSpec.describe "Products Show Page", type: :system do
  include AncestorsHelper
  shared_examples "パンくずリストの表示内容（Systemテスト版）" do
    it "ホームリンクが表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link 'ホーム', href: root_path
      end
    end

    it "祖先カテゴリのリンクが表示されること" do
      get_ancestors(taxon).each do |ancestor|
        within('.breadcrumb') do
          expect(page).to have_link ancestor.name, href: category_path(ancestor.id)
        end
      end
    end

    it "商品名がパンくずリストに表示されること（リンクではない）" do
      within('.breadcrumb') do
        expect(page).to have_content product.name
        expect(page).not_to have_link product.name
      end
    end
  end

  shared_examples "パンくずリストのリンク遷移" do
    it "ホームリンクが機能すること" do
      within('.breadcrumb') { click_link 'ホーム' }
      expect(current_path).to eq root_path
    end

    it "祖先カテゴリリンクが機能すること" do
      get_ancestors(taxon).each do |ancestor|
        visit product_path(product.id)
        within('.breadcrumb') { click_link ancestor.name }
        expect(current_path).to eq category_path(ancestor.id)
      end
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

  # ------------------------------------------
  context "【3階層構成】親カテゴリ → 子カテゴリ → 商品名" do
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

  # ------------------------------------------
  context "【2階層構成】親カテゴリ → 商品名" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { parent_taxon }  # taxonにparent_taxonを代入（child_taxonなし）
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
