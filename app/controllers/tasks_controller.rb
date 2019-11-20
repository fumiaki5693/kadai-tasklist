class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:create, :show, :new, :edit, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]
  
  
  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    else
      redirect_to login_path
    end
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render :index
    end
  end
  
  def show
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def edit
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      render :show
    else
      flash[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
