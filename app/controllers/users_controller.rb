class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authorize_user
  # GET /users or /users.json
  def index
    @users = User.with_deleted.all.page(params[:page]).per(5)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @roles = Role.all
  end

  # GET /users/1/edit
  def edit
    @roles = Role.all
  end

  # POST /users or /users.json
  def create
    @roles = Role.all
    @user = User.new(user_params)
    @user.skip_confirmation!
    respond_to do |format|
      if @user.save
        url = S3UploadService.upload(file: params[:user][:image_url], folder: 'users')
        @user.image_url = url
        @user.save
        format.html { redirect_to users_path, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @roles = Role.all
    if user_params[:image_url].present?
      url = S3UploadService.upload(file: params[:user][:image_url], folder: 'users')
      merge_user_params = user_params.merge(image_url: url)
    else
      merge_user_params = user_params
    end

    respond_to do |format|
      if @user.update(merge_user_params)
        format.html { redirect_to users_path, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
    end
  end

  # PATH /users/1/restore
  def restore
    User.restore(params[:id])
    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully restored." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :phone_number, :email, :data_of_birth, :gender, :bio, :image_url, :password, :password_confirmation,
    )
  end

  def authorize_user
    authorize current_user
  end
end
