require 'rails_helper'

RSpec.describe "Products", type: :system do
  describe "商品詳細ページ" do
    let!(:product) { create(:product) }
    let!(:taxon) { create(:taxon, products: [product]) }
    let!(:image) { create(:image) }
    let!(:linkable_taxons) { create_list(:taxon, 4) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    it "ページタイトルが表示されること" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
    end

    it "パンくずリストが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_content "ホーム"
      end
    end

    it "商品名が表示されること" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示されること" do
      expect(page).to have_content product.display_price
    end

    it "パンくずリストのリンクが機能すること" do
      click_on("ホーム")
      expect(current_path).to eq root_path
    end
  end
end


# テスト
RSpec.describe "Categories", type: :system do
  let(:taxon) { create(:taxon) }
  let(:product) { create(:product) }

  before do
    taxon.products << product
    visit category_path(taxon) # カテゴリページにアクセス
  end

  it "カテゴリページが正しく表示されること" do
    expect(page).to have_http_status(200)  # ページが正常に表示されること
    expect(page).to have_content(taxon.name)  # カテゴリ名が表示されていること
  end

  it "パンくずリストが表示され、正しいリンクが含まれていること" do
    expect(page).to have_selector('nav.breadcrumb')  # パンくずリストが表示されていること
    expect(page).to have_link('ホーム', href: root_path)  # 「ホーム」のリンクが正しいこと
    expect(page).to have_link(taxon.name, href: category_path(taxon))  # カテゴリ名のリンクが正しいこと
  end

  it "商品名、価格、画像が表示されていること" do
    expect(page).to have_content(product.name)  # 商品名が表示されていること
    expect(page).to have_content(product.display_price)  # 価格が表示されていること
    expect(page).to have_selector("img[src$='#{product.master.images.first&.attachment(:small)}']")  # 商品画像が表示されていること
  end

  it "商品リンクが正しく機能すること" do
    click_link product.name  # 商品名をクリック
    expect(page).to have_current_path(product_path(product))  # 商品詳細ページに遷移すること
  end
end
