class TagsController < ApplicationController
  before_action :require_authentication
  before_action :require_admin, except: [ :index ]

  def index
    @tags = Tag.joins(:post_tags).group("tags.id").order("COUNT(post_tags.id) DESC").includes(:posts)
    @tags = Tag.all.order(:name) if current_user.admin?
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to tags_path, notice: "Tag berhasil dibuat."
    else
      redirect_to tags_path, alert: "Gagal membuat tag. Nama sudah ada."
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_path, notice: "Tag berhasil dihapus."
  end

  private

  def tag_params
    params.expect(tag: [ :name ])
  end
end
