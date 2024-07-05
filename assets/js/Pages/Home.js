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
