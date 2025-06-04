import React from 'react';
import { Card, Table, Badge, Button } from 'react-bootstrap';
import moment from 'moment';
import api from '../services/api';

function ListaOcorrencias({ ocorrencias, onRefresh }) {
  const getSeverityBadge = (severidade) => {
    if (severidade >= 7) return 'danger';
    if (severidade >= 4) return 'warning';
    return 'success';
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case 'ABERTA': return 'danger';
      case 'EM_ATENDIMENTO': return 'warning';
      case 'FINALIZADA': return 'success';
      default: return 'secondary';
    }
  };

  const finalizarOcorrencia = async (id) => {
    try {
      await api.put(`/ocorrencias/${id}/finalizar`);
      onRefresh();
    } catch (error) {
      console.error('Erro ao finalizar ocorrência:', error);
      alert('Erro ao finalizar ocorrência');
    }
  };

  const ocorrenciasOrdenadas = ocorrencias?.sort((a, b) => {
    if (a.status === 'ABERTA' && b.status !== 'ABERTA') return -1;
    if (b.status === 'ABERTA' && a.status !== 'ABERTA') return 1;
    return b.severidade - a.severidade;
  }) || [];

  return (
    <Card>
      <Card.Header>
        <h5 className="mb-0">📋 Ocorrências Recentes</h5>
        <small className="text-muted">{ocorrencias?.length || 0} ocorrência(s)</small>
      </Card.Header>
      <Card.Body style={{ maxHeight: '500px', overflowY: 'auto' }}>
        {ocorrenciasOrdenadas.length === 0 ? (
          <div className="text-center text-muted py-3">
            <p>Nenhuma ocorrência registrada</p>
          </div>
        ) : (
          <Table striped bordered hover size="sm">
            <thead>
              <tr>
                <th>ID</th>
                <th>Local</th>
                <th>Severidade</th>
                <th>Status</th>
                <th>Data</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              {ocorrenciasOrdenadas.map((ocorrencia) => (
                <tr key={ocorrencia.id}>
                  <td>{ocorrencia.id}</td>
                  <td>
                    <small>{ocorrencia.cidade?.nome || 'N/A'}</small>
                  </td>
                  <td>
                    <Badge bg={getSeverityBadge(ocorrencia.severidade)}>
                      {ocorrencia.severidade}/10
                    </Badge>
                  </td>
                  <td>
                    <Badge bg={getStatusBadge(ocorrencia.status)} className="status-badge">
                      {ocorrencia.status}
                    </Badge>
                  </td>
                  <td>
                    <small>{moment(ocorrencia.dataHora).format('DD/MM HH:mm')}</small>
                  </td>
                  <td>
                    {ocorrencia.status !== 'FINALIZADA' && (
                      <Button
                        variant="outline-success"
                        size="sm"
                        onClick={() => finalizarOcorrencia(ocorrencia.id)}
                        title="Finalizar ocorrência"
                      >
                        ✓
                      </Button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>
        )}
      </Card.Body>
    </Card>
  );
}

export default ListaOcorrencias;