class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  # before_action :authorize_user
  # GET /categories or /categories.json
  def index
    @categories = Category.with_deleted.order('id DESC').page(params[:page]).per(5)
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    @parents = Category.all
  end

  # GET /categories/1/edit
  def edit
    @parents = Category.all
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        url = S3UploadService.upload(file: params[:category][:image_url], folder: 'categories')
        @category.image_url = url
        @category.save
        format.html { redirect_to categories_path, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        @parents = Category.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        @parents = Category.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    category_childs = Category.with_deleted.find_by(parent_id: params[:id])
    product_childs = Product.with_deleted.find_by(category_id: params[:id])
    if category_childs.nil? && product_childs.nil?
      Category.destroy(params[:id])
      message = "Category was successfully destroyed"
      respond_type = "notice"
    else
      message = "Cannot destroy category because of having children category or product"
      respond_type = "alert"
    end
    respond_to do |format|
      format.html { redirect_to categories_path, status: :see_other, "#{respond_type}": message }
      format.json { head :no_content }
    end
  end

  def restore
    Category.restore(params[:id])
    respond_to do |format|
      format.html { redirect_to categories_path, status: :see_other, notice: "Category was successfully restored." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :image_url, :parent_id)
  end

  def authorize_user
    authorize current_user
  end
end
