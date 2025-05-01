RSpec.describe "Products", type: :request do
  describe "GET /products/:id" do
    let(:ancestor) { create(:taxon, name: "親カテゴリー") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let!(:related_products) { create_list(:product, 5, taxons: [taxon]) }

    # 画像を関連商品に紐づける
    before do
      # 画像をメイン商品に追加
      product.images << create(:image)

      # 画像を関連商品に追加
      related_products.each do |related_product|
        related_product.images << create(:image)
      end

      get product_path(product.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリ商品のタイトルが含まれていること" do
      expect(response.body).to include("#{product.name} - BIGBAG Store")
    end

    it "カテゴリ商品が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにテストカテゴリーが含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "関連商品の名前が最大4件含まれていること" do
      related_products.first(4).each do |related_product|
        expect(response.body).to include(related_product.name)
      end

      expect(response.body).not_to include(related_products[4].name)
    end

    it "関連商品の価格が含まれていること" do
      related_products.each do |related_product|
        expect(response.body).to include(related_product.display_price.to_s)
      end
    end

    it "関連商品の画像が含まれていること" do
      related_products.each do |related_product|
        expect(related_product.images).to be_present
      end
    end
  end
end
