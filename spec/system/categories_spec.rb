require 'rails_helper'

RSpec.describe "Categoriesのsystem spec", type: :system do
  describe "GET /show" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: parent_taxon) }
    let(:product) { create(:product, name: "商品カテゴリ", taxons: [taxon]) }
    let(:image) { create(:image) }
    let!(:unrelated_taxon) { create(:taxon, name: "別カテゴリ") }
    let!(:unrelated_product) { create(:product, name: "表示されてはいけない商品", taxons: [unrelated_taxon]) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    it "テストカテゴリータイトルが表示されること" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
    end

    it "商品カテゴリが表示されていること" do
      expect(page).to have_content(product.name)
    end

    it "別カテゴリに属していない商品が表示されないこと" do
      expect(page).not_to have_content(unrelated_product.name)
    end

    it "商品価格が表示されていること" do
      expect(page).to have_content(product.display_price.to_s)
    end

    it "パンくずリストにホームリンクが表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link 'ホーム', href: root_path
      end
    end

    it "パンくずリストにホームへのリンクが機能すること" do
      within('.breadcrumb') do
        click_on 'ホーム'
      end
      expect(current_path).to eq root_path
    end
  end

  describe "パンくずリストのテスト" do
    context "テストカテゴリーに親カテゴリがある場合" do
      let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
      let(:taxon) { create(:taxon, name: "カテゴリ", parent: parent_taxon) }

      before do
        visit category_path(taxon.id)
      end

      it "テストカテゴリーのリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link taxon.name, href: category_path(taxon.id)
        end
      end

      it "テストカテゴリーへのリンクが機能すること" do
        within('.breadcrumb') do
          click_on taxon.name
        end
        expect(current_path).to eq category_path(taxon.id)
      end
    end

    context "テストカテゴリーに親カテゴリがない場合" do
      let(:taxon) { create(:taxon, name: "最上位カテゴリ", parent: nil) }

      before do
        visit category_path(taxon.id)
      end

      it "最上位カテゴリがパンくずリストに表示されないこと" do
        within('.breadcrumb') do
          expect(page).to have_no_content(taxon.name)
        end
      end
    end
  end
end
