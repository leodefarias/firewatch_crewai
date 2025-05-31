import React, { useState } from 'react';
import { Card, Table, Button, Modal, Form, Badge, Row, Col } from 'react-bootstrap';
import api from '../services/api';

function GerenciarEquipes({ equipes, onRefresh }) {
  const [showModal, setShowModal] = useState(false);
  const [editingEquipe, setEditingEquipe] = useState(null);
  const [formData, setFormData] = useState({
    nome: '',
    regiao: '',
    numeroMembros: 1,
    tipoEquipamento: ''
  });

  const handleClose = () => {
    setShowModal(false);
    setEditingEquipe(null);
    setFormData({
      nome: '',
      regiao: '',
      numeroMembros: 1,
      tipoEquipamento: ''
    });
  };

  const handleShow = (equipe = null) => {
    if (equipe) {
      setEditingEquipe(equipe);
      setFormData({
        nome: equipe.nome,
        regiao: equipe.regiao,
        numeroMembros: equipe.numeroMembros,
        tipoEquipamento: equipe.tipoEquipamento
      });
    }
    setShowModal(true);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingEquipe) {
        await api.put(`/equipes/${editingEquipe.id}`, formData);
      } else {
        await api.post('/equipes', formData);
      }
      onRefresh();
      handleClose();
    } catch (error) {
      console.error('Erro ao salvar equipe:', error);
      alert('Erro ao salvar equipe');
    }
  };

  const atualizarStatus = async (id, novoStatus) => {
    try {
      await api.put(`/equipes/${id}/status?status=${novoStatus}`);
      onRefresh();
    } catch (error) {
      console.error('Erro ao atualizar status:', error);
      alert('Erro ao atualizar status');
    }
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case 'DISPONIVEL': return 'success';
      case 'EM_ACAO': return 'warning';
      case 'INDISPONIVEL': return 'danger';
      default: return 'secondary';
    }
  };

  return (
    <>
      <Row>
        <Col>
          <Card>
            <Card.Header className="d-flex justify-content-between align-items-center">
              <h4 className="mb-0">👥 Gerenciar Equipes de Combate</h4>
              <Button variant="success" onClick={() => handleShow()}>
                + Nova Equipe
              </Button>
            </Card.Header>
            <Card.Body>
              <Table striped bordered hover>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Região</th>
                    <th>Membros</th>
                    <th>Equipamento</th>
                    <th>Status</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {equipes?.map(equipe => (
                    <tr key={equipe.id}>
                      <td>{equipe.id}</td>
                      <td>{equipe.nome}</td>
                      <td>{equipe.regiao}</td>
                      <td>{equipe.numeroMembros}</td>
                      <td>{equipe.tipoEquipamento}</td>
                      <td>
                        <Badge bg={getStatusBadge(equipe.status)}>
                          {equipe.status}
                        </Badge>
                      </td>
                      <td>
                        <Button
                          variant="outline-primary"
                          size="sm"
                          className="me-1"
                          onClick={() => handleShow(equipe)}
                        >
                          ✏️
                        </Button>
                        {equipe.status === 'DISPONIVEL' && (
                          <Button
                            variant="outline-warning"
                            size="sm"
                            onClick={() => atualizarStatus(equipe.id, 'INDISPONIVEL')}
                          >
                            🚫
                          </Button>
                        )}
                        {equipe.status === 'INDISPONIVEL' && (
                          <Button
                            variant="outline-success"
                            size="sm"
                            onClick={() => atualizarStatus(equipe.id, 'DISPONIVEL')}
                          >
                            ✅
                          </Button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </Table>
            </Card.Body>
          </Card>
        </Col>
      </Row>

      <Modal show={showModal} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>
            {editingEquipe ? 'Editar Equipe' : 'Nova Equipe'}
          </Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleSubmit}>
          <Modal.Body>
            <Form.Group className="mb-3">
              <Form.Label>Nome da Equipe</Form.Label>
              <Form.Control
                type="text"
                name="nome"
                value={formData.nome}
                onChange={handleChange}
                required
              />
            </Form.Group>

            <Form.Group className="mb-3">
              <Form.Label>Região</Form.Label>
              <Form.Control
                type="text"
                name="regiao"
                value={formData.regiao}
                onChange={handleChange}
                required
              />
            </Form.Group>

            <Form.Group className="mb-3">
              <Form.Label>Número de Membros</Form.Label>
              <Form.Control
                type="number"
                name="numeroMembros"
                value={formData.numeroMembros}
                onChange={handleChange}
                min="1"
                required
              />
            </Form.Group>

            <Form.Group className="mb-3">
              <Form.Label>Tipo de Equipamento</Form.Label>
              <Form.Control
                type="text"
                name="tipoEquipamento"
                value={formData.tipoEquipamento}
                onChange={handleChange}
                placeholder="Ex: Caminhão-pipa, Helicóptero, etc."
                required
              />
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleClose}>
              Cancelar
            </Button>
            <Button variant="primary" type="submit">
              {editingEquipe ? 'Atualizar' : 'Cadastrar'}
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>
    </>
  );
}

export default GerenciarEquipes;