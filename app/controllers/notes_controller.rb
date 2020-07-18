class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :authenticate_user

  def index
    notes = current_user.notes.all.order(id: "asc")
    render json: notes, status: 200
  end

  def create
    note = current_user.notes.create(note_params)
    if note.save
      render json: note, status: 200
    else
      render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @note
  end

  def update
    if @note.update(note_params)
      render json: "Post updated", status: :no_content
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.delete
    render json: "post deleted", status: :no_content
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :completed, :public_share, :pictures)
  end

  def set_note
    @note = Note.find(params[:id])
  end
end
