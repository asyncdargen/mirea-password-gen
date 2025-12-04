export function gen(l = 12) {
  const s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()";
  let r = "";
  for (let i = 0; i < l; i++) {
    r += s[Math.floor(Math.random() * s.length)];
  }
  return r;
}
