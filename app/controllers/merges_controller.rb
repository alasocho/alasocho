class MergesController < ApplicationController
  def new
    load_mergeable_user
  end

  def create
    load_mergeable_user
    current_user.merge_with(@mergeable_user)
    redirect_to edit_account_path, notice: t("merges.create.success", user_name: @mergeable_user.name)
  end

private
  def load_mergeable_user
    @mergeable_user = User.find(session[:authorized_user_id])
  end
end
