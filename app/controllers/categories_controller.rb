class CategoriesController < ApplicationController
  before_action :require_authentication
  before_action :require_admin
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.order(:name).includes(:posts)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: "Kategori berhasil dibuat."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Kategori berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Kategori berhasil dihapus. Post terkait menjadi tanpa kategori."
  end

  private

  def set_category
    @category = Category.find_by!(slug: params[:id])
  end

  def category_params
    params.expect(category: [ :name ])
  end
end
