class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ new create edit update destroy ]
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = @user.notes.new(note_params)
    respond_to do |format|
      if @note.save
        @notes = @user.notes.order(created_at: :desc)
        flash[:notice] = flash_message(:create, Note)
        format.turbo_stream
        format.json { render :show, status: :created, location: @note }
        flash.discard
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        @notes = @user.notes.order(created_at: :desc)
        flash[:notice] = flash_message(:update, Note)
        format.turbo_stream
        format.json { render :show, status: :created, location: @note }
        flash.discard
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: flash_message(:destroy, Note) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :user_id)
    end
end
