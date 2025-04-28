require 'rails_helper'

RSpec.describe "Categories", type: :system do
  let!(:unrelated_taxon) { create(:taxon, name: "別カテゴリ") }
  let!(:unrelated_product) { create(:product, name: "表示されてはいけない商品", taxons: [unrelated_taxon]) }

  describe "共通レスポンスチェック" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: parent_taxon) }
    let(:product) { create(:product, name: "商品名", taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    it "カテゴリーページタイトルが表示されること" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
    end

    it "商品名が表示されていること" do
      expect(page).to have_content(product.name)
    end

    it "商品価格が表示されていること" do
      expect(page).to have_content(product.display_price.to_s)
    end

    it "カテゴリに属していない商品が表示されないこと" do
      expect(page).not_to have_content(unrelated_product.name)
    end

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

  describe "パンくずリストのテスト" do
    context "taxonに親カテゴリがある場合" do
      let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
      let(:taxon) { create(:taxon, name: "カテゴリ", parent: parent_taxon) }

      before do
        visit category_path(taxon.id)
      end

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

    context "taxonに親カテゴリがない場合" do
      let(:taxon) { create(:taxon, name: "最上位カテゴリ", parent: nil) }

      before do
        visit category_path(taxon.id)
      end

      it "カテゴリ名がパンくずリストに表示されないこと" do
        within('.breadcrumb') do
          expect(page).to have_no_content(taxon.name)
        end
      end
    end
  end
end
