const API = '../server/index.php/api/personas';
const form = document.getElementById('persona-form');
const tableBody = document.querySelector('#personas-table tbody');
const cancelBtn = document.getElementById('cancel-btn');

document.addEventListener('DOMContentLoaded', loadPersonas);

form.addEventListener('submit', async e => {
  e.preventDefault();
  // Validación simple: campos requeridos ya marcados en HTML
  const payload = {
    ci: document.getElementById('ci').value.trim(),
    nombre: document.getElementById('nombre').value.trim(),
    apellidos: document.getElementById('apellidos').value.trim(),
    fecha_nac: document.getElementById('fecha_nac').value || null,
    telefono: document.getElementById('telefono').value.trim() || null
  };
  const id = document.getElementById('persona_id').value;
  const method = id ? 'PUT' : 'POST';
  const url = id ? `${API}/${id}` : API;

  const res = await fetch(url, {
    method,
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify(payload)
  });
  if (res.ok) {
    resetForm();
    loadPersonas();
  } else {
    alert('Error al guardar');
  }
});

cancelBtn.addEventListener('click', resetForm);

async function loadPersonas() {
  const res = await fetch(API);
  const data = await res.json();
  tableBody.innerHTML = '';
  data.forEach(p => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${p.ci}</td>
      <td>${p.nombre}</td>
      <td>${p.apellidos}</td>
      <td>${p.telefono||''}</td>
      <td>
        <button data-id="${p.persona_id}" class="edit-btn">✎</button>
        <button data-id="${p.persona_id}" class="del-btn">🗑️</button>
      </td>`;
    tableBody.appendChild(tr);
  });
  // Asignar eventos a botones
  document.querySelectorAll('.edit-btn').forEach(btn =>
    btn.addEventListener('click', () => loadPersona(btn.dataset.id))
  );
  document.querySelectorAll('.del-btn').forEach(btn =>
    btn.addEventListener('click', () => deletePersona(btn.dataset.id))
  );
}

async function loadPersona(id) {
  const res = await fetch(`${API}/${id}`);
  const p = await res.json();
  document.getElementById('persona_id').value = p.persona_id;
  document.getElementById('ci').value = p.ci;
  document.getElementById('nombre').value = p.nombre;
  document.getElementById('apellidos').value = p.apellidos;
  document.getElementById('fecha_nac').value = p.fecha_nac || '';
  document.getElementById('telefono').value = p.telefono || '';
  cancelBtn.hidden = false;
}

async function deletePersona(id) {
  if (!confirm('¿Seguro que quieres eliminar?')) return;
  await fetch(`${API}/${id}`, { method: 'DELETE' });
  loadPersonas();
}

function resetForm() {
  form.reset();
  document.getElementById('persona_id').value = '';
  cancelBtn.hidden = true;
}
