# Elixir + Inertia + React POC

> A PoC to demonstrate the integration of React and Elixir with Phoenix Framework in a monolith codebase using IntertiaJS. The project is a simple todo list app using SQLlite for persistance.

### Requirements

- Node.js
- Elixir
- Phoenix framework

### Getting started

- clone the repo
- install the frontend dependencies

```bash
$ cd assets
$ npm ci
$ cd ..
```

- install the backend dependencies

```bash
$ mix setup
```

- run the project

```bash
$ mix phx.server
```

the application will be available at `http://localhost:4000`

### ChatGPT

I've created the project following a ChatGPT "guide" since I'm not proficient in Elixir, and did some tweaks where needed.

The prompt is [available here](./prompt.md).
