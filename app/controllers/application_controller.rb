class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # include Pagy::Backend

  before_action :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale] || cookies[:locale]
    if I18n.available_locales.map(&:to_s).include?(parsed_locale)
      cookies[:locale] = { value: parsed_locale, expires: 1.year.from_now, same_site: :lax }
      parsed_locale
    else
      nil
    end
  end

  def pundit_user
    Current.user
  end

  def user_not_authorized
    flash[:alert] = t("pundit.errors.not_authorized", default: "Bạn không có quyền thực hiện thao tác này.")
    redirect_back_or_to root_path
  end
end
