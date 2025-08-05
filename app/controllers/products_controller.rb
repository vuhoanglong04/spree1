class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.with_deleted.all.page(params[:page]).per(5)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.without_deleted.all
  end

  # GET /products/1/edit
  def edit
    @categories = Category.without_deleted.all
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        url = S3UploadService.upload(file: product_params[:image_url], folder: "products")
        @product.image_url = url
        @product.save
        format.html { redirect_to products_path, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        @categories = Category.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        S3UploadService.delete_by_url(@product.image_url)
        url = S3UploadService.upload(file: product_params[:image_url], folder: "products")
        @product.image_url = url
        @product.save
        format.html { redirect_to products_path, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        @categories = Category.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def restore
    Product.restore(params[:id])
    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully restored." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.with_deleted.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :brand, :description, :category_id, :image_url)
  end
end
