class NotesController < ApplicationController
before_action :set_book
before_action :set_note, only: [ :edit, :update, :destroy ]

# POST /books/:book_id/notes
def create
   @note = @book.notes.build(note_params)
   @note.user = current_user

   if @note.save
      respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: book_path(@book), notice: "Note added successfully.") }
      end
   else
      respond_to do |format|
      format.turbo_stream do
         render turbo_stream: turbo_stream.replace(
            "note_form",
            partial: "notes/form",
            locals: { book: @book, note: @note }
         )
      end
      format.html { redirect_back(fallback_location: book_path(@book), alert: "Cannot add empty note.") }
      end
   end
end

# GET /books/:book_id/notes/:id/edit
def edit
end

# PATCH/PUT /books/:book_id/notes/:id
def update
   if @note.update(note_params)
      redirect_back(fallback_location: book_path(@book), notice: "Note updated successfully.")
   else
      render :edit
   end
end

# DELETE /books/:book_id/notes/:id
def destroy
   @note.destroy
   redirect_back(fallback_location: book_path(@book), notice: "Note deleted successfully.")
end

private

def set_book
   @book = Book.find(params[:book_id])
end

def set_note
   @note = @book.notes.find(params[:id])
end

def note_params
   params.require(:note).permit(:content)
end
end
