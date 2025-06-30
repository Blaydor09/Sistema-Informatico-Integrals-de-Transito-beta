const API = '../server/index.php/api/licencias';
const PERSONAS_API = '../server/index.php/api/personas';
const form = document.getElementById('licencia-form');
const tableBody = document.querySelector('#licencias-table tbody');
const cancelBtn = document.getElementById('cancel-btn');
const personaSelect = document.getElementById('persona_id');

const personaMap = {};

document.addEventListener('DOMContentLoaded', async () => {
  await loadPersonasDropdown();
  loadLicencias();
});

form.addEventListener('submit', async e => {
  e.preventDefault();

  const payload = {
    persona_id:       parseInt(personaSelect.value, 10),
    categoria:        document.getElementById('categoria').value.trim(),
    fecha_emision:    document.getElementById('fecha_emision').value,
    fecha_vencimiento:document.getElementById('fecha_vencimiento').value,
    estado:           document.getElementById('estado').value.trim()
  };

  const id = document.getElementById('licencia_id').value;
  const method = id ? 'PUT' : 'POST';
  const url = id ? `${API}/${id}` : API;

  const res = await fetch(url, {
    method,
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify(payload)
  });
  if (res.ok) {
    resetForm();
    loadLicencias();
  } else {
    alert('Error al guardar la licencia');
  }
});

cancelBtn.addEventListener('click', resetForm);

async function loadPersonasDropdown() {
  const res = await fetch(PERSONAS_API);
  const personas = await res.json();
  personaSelect.innerHTML = '<option value="">Selecciona una persona</option>';
  personas.forEach(p => {
    personaMap[p.persona_id] = `${p.nombre} ${p.apellidos}`;
    const opt = document.createElement('option');
    opt.value = p.persona_id;
    opt.textContent = `${p.ci} – ${p.nombre} ${p.apellidos}`;
    personaSelect.appendChild(opt);
  });
}

async function loadLicencias() {
  const res = await fetch(API);
  const data = await res.json();
  tableBody.innerHTML = '';
  data.forEach(l => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${personaMap[l.persona_id] || l.persona_id}</td>
      <td>${l.categoria}</td>
      <td>${l.fecha_emision}</td>
      <td>${l.fecha_vencimiento}</td>
      <td>${l.estado}</td>
      <td>
        <button data-id="${l.licencia_id}" class="edit-btn">✎</button>
        <button data-id="${l.licencia_id}" class="del-btn">🗑️</button>
      </td>`;
    tableBody.appendChild(tr);
  });
  document.querySelectorAll('.edit-btn').forEach(btn =>
    btn.addEventListener('click', () => loadLicencia(btn.dataset.id))
  );
  document.querySelectorAll('.del-btn').forEach(btn =>
    btn.addEventListener('click', () => deleteLicencia(btn.dataset.id))
  );
}

async function loadLicencia(id) {
  const res = await fetch(`${API}/${id}`);
  const l = await res.json();
  document.getElementById('licencia_id').value        = l.licencia_id;
  personaSelect.value                                 = l.persona_id;
  document.getElementById('categoria').value          = l.categoria;
  document.getElementById('fecha_emision').value      = l.fecha_emision;
  document.getElementById('fecha_vencimiento').value  = l.fecha_vencimiento;
  document.getElementById('estado').value             = l.estado;
  cancelBtn.hidden = false;
}

async function deleteLicencia(id) {
  if (!confirm('¿Eliminar esta licencia?')) return;
  await fetch(`${API}/${id}`, { method: 'DELETE' });
  loadLicencias();
}

function resetForm() {
  form.reset();
  document.getElementById('licencia_id').value = '';
  cancelBtn.hidden = true;
}
