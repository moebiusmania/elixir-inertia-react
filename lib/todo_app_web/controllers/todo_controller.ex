defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller
  alias Inertia.Controller
  alias TodoApp.TodoList
  alias TodoApp.TodoList.Todo

  def index(conn, _params) do
    todos = TodoList.list_todos()
    Controller.render_inertia(conn, "Home", %{todos: todos})
  end

  def new(conn, _params) do
    Controller.render_inertia(conn, "NewTodo", %{})
  end

  def create(conn, %{"todo" => todo_params}) do
    case TodoList.create_todo(todo_params) do
      {:ok, _todo} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: Routes.todo_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Failed to create todo.")
        |> Controller.render_inertia("NewTodo", %{changeset: changeset})
    end
  end
end
