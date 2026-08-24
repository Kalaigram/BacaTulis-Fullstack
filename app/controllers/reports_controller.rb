class ReportsController < ApplicationController
  before_action :require_authentication

  def create
    @reportable = find_reportable
    @report = current_user.reports.build(
      reportable: @reportable,
      reason: params[:reason],
      description: params[:description]
    )

    if @report.save
      redirect_back fallback_location: root_path, notice: "Laporan berhasil dikirim."
    else
      redirect_back fallback_location: root_path, alert: "Gagal mengirim laporan."
    end
  end

  private

  def find_reportable
    if params[:post_id].present?
      Post.find(params[:post_id])
    elsif params[:comment_id].present?
      Comment.find(params[:comment_id])
    end
  end
end
