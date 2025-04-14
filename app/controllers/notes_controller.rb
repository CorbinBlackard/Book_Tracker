class NotesController < ApplicationController
def create
  @book = Book.find(params[:book_id])
  @note = @book.notes.build(note_params)
  @note.user = current_user

  if @note.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Note added!" }
    end
  else
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Failed to add note." }
    end
  end
end

  def destroy
    @book = Book.find(params[:book_id])
    @note = @book.notes.find(params[:id])
    @note.destroy
    redirect_to root_path, notice: "Note deleted successfully."
  end

  def edit
    @book = Book.find(params[:book_id])
    @note = @book.notes.find(params[:id])
  end

  def update
    @book = Book.find(params[:book_id])
    @note = @book.notes.find(params[:id])

    if @note.update(note_params)
      redirect_to root_path, notice: "Note updated successfully."
    else
      render :edit
    end
  end
end

private

def note_params
  params.require(:note).permit(:content)
end
