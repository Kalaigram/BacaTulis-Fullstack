module Creator
  class BaseController < ApplicationController
    before_action :require_authentication
    before_action :ensure_creator

    private

    def ensure_creator
      redirect_to root_path, alert: "Hanya kreator yang bisa mengakses halaman ini." unless current_user.creator?
    end
  end
end
