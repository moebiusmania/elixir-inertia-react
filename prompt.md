To create a simple todo application in Elixir Phoenix using SQLite3, esbuild, and InertiaJS with React for the UI, follow these steps:

### Prerequisites

- Elixir and Phoenix installed
- Node.js and npm installed
- SQLite3 installed

### Step 1: Create a new Phoenix project

```sh
mix phx.new todo_app --database sqlite3 --no-webpack
cd todo_app
```

### Step 2: Configure SQLite3

In `config/dev.exs` and `config/test.exs`, configure the database adapter to use SQLite3:

```elixir
config :todo_app, TodoApp.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "priv/repo/todo_app_dev.sqlite3"
```

### Step 3: Set up the database

Create the database and run migrations:

```sh
mix ecto.create
mix ecto.migrate
```

### Step 4: Set up esbuild

Add esbuild to your `dev.exs` config:

```elixir
config :esbuild,
  version: "0.12.15",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
```

Add esbuild to your dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:phoenix, "~> 1.5.9"},
    {:phoenix_ecto, "~> 4.4"},
    {:ecto_sql, "~> 3.6"},
    {:sqlite_ecto2, "~> 2.2.1"},
    {:phoenix_live_dashboard, "~> 0.4"},
    {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
    {:inertia_phoenix, "~> 0.4.0"}
  ]
end
```

Fetch the dependencies:

```sh
mix deps.get
```

### Step 5: Set up InertiaJS and React

Create a `js` directory in `assets` and set up the basic InertiaJS and React structure.

#### assets/js/app.js

```javascript
import React from "react";
import { render } from "react-dom";
import { InertiaApp } from "@inertiajs/inertia-react";

const el = document.getElementById("app");

render(
  <InertiaApp
    initialPage={JSON.parse(el.dataset.page)}
    resolveComponent={(name) =>
      import(`./Pages/${name}`).then((module) => module.default)
    }
  />,
  el
);
```

#### assets/js/Pages/Home.js

```javascript
import React from "react";

const Home = ({ todos }) => (
  <div>
    <h1>Todo List</h1>
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.title}</li>
      ))}
    </ul>
  </div>
);

export default Home;
```

#### assets/js/Pages/NewTodo.js

```javascript
import React, { useState } from "react";
import { Inertia } from "@inertiajs/inertia";

const NewTodo = () => {
  const [title, setTitle] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    Inertia.post("/todos", { todo: { title } });
  };

  return (
    <div>
      <h1>New Todo</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Todo title"
        />
        <button type="submit">Add Todo</button>
      </form>
    </div>
  );
};

export default NewTodo;
```

#### assets/js/pages/index.js

Create an `index.js` file to serve as the entry point for esbuild:

```javascript
import "../css/app.css";
import "phoenix_html";
import React from "react";
import { render } from "react-dom";
import { InertiaApp } from "@inertiajs/inertia-react";

const el = document.getElementById("app");

render(
  <InertiaApp
    initialPage={JSON.parse(el.dataset.page)}
    resolveComponent={(name) =>
      import(`./Pages/${name}`).then((module) => module.default)
    }
  />,
  el
);
```

Update your `assets/package.json` to include the necessary dependencies:

```json
{
  "dependencies": {
    "@inertiajs/inertia": "^0.8.4",
    "@inertiajs/inertia-react": "^0.5.5",
    "react": "^17.0.2",
    "react-dom": "^17.0.2"
  },
  "devDependencies": {
    "esbuild": "^0.12.15"
  }
}
```

Install the JavaScript dependencies:

```sh
cd assets
npm install
cd ..
```

### Step 6: Set up Phoenix Controllers and Views

Generate the context and schema for the todo list:

```sh
mix phx.gen.context TodoList Todo todos title:string
mix ecto.migrate
```

Create a controller for handling Inertia requests:

#### lib/todo_app_web/controllers/todo_controller.ex

```elixir
defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller
  alias InertiaPhoenix.Controller
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
```

Update your router to include the new routes:

#### lib/todo_app_web/router.ex

```elixir
scope "/", TodoAppWeb do
  pipe_through :browser

  get "/", TodoController, :index
  resources "/todos", TodoController, only: [:index, :new, :create]
end
```

### Step 7: Set up Inertia Phoenix

Update your endpoint configuration to include the Inertia Phoenix plug:

#### lib/todo_app_web/endpoint.ex

```elixir
plug InertiaPhoenix
```

### Step 8: Set up the HTML layout

Update your `lib/todo_app_web/templates/layout/app.html.eex` to include the InertiaJS root element:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>TodoApp</title>
  <%= csrf_meta_tag() %>
  <link rel="stylesheet" href="<%= Routes.static_path(@conn, "/assets/app.css") %>">
  <script defer src="<%= Routes.static_path(@conn, "/assets/app.js") %>"></script>
</head>
<body>
  <div id="app" data-page="<%= raw InertiaPhoenix.page(@conn) %>"></div>
</body>
</html>
```

### Step 9: Run the application

Now, you can run the Phoenix server:

```sh
mix phx.server
```

Navigate to `http://localhost:4000` to see your simple todo application in action!

This setup provides a basic implementation of a todo app using Elixir Phoenix with SQLite3, esbuild, and InertiaJS with React. You can expand upon this by adding more features and improving the UI as needed.
