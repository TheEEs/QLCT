class PasswordChangesController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    current_password = params.dig(:user, :current_password)
    new_password = params.dig(:user, :password)
    password_confirmation = params.dig(:user, :password_confirmation)

    if current_password.blank?
      @user.errors.add(:current_password, :blank)
    elsif !@user.authenticate(current_password)
      @user.errors.add(:current_password, t("password_changes.errors.incorrect"))
    end

    if new_password.blank?
      @user.errors.add(:password, :blank)
    end

    if @user.errors.any?
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(password: new_password, password_confirmation: password_confirmation)
      redirect_to root_path, notice: t("password_changes.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.session.user
  end
end
