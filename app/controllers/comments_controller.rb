class CommentsController < ApplicationController
  before_filter :authenticate_user

  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to @comment.event, notice: t('comments.form.create')
    else
      redirect_to @comment.event, alert: t('comments.form.error')
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @event = Event.find(params[:event_id])

    @comment.destroy
    redirect_to event_path(@event.id), notice: t('comments.form.deleted')
  end
end
