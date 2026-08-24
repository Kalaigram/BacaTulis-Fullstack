module Admin
  class ReportsController < BaseController
    def index
      @reports = Report.pending_reports.includes(:reporter, :reportable)
    end

    def update
      @report = Report.find(params[:id])

      case params[:action_type]
      when "resolve"
        @report.resolved!
      when "dismiss"
        @report.dismissed!
      when "ban_user"
        if @report.reportable.respond_to?(:user)
          @report.reportable.user.update!(banned: true)
        end
        @report.resolved!
      end

      redirect_to admin_reports_path, notice: "Laporan diperbarui."
    end
  end
end
