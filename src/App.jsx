import React, { useEffect, useState } from "react";
import { gen } from "./utils/password";

export default function App() {
  const [pw, setPw] = useState([]);
  const [copied, setCopied] = useState(null);

  const genAll = (n = 5, l = 12) => {
    const a = [];
    for (let i = 0; i < n; i++) a.push(gen(l));
    setPw(a);
  };

  useEffect(() => {
    genAll();
  }, []);

  const cp = async (t, i) => {
    try {
      await navigator.clipboard.writeText(t);
      setCopied(i);
      setTimeout(() => setCopied(null), 1500);
    } catch (e) {}
  };

  return (
    <div className="wrap">
      <h1>Пароли</h1>
      <div className="list">
        {pw.map((p, i) => (
          <div key={i} className="item">
            <span className="p">{p}</span>
            <button onClick={() => cp(p, i)}>{copied === i ? "Скопировано" : "Копировать"}</button>
          </div>
        ))}
      </div>
      <div className="controls">
        <button onClick={() => genAll()}>Обновить</button>
        <button onClick={() => cp(pw.join("\n"), -1)}>Копировать все</button>
      </div>
    </div>
  );
}
