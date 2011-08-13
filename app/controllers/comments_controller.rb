class CommentsController < ApplicationController
  before_filter :authenticate_user

  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to @comment.event, notice: t('comment.form.create')
    else
      redirect_to @comment.event, alert: t('comment.form.create.error')
    end
  end
end
