class ProductVariantsController < ApplicationController
  before_action :set_product_variant, only: %i[ show edit update destroy ]

  # GET /product_variants or /product_variants.json
  def index
    @product_variants = ProductVariant.with_deleted.where(product_id: params[:product_id]).page(params[:page]).per(5)
  end

  # GET /product_variants/1 or /product_variants/1.json
  def show
  end

  # GET /product_variants/new
  def new
    @product = Product.find(params[:product_id])
    @product_variant = @product.product_variants.new
    @sizes = Size.all
    @colors = Color.all
  end

  # GET /product_variants/1/edit
  def edit
    @product = Product.with_deleted.find(params[:product_id])
    @product_variant = ProductVariant.with_deleted.find(params[:id])
    @sizes = Size.all
    @colors = Color.all
  end

  # POST /product_variants or /product_variants.json
  def create
    duplicated_variant = ProductVariant.with_deleted.find_by(product_id: product_variant_params[:product_id], color_id: product_variant_params[:color_id], size_id: product_variant_params[:size_id])
    if duplicated_variant.present?
      @product = Product.find(product_variant_params[:product_id])
      @product_variant = duplicated_variant
      @sizes = Size.all
      @colors = Color.all
      return respond_to do |format|
        format.html { redirect_to new_product_product_variant_path, alert: "Duplicated Product Variant" }
      end
    end
    @product_variant = ProductVariant.new(product_variant_params)
    respond_to do |format|
      if @product_variant.save
        url = S3UploadService.upload(file: product_variant_params[:image_url], folder: "product_variants")
        @product_variant.image_url = url
        @product_variant.save
        format.html { redirect_to product_product_variants_path, notice: "Product variant was successfully created." }
        format.json { render :show, status: :created, location: @product_variant }
      else
        @product = Product.find(params[:product_id])
        @sizes = Size.all
        @colors = Color.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_variants/1 or /product_variants/1.json
  def update
    duplicated_variant = ProductVariant.with_deleted.where.not(id: @product_variant[:id]).find_by(product_id: product_variant_params[:product_id], color_id: product_variant_params[:color_id], size_id: product_variant_params[:size_id])
    old = @product_variant
    if duplicated_variant.present?
      @product = Product.find(product_variant_params[:product_id])
      @product_variant = duplicated_variant
      @sizes = Size.all
      @colors = Color.all
      return respond_to do |format|
        format.html { redirect_to edit_product_product_variant_path(product_variant_params[:product_id], old), alert: "Duplicated Product Variant" }
      end
    end
    respond_to do |format|
      if @product_variant.update(product_variant_params)
        if product_variant_params[:image_url].present?
          url = S3UploadService.upload(file: product_variant_params[:image_url], folder: "product_variants")
          @product_variant.image_url = url
          @product_variant.save
        end
        format.html { redirect_to product_product_variants_path, notice: "Product variant was successfully updated." }
      else
        @product = Product.with_deleted.find(params[:product_id])
        @sizes = Size.all
        @colors = Color.all
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_variants/1 or /product_variants/1.json
  def destroy
    order_item_count = OrderItem.where(product_variant_id: @product_variant.id).size
    message = "Product variant was successfully destroyed."
    type = "notice"
    if order_item_count != 0
      message = "Cannot destroy this product variant (#{order_item_count} order item exist)"
      type = "alert"
    else
      @product_variant.destroy!
    end
    respond_to do |format|
      format.html { redirect_to product_product_variants_path, status: :see_other, "#{type}": message }
      format.json { head :no_content }
    end
  end

  def restore
    ProductVariant.restore(params[:id])
    respond_to do |format|
      format.html { redirect_to product_product_variants_path, status: :see_other, notice: "Product variant was successfully restored." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_variant
    @product_variant = ProductVariant.with_deleted.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def product_variant_params
    params.require(:product_variant).permit(:id, :product_id, :sku, :price, :stock, :color_id, :size_id, :image_url)
  end
end
