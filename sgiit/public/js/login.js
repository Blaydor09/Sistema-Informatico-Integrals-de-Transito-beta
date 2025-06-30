// public/js/login.js
const API_LOGIN = '../server/index.php/api/login';

document.getElementById('login-form').addEventListener('submit', async e => {
  e.preventDefault();
  const err = document.getElementById('error-msg');
  err.textContent = '';

  const payload = {
    username: document.getElementById('username').value.trim(),
    password: document.getElementById('password').value.trim()
  };

  const res = await fetch(API_LOGIN, {
    method: 'POST',
    credentials: 'include',               // para enviar/recibir la cookie de sesión
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });

  // Si no autenticó, redirige o muestra error
  if (res.status === 401) {
    const { error } = await res.json();
    err.textContent = error || 'Credenciales inválidas';
    return;
  }
  if (!res.ok) {
    err.textContent = 'Error al conectar con el servidor';
    return;
  }

  // Login correcto: redirige a Personas
  window.location.href = 'personas.html';
});
