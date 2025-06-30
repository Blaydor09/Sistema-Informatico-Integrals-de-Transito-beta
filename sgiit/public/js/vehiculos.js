const API = '../server/index.php/api/vehiculos';
const form = document.getElementById('vehiculo-form');
const tableBody = document.querySelector('#vehiculos-table tbody');
const cancelBtn = document.getElementById('cancel-btn');

document.addEventListener('DOMContentLoaded', loadVehiculos);

form.addEventListener('submit', async e => {
  e.preventDefault();
  const payload = {
    placa:  document.getElementById('placa').value.trim(),
    marca:  document.getElementById('marca').value.trim()  || null,
    modelo: document.getElementById('modelo').value.trim() || null,
    anio:   document.getElementById('anio').value || null,
    color:  document.getElementById('color').value.trim()  || null
  };
  const id = document.getElementById('vehiculo_id').value;
  const method = id ? 'PUT' : 'POST';
  const url = id ? `${API}/${id}` : API;

  const res = await fetch(url, {
    method,
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify(payload)
  });
  if (res.ok) {
    resetForm();
    loadVehiculos();
  } else {
    alert('Error al guardar el vehículo');
  }
});

cancelBtn.addEventListener('click', resetForm);

async function loadVehiculos() {
  const res = await fetch(API);
  const data = await res.json();
  tableBody.innerHTML = '';
  data.forEach(v => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${v.placa}</td>
      <td>${v.marca||''}</td>
      <td>${v.modelo||''}</td>
      <td>${v.anio||''}</td>
      <td>${v.color||''}</td>
      <td>
        <button data-id="${v.vehiculo_id}" class="edit-btn">✎</button>
        <button data-id="${v.vehiculo_id}" class="del-btn">🗑️</button>
      </td>`;
    tableBody.appendChild(tr);
  });
  document.querySelectorAll('.edit-btn').forEach(btn =>
    btn.addEventListener('click', () => loadVehiculo(btn.dataset.id))
  );
  document.querySelectorAll('.del-btn').forEach(btn =>
    btn.addEventListener('click', () => deleteVehiculo(btn.dataset.id))
  );
}

async function loadVehiculo(id) {
  const res = await fetch(`${API}/${id}`);
  const v = await res.json();
  document.getElementById('vehiculo_id').value = v.vehiculo_id;
  document.getElementById('placa').value       = v.placa;
  document.getElementById('marca').value       = v.marca || '';
  document.getElementById('modelo').value      = v.modelo || '';
  document.getElementById('anio').value        = v.anio || '';
  document.getElementById('color').value       = v.color || '';
  cancelBtn.hidden = false;
}

async function deleteVehiculo(id) {
  if (!confirm('¿Eliminar este vehículo?')) return;
  await fetch(`${API}/${id}`, { method: 'DELETE' });
  loadVehiculos();
}

function resetForm() {
  form.reset();
  document.getElementById('vehiculo_id').value = '';
  cancelBtn.hidden = true;
}
