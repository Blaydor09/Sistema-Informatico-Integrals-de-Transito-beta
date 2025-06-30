const API = '../server/index.php/api/incidentes';
const form = document.getElementById('incidente-form');
const tableBody = document.querySelector('#incidentes-table tbody');
const cancelBtn = document.getElementById('cancel-btn');

// Dropdowns
const distritoSelect = document.getElementById('distrito_id');
const viaSelect       = document.getElementById('via_id');
const conductoresSel  = document.getElementById('conductores');
const infraccionesSel = document.getElementById('infracciones');

// Maps para mostrar texto
const personaMap      = {};
const infraccionMap   = {};
const distritoMap     = {};
const viaMap          = {};

document.addEventListener('DOMContentLoaded', async () => {
  await Promise.all([
    loadPersonas(),
    loadInfracciones(),
    loadDistritos(),
    loadVias()
  ]);
  loadIncidentes();
});

form.addEventListener('submit', async e => {
  e.preventDefault();
  const payload = {
    tipo:        document.getElementById('tipo').value.trim(),
    fecha_hora:  document.getElementById('fecha_hora').value,
    direccion:   document.getElementById('direccion').value.trim() || null,
    distrito_id: parseInt(distritoSelect.value, 10),
    via_id:      viaSelect.value ? parseInt(viaSelect.value, 10) : null,
    conductores: Array.from(conductoresSel.selectedOptions).map(o => parseInt(o.value, 10)),
    infracciones: Array.from(infraccionesSel.selectedOptions).map(o => o.value)
  };
  const id = document.getElementById('incidente_id').value;
  const method = id ? 'PUT' : 'POST';
  const url    = id ? `${API}/${id}` : API;

  const res = await fetch(url, {
    method,
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify(payload)
  });
  if (res.ok) {
    resetForm();
    loadIncidentes();
  } else {
    alert('Error al guardar el incidente');
  }
});

cancelBtn.addEventListener('click', resetForm);

// Carga de listados para dropdowns
async function loadPersonas() {
  const res = await fetch('../server/index.php/api/personas');
  const list = await res.json();
  conductoresSel.innerHTML = '';
  list.forEach(p => {
    personaMap[p.persona_id] = `${p.nombre} ${p.apellidos}`;
    const opt = document.createElement('option');
    opt.value = p.persona_id;
    opt.textContent = `${p.ci} – ${p.nombre} ${p.apellidos}`;
    conductoresSel.appendChild(opt);
  });
}

async function loadInfracciones() {
  const res = await fetch('../server/index.php/api/infracciones');
  const list = await res.json();
  infraccionesSel.innerHTML = '';
  list.forEach(i => {
    infraccionMap[i.cod_infraccion] = i.descripcion;
    const opt = document.createElement('option');
    opt.value = i.cod_infraccion;
    opt.textContent = `${i.cod_infraccion} – ${i.descripcion}`;
    infraccionesSel.appendChild(opt);
  });
}

async function loadDistritos() {
  const res = await fetch('../server/index.php/api/distritos');
  const list = await res.json();
  distritoSelect.innerHTML = '<option value="">Selecciona...</option>';
  list.forEach(d => {
    distritoMap[d.distrito_id] = d.nombre;
    const opt = document.createElement('option');
    opt.value = d.distrito_id;
    opt.textContent = d.nombre;
    distritoSelect.appendChild(opt);
  });
}

async function loadVias() {
  const res = await fetch('../server/index.php/api/vias');
  const list = await res.json();
  viaSelect.innerHTML = '<option value="">Selecciona...</option>';
  list.forEach(v => {
    viaMap[v.via_id] = v.descripcion || v.tipo;
    const opt = document.createElement('option');
    opt.value = v.via_id;
    opt.textContent = v.descripcion || v.tipo;
    viaSelect.appendChild(opt);
  });
}

// Cargar y mostrar incidentes
async function loadIncidentes() {
  const res = await fetch(API);
  const data = await res.json();
  tableBody.innerHTML = '';
  data.forEach(i => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${i.fecha_hora.replace(' ', ' T')}</td>
      <td>${i.tipo}</td>
      <td>${i.direccion||''}</td>
      <td>${distritoMap[i.distrito_id]||i.distrito_id}</td>
      <td>${viaMap[i.via_id]||''}</td>
      <td>${(i.conductores||[]).map(id=>personaMap[id]).join(', ')}</td>
      <td>${(i.infracciones||[]).map(code=>infraccionMap[code]).join(', ')}</td>
      <td>
        <button data-id="${i.incidente_id}" class="edit-btn">✎</button>
        <button data-id="${i.incidente_id}" class="del-btn">🗑️</button>
      </td>`;
    tableBody.appendChild(tr);
  });
  document.querySelectorAll('.edit-btn').forEach(btn =>
    btn.addEventListener('click', () => loadIncidente(btn.dataset.id))
  );
  document.querySelectorAll('.del-btn').forEach(btn =>
    btn.addEventListener('click', () => deleteIncidente(btn.dataset.id))
  );
}

async function loadIncidente(id) {
  const res = await fetch(`${API}/${id}`);
  const i = await res.json();
  document.getElementById('incidente_id').value = i.incidente_id;
  document.getElementById('tipo').value        = i.tipo;
  document.getElementById('fecha_hora').value  = i.fecha_hora.replace(' ', 'T');
  document.getElementById('direccion').value   = i.direccion||'';
  distritoSelect.value                         = i.distrito_id;
  viaSelect.value                              = i.via_id||'';
  // Seleccionar conductores e infracciones
  Array.from(conductoresSel.options).forEach(o => o.selected = i.conductores.includes(parseInt(o.value)));
  Array.from(infraccionesSel.options).forEach(o => o.selected = i.infracciones.includes(o.value));
  cancelBtn.hidden = false;
}

async function deleteIncidente(id) {
  if (!confirm('¿Eliminar este incidente?')) return;
  await fetch(`${API}/${id}`, { method: 'DELETE' });
  loadIncidentes();
}

function resetForm() {
  form.reset();
  document.getElementById('incidente_id').value = '';
  cancelBtn.hidden = true;
}