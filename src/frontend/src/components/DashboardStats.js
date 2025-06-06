import React from 'react';
import { Row, Col, Card } from 'react-bootstrap';

function DashboardStats({ ocorrencias, equipes, usuarios }) {
  const ocorrenciasAbertas = ocorrencias?.filter(o => o.status === 'ABERTA').length || 0;
  const ocorrenciasEmAtendimento = ocorrencias?.filter(o => o.status === 'EM_ATENDIMENTO').length || 0;
  const ocorrenciasFinalizadas = ocorrencias?.filter(o => o.status === 'FINALIZADA').length || 0;
  
  const equipesDisponiveis = equipes?.filter(e => e.status === 'DISPONIVEL').length || 0;
  const equipesEmAcao = equipes?.filter(e => e.status === 'EM_ACAO').length || 0;
  
  const ocorrenciasAltas = ocorrencias?.filter(o => o.severidade >= 7).length || 0;
  const ocorrenciasMedias = ocorrencias?.filter(o => o.severidade >= 4 && o.severidade < 7).length || 0;
  const ocorrenciasBaixas = ocorrencias?.filter(o => o.severidade < 4).length || 0;

  return (
    <Row>
      <Col lg={3} md={6} className="mb-3">
        <Card className="h-100">
          <Card.Body className="text-center">
            <div className="display-6 text-danger mb-2">🔥</div>
            <h5 className="card-title">Ocorrências Ativas</h5>
            <h2 className="text-danger">{ocorrenciasAbertas + ocorrenciasEmAtendimento}</h2>
            <small className="text-muted">
              {ocorrenciasAbertas} abertas, {ocorrenciasEmAtendimento} em atendimento
            </small>
          </Card.Body>
        </Card>
      </Col>

      <Col lg={3} md={6} className="mb-3">
        <Card className="h-100">
          <Card.Body className="text-center">
            <div className="display-6 text-success mb-2">👥</div>
            <h5 className="card-title">Equipes</h5>
            <h2 className="text-success">{equipesDisponiveis}</h2>
            <small className="text-muted">
              {equipesDisponiveis} disponíveis, {equipesEmAcao} em ação
            </small>
          </Card.Body>
        </Card>
      </Col>

      <Col lg={3} md={6} className="mb-3">
        <Card className="h-100">
          <Card.Body className="text-center">
            <div className="display-6 text-info mb-2">👤</div>
            <h5 className="card-title">Usuários</h5>
            <h2 className="text-info">{usuarios?.length || 0}</h2>
            <small className="text-muted">Cadastrados no sistema</small>
          </Card.Body>
        </Card>
      </Col>

      <Col lg={3} md={6} className="mb-3">
        <Card className="h-100">
          <Card.Body className="text-center">
            <div className="display-6 text-warning mb-2">⚡</div>
            <h5 className="card-title">Severidade</h5>
            <div className="d-flex justify-content-between">
              <div>
                <div className="badge bg-danger">{ocorrenciasAltas}</div>
                <small className="d-block">Alta</small>
              </div>
              <div>
                <div className="badge bg-warning">{ocorrenciasMedias}</div>
                <small className="d-block">Média</small>
              </div>
              <div>
                <div className="badge bg-success">{ocorrenciasBaixas}</div>
                <small className="d-block">Baixa</small>
              </div>
            </div>
          </Card.Body>
        </Card>
      </Col>
    </Row>
  );
}

export default DashboardStats;