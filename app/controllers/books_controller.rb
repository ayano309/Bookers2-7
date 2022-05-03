class BooksController < ApplicationController
   before_action :authenticate_user!
   before_action :correct_user, only:[:edit, :update]
   
  def index
    # @books = Book.all
    @book = Book.new
    @user = current_user
    @books = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @comment = Comment.new
    @comments = @book.comments
  end
  
  
  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to book_path(@book), notice: 'You have created book successfully.'
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end
  
  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    
  end
  
  def update
    @book = current_user.books.find(params[:id])
    if @book.update(book_params)
       redirect_to book_path(@book),notice: 'You have updated book successfully.'
    else
      render :edit
    end
    
  end
  
  def destroy
    book = current_user.books.find(params[:id])
    book.destroy!
    redirect_to books_path, notice: 'Book was successfully destroyed.'
    
  end
  
  private 
  def book_params
    params.require(:book).permit(:title,:body)
    
  end
  
  def correct_user
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user == current_user
  end
  
end
