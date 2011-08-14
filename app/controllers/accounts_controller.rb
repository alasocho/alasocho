class AccountsController < ApplicationController
  before_filter :authenticate_user

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = t("accounts.edit.message.success")
      redirect_to edit_account_path
    else
      render :action => :edit
    end
  end
end
