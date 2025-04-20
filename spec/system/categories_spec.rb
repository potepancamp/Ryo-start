require 'rails_helper'

RSpec.describe "Categories Show Page", type: :system do
  describe "カテゴリー詳細ページ" do
    let(:taxon) { create(:taxon) }
    let(:other_taxon) { create(:taxon) }

    let(:included_product) { create(:product, name: "カテゴリ内商品", taxons: [taxon]) }
    let(:excluded_product) { create(:product, name: "カテゴリ外商品", taxons: [other_taxon]) }

    let(:image) { create(:image) }

    before do
      included_product.images << image
      visit category_path(taxon.id)
    end

    describe "ページタイトル" do
      it "が表示されること" do
        expect(page).to have_title "#{taxon.name} - BIGBAG Store"
      end
    end

    describe "パンくずリスト" do
      it "ホームリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link 'ホーム', href: root_path
        end
      end

      it "カテゴリ名のリンクが表示されること" do
        within('.breadcrumb') do
          expect(page).to have_link taxon.name, href: category_path(taxon.id)
        end
      end

      it "Categoriesリンクは表示されないこと" do
        within('.breadcrumb') do
          expect(page).not_to have_link 'Categories'
        end
      end

      it "Brandリンクは表示されないこと" do
        within('.breadcrumb') do
          expect(page).not_to have_link 'Brand'
        end
      end

      it "ホームへのリンクが機能すること" do
        within('.breadcrumb') do
          click_on 'ホーム'
        end
        expect(current_path).to eq root_path
      end

      it "カテゴリ名へのリンクが機能すること" do
        visit category_path(taxon.id)
        within('.breadcrumb') do
          click_on taxon.name
        end
        expect(current_path).to eq category_path(taxon.id)
      end
    end

    describe "商品表示" do
      it "カテゴリに含まれる商品が表示されること" do
        expect(page).to have_content included_product.name
      end

      it "カテゴリに含まれる商品の価格が表示されること" do
        expect(page).to have_content included_product.price
      end

      it "カテゴリに含まれない商品は表示されないこと" do
        expect(page).not_to have_content excluded_product.name
      end
    end
  end
end
