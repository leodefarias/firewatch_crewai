import React, { useEffect, useRef } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import { Card } from 'react-bootstrap';
import L from 'leaflet';
import moment from 'moment';
import 'moment/locale/pt-br';

moment.locale('pt-br');

// Fix for default markers in react-leaflet
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
});

// Custom icons for different severity levels
const createFireIcon = (severidade) => {
  let color = '#28a745'; // baixa
  if (severidade >= 7) color = '#dc3545'; // alta
  else if (severidade >= 4) color = '#fd7e14'; // média

  return L.divIcon({
    html: `<div style="background-color: ${color}; width: 20px; height: 20px; border-radius: 50%; border: 2px solid white; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 12px;">🔥</div>`,
    className: 'custom-fire-marker',
    iconSize: [24, 24],
    iconAnchor: [12, 12],
  });
};

const getSeverityLabel = (severidade) => {
  if (severidade >= 7) return 'Alta';
  if (severidade >= 4) return 'Média';
  return 'Baixa';
};

const getSeverityColor = (severidade) => {
  if (severidade >= 7) return 'danger';
  if (severidade >= 4) return 'warning';
  return 'success';
};

function MapaOcorrencias({ ocorrencias, cidades }) {
  const defaultCenter = [-14.235, -51.9253]; // Centro do Brasil
  const defaultZoom = 4;

  const ocorrenciasValidas = ocorrencias?.filter(
    occ => occ.latitude && occ.longitude && 
           occ.latitude !== 0 && occ.longitude !== 0
  ) || [];

  return (
    <Card>
      <Card.Header>
        <h5 className="mb-0">🗺️ Mapa de Ocorrências</h5>
        <small className="text-muted">
          {ocorrenciasValidas.length} ocorrência(s) mapeada(s)
        </small>
      </Card.Header>
      <Card.Body>
        <MapContainer
          center={defaultCenter}
          zoom={defaultZoom}
          style={{ height: '500px', width: '100%' }}
          scrollWheelZoom={true}
        >
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />
          
          {/* Markers para ocorrências */}
          {ocorrenciasValidas.map((ocorrencia) => (
            <Marker
              key={ocorrencia.id}
              position={[ocorrencia.latitude, ocorrencia.longitude]}
              icon={createFireIcon(ocorrencia.severidade)}
            >
              <Popup>
                <div className="map-marker-popup">
                  <h6>🔥 Ocorrência #{ocorrencia.id}</h6>
                  <p><strong>Local:</strong> {ocorrencia.cidade?.nome || 'N/A'}</p>
                  <p><strong>Descrição:</strong> {ocorrencia.descricao}</p>
                  <p>
                    <strong>Severidade:</strong>{' '}
                    <span className={`badge bg-${getSeverityColor(ocorrencia.severidade)}`}>
                      {ocorrencia.severidade}/10 - {getSeverityLabel(ocorrencia.severidade)}
                    </span>
                  </p>
                  <p>
                    <strong>Status:</strong>{' '}
                    <span className={`badge ${
                      ocorrencia.status === 'ABERTA' ? 'bg-danger' :
                      ocorrencia.status === 'EM_ATENDIMENTO' ? 'bg-warning' : 'bg-success'
                    }`}>
                      {ocorrencia.status}
                    </span>
                  </p>
                  <p><strong>Data:</strong> {moment(ocorrencia.dataHora).format('DD/MM/YYYY HH:mm')}</p>
                  {ocorrencia.equipeResponsavel && (
                    <p><strong>Equipe:</strong> {ocorrencia.equipeResponsavel.nome}</p>
                  )}
                  <small className="text-muted">
                    Coordenadas: {ocorrencia.latitude.toFixed(6)}, {ocorrencia.longitude.toFixed(6)}
                  </small>
                </div>
              </Popup>
            </Marker>
          ))}
          
          {/* Markers para cidades (opcional) */}
          {cidades?.map((cidade) => (
            cidade.latitude && cidade.longitude && (
              <Marker
                key={`cidade-${cidade.id}`}
                position={[cidade.latitude, cidade.longitude]}
              >
                <Popup>
                  <div>
                    <h6>🏙️ {cidade.nome}</h6>
                    <p><strong>Estado:</strong> {cidade.estado}</p>
                    <small className="text-muted">
                      {cidade.latitude.toFixed(6)}, {cidade.longitude.toFixed(6)}
                    </small>
                  </div>
                </Popup>
              </Marker>
            )
          ))}
        </MapContainer>
      </Card.Body>
    </Card>
  );
}

export default MapaOcorrencias;