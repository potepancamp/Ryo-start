RSpec.describe "Productsのrequest spec", type: :request do
  describe "GET /products/:id" do
    let(:image) { create(:image) }
    let(:ancestor) { create(:taxon, name: "親カテゴリー") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }

    before do
      product.images << image
      get product_path(product.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリ商品のタイトルが含まれていること" do
      expect(response.body).to include("<title>#{product.name} - BIGBAG Store</title>")
    end

    it "カテゴリ商品が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにホームへのリンクが含まれていること" do
      expect(response.body).to include('<a href="/">ホーム</a>')
    end

    it "パンくずリストにテストカテゴリーが含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストにテストカテゴリーへのリンクが含まれていること" do
      expect(response.body).to include(category_path(taxon.id))
    end

    it "パンくずリストに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end
  end
end
