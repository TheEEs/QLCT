class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  #include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def pundit_user
    Current.user
  end

  def user_not_authorized
    flash[:alert] = t("pundit.errors.not_authorized", default: "Bạn không có quyền thực hiện thao tác này.")
    redirect_back_or_to root_path
  end
end
