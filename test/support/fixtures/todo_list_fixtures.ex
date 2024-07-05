defmodule TodoApp.TodoListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.TodoList` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> TodoApp.TodoList.create_todo()

    todo
  end
end
