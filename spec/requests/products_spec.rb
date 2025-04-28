RSpec.describe "Products", type: :request do
  describe "GET /products/:id" do
    let(:image) { create(:image) }
    let(:ancestor) { create(:taxon, name: "親カテゴリー") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
    let(:product) { create(:product, taxons: [taxon]) }

    before do
      product.images << image
      get product_path(product.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "商品名が取得できること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が取得できること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "商品詳細ページのタイトルが含まれていること" do
      expect(response.body).to include("<title>#{product.name} - BIGBAG Store</title>")
    end

    it "パンくずリストに現在のカテゴリーが含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストに現在のカテゴリーへのリンクが含まれていること" do
      expect(response.body).to include(category_path(taxon.id))
    end

    it "パンくずリストに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end
  end
end
