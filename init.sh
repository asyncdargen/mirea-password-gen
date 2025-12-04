#!/usr/bin/env bash
set -e

rm -rf simple-passwords simple-passwords.zip
mkdir -p simple-passwords/src/utils

cat > simple-passwords/package.json <<'EOF'
{
  "name": "simple-passwords",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
EOF

cat > simple-passwords/index.html <<'EOF'
<!doctype html>
<html lang="ru">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>Пароли</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

cat > simple-passwords/src/main.jsx <<'EOF'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

cat > simple-passwords/src/App.jsx <<'EOF'
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
EOF

cat > simple-passwords/src/utils/password.js <<'EOF'
export function gen(l = 12) {
  const s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()";
  let r = "";
  for (let i = 0; i < l; i++) {
    r += s[Math.floor(Math.random() * s.length)];
  }
  return r;
}
EOF

cat > simple-passwords/src/index.css <<'EOF'
body{
  margin:0;
  font-family: Arial, sans-serif;
  background:#f3f4f6;
  padding:20px;
}
.wrap{
  max-width:700px;
  margin:20px auto;
  background:#fff;
  padding:16px;
  border-radius:8px;
  box-shadow:0 4px 10px rgba(0,0,0,0.06);
}
h1{font-size:20px;margin:0 0 12px 0}
.list{display:flex;flex-direction:column;gap:8px}
.item{display:flex;align-items:center;gap:8px}
.p{background:#f7f7fb;padding:8px;border-radius:6px;font-family:monospace;flex:1;overflow-wrap:anywhere}
button{padding:8px 10px;border-radius:6px;border:1px solid #ddd;background:#fff;cursor:pointer}
.controls{display:flex;gap:8px;margin-top:12px}
EOF

cat > simple-passwords/.gitignore <<'EOF'
node_modules
dist
.env
EOF

cat > simple-passwords/README.md <<'EOF'
# Простой генератор паролей

Как запустить:
1. Установить зависимости:
   npm install
2. Запустить в режиме разработки:
   npm run dev

Описание:
- Генерирует 5 паролей по 12 символов.
- Можно копировать отдельный пароль или все сразу.
EOF

if command -v zip >/dev/null 2>&1; then
  (cd simple-passwords && zip -r ../simple-passwords.zip .) >/dev/null
else
  (cd simple-passwords && tar -czf ../simple-passwords.tar.gz .)
fi

echo "Готово: папка simple-passwords создана, архив сформирован."