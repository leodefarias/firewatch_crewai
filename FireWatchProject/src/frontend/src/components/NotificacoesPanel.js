import React from 'react';
import { Card, Table, Badge } from 'react-bootstrap';
import moment from 'moment';

function NotificacoesPanel({ notificacoes, onRefresh }) {
  const getTipoNotificacaoBadge = (tipo) => {
    switch (tipo) {
      case 'WHATSAPP_ALERTA': return 'success';
      case 'SMS_ALERTA': return 'warning';
      case 'EMAIL_ALERTA': return 'info';
      default: return 'secondary';
    }
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case 'ENVIADA': return 'success';
      case 'FALHADA': return 'danger';
      case 'PENDENTE': return 'warning';
      default: return 'secondary';
    }
  };

  const notificacoesOrdenadas = notificacoes?.sort((a, b) => 
    new Date(b.timestamp) - new Date(a.timestamp)
  ) || [];

  return (
    <Card>
      <Card.Header>
        <h4 className="mb-0">📧 Notificações Enviadas</h4>
        <small className="text-muted">{notificacoes?.length || 0} notificação(s)</small>
      </Card.Header>
      <Card.Body>
        {notificacoesOrdenadas.length === 0 ? (
          <div className="text-center text-muted py-3">
            <p>Nenhuma notificação registrada</p>
          </div>
        ) : (
          <div style={{ maxHeight: '600px', overflowY: 'auto' }}>
            <Table striped bordered hover>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Usuário</th>
                  <th>Tipo</th>
                  <th>Status</th>
                  <th>Ocorrência</th>
                  <th>Data/Hora</th>
                  <th>Mensagem</th>
                </tr>
              </thead>
              <tbody>
                {notificacoesOrdenadas.map((notificacao) => (
                  <tr key={notificacao.id}>
                    <td>{notificacao.id}</td>
                    <td>
                      <strong>{notificacao.usuario?.nome || 'N/A'}</strong>
                    </td>
                    <td>
                      <Badge bg={getTipoNotificacaoBadge(notificacao.tipoNotificacao)}>
                        {notificacao.tipoNotificacao}
                      </Badge>
                    </td>
                    <td>
                      <Badge bg={getStatusBadge(notificacao.status)}>
                        {notificacao.status}
                      </Badge>
                    </td>
                    <td>
                      {notificacao.ocorrencia ? (
                        <small>
                          #{notificacao.ocorrencia.id}<br />
                          {notificacao.ocorrencia.cidade?.nome}
                        </small>
                      ) : (
                        'N/A'
                      )}
                    </td>
                    <td>
                      <small>
                        {moment(notificacao.timestamp).format('DD/MM/YYYY HH:mm:ss')}
                      </small>
                    </td>
                    <td>
                      <div style={{ maxWidth: '300px' }}>
                        <small>{notificacao.mensagem}</small>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        )}
      </Card.Body>
    </Card>
  );
}

export default NotificacoesPanel;