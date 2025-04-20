require 'rails_helper'

RSpec.describe "Products Show Page", type: :system do
  describe "商品詳細ページ" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
    let(:product) { create(:product, name: "テスト商品", taxons: [child_taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    describe "ページタイトル" do
      it "が表示されること" do
        expect(page).to have_title "#{product.name} - BIGBAG Store"
      end
    end

    describe "パンくずリストの表示" do
      it "ホームリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link 'ホーム', href: root_path
        end
      end

      it "親カテゴリリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link parent_taxon.name, href: category_path(parent_taxon.id)
        end
      end

      it "子カテゴリリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link child_taxon.name, href: category_path(child_taxon.id)
        end
      end

      it "商品名がパンくずリストに表示されること（リンクではない）" do
        within('.breadcrumb') do
          expect(page).to have_content product.name
        end
      end
    end

    describe "パンくずリストのリンク機能" do
      it "ホームリンクが機能すること" do
        within('.breadcrumb') { click_link 'ホーム' }
        expect(current_path).to eq root_path
      end

      it "親カテゴリリンクが機能すること" do
        within('.breadcrumb') { click_link parent_taxon.name }
        expect(current_path).to eq category_path(parent_taxon.id)
      end

      it "子カテゴリリンクが機能すること" do
        within('.breadcrumb') { click_link child_taxon.name }
        expect(current_path).to eq category_path(child_taxon.id)
      end
    end

    describe "商品情報の表示" do
      it "商品名が表示されること" do
        expect(page).to have_content product.name
      end

      it "商品価格が表示されること" do
        expect(page).to have_content product.price
      end
    end
  end
end
