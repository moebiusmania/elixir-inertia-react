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
