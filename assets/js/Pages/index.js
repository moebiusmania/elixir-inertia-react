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
