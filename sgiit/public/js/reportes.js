const API = '../server/index.php/api/incidentes';
const INFRACCIONES_API = '../server/index.php/api/infracciones';
const form = document.getElementById('reporte-form');
const resultDiv = document.getElementById('reporte-result');

let infraccionMap = {};

// Carga mapa de infracciones al inicio
document.addEventListener('DOMContentLoaded', loadInfracciones);

async function loadInfracciones() {
  const res = await fetch(INFRACCIONES_API);
  const list = await res.json();
  list.forEach(i => {
    infraccionMap[i.cod_infraccion] = i.descripcion;
  });
}

form.addEventListener('submit', async e => {
  e.preventDefault();
  resultDiv.innerHTML = '';

  const fechaInicio = document.getElementById('fechaInicio').value;
  const fechaFin    = document.getElementById('fechaFin').value;
  const tipo        = document.getElementById('tipo').value.trim();

  // Construir query params
  const params = new URLSearchParams({
    fechaInicio,
    fechaFin
  });
  if (tipo) params.append('tipo', tipo);

  // Obtener incidentes filtrados
  const res = await fetch(`${API}?${params.toString()}`);
  const incidentes = await res.json();

  // Contar ocurrencias de cada infracción
  const counts = {};
  incidentes.forEach(inc => {
    (inc.infracciones || []).forEach(code => {
      counts[code] = (counts[code] || 0) + 1;
    });
  });

  const total = Object.values(counts).reduce((sum, c) => sum + c, 0);

  // Construir tabla de resumen
  const table = document.createElement('table');
  table.innerHTML = `
    <thead>
      <tr>
        <th>Infracción</th>
        <th>Cantidad</th>
        <th>Porcentaje</th>
      </tr>
    </thead>
    <tbody>
      ${Object.entries(counts).map(([code, cnt]) => `
        <tr>
          <td>${code} – ${infraccionMap[code] || ''}</td>
          <td>${cnt}</td>
          <td>${((cnt / total) * 100).toFixed(2)}%</td>
        </tr>
      `).join('')}
    </tbody>
  `;
  resultDiv.appendChild(table);

  // Mostrar totales arriba
  const summary = document.createElement('p');
  summary.textContent = `Total de infracciones registradas: ${total}`;
  resultDiv.insertBefore(summary, table);
});
