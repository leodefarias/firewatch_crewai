import React, { useState } from 'react';
import { Card, Table, Button, Modal, Form, Row, Col } from 'react-bootstrap';
import api from '../services/api';

function GerenciarUsuarios({ usuarios, cidades, onRefresh }) {
  const [showModal, setShowModal] = useState(false);
  const [editingUsuario, setEditingUsuario] = useState(null);
  const [formData, setFormData] = useState({
    nome: '',
    telefone: '',
    email: '',
    tipoUsuario: 'CIDADAO',
    cidadeId: ''
  });

  const handleClose = () => {
    setShowModal(false);
    setEditingUsuario(null);
    setFormData({
      nome: '',
      telefone: '',
      email: '',
      tipoUsuario: 'CIDADAO',
      cidadeId: ''
    });
  };

  const handleShow = (usuario = null) => {
    if (usuario) {
      setEditingUsuario(usuario);
      setFormData({
        nome: usuario.nome,
        telefone: usuario.telefone,
        email: usuario.email,
        tipoUsuario: usuario.tipoUsuario,
        cidadeId: usuario.cidade?.id || ''
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
      const cidadeSelecionada = cidades.find(c => c.id === parseInt(formData.cidadeId));
      
      const usuarioData = {
        ...formData,
        cidade: cidadeSelecionada
      };

      if (editingUsuario) {
        await api.put(`/usuarios/${editingUsuario.id}`, usuarioData);
      } else {
        await api.post('/usuarios', usuarioData);
      }
      onRefresh();
      handleClose();
    } catch (error) {
      console.error('Erro ao salvar usuário:', error);
      alert('Erro ao salvar usuário');
    }
  };

  const getTipoUsuarioBadge = (tipo) => {
    switch (tipo) {
      case 'ADMINISTRADOR': return 'danger';
      case 'BOMBEIRO': return 'warning';
      case 'CIDADAO': return 'primary';
      default: return 'secondary';
    }
  };

  return (
    <>
      <Row>
        <Col>
          <Card>
            <Card.Header className="d-flex justify-content-between align-items-center">
              <h4 className="mb-0">👤 Gerenciar Usuários</h4>
              <Button variant="success" onClick={() => handleShow()}>
                + Novo Usuário
              </Button>
            </Card.Header>
            <Card.Body>
              <Table striped bordered hover>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Telefone</th>
                    <th>Email</th>
                    <th>Tipo</th>
                    <th>Cidade</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {usuarios?.map(usuario => (
                    <tr key={usuario.id}>
                      <td>{usuario.id}</td>
                      <td>{usuario.nome}</td>
                      <td>{usuario.telefone}</td>
                      <td>{usuario.email}</td>
                      <td>
                        <span className={`badge bg-${getTipoUsuarioBadge(usuario.tipoUsuario)}`}>
                          {usuario.tipoUsuario}
                        </span>
                      </td>
                      <td>{usuario.cidade?.nome || 'N/A'}</td>
                      <td>
                        <Button
                          variant="outline-primary"
                          size="sm"
                          onClick={() => handleShow(usuario)}
                        >
                          ✏️ Editar
                        </Button>
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
            {editingUsuario ? 'Editar Usuário' : 'Novo Usuário'}
          </Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleSubmit}>
          <Modal.Body>
            <Form.Group className="mb-3">
              <Form.Label>Nome Completo</Form.Label>
              <Form.Control
                type="text"
                name="nome"
                value={formData.nome}
                onChange={handleChange}
                required
              />
            </Form.Group>

            <Row>
              <Col md={6}>
                <Form.Group className="mb-3">
                  <Form.Label>Telefone (WhatsApp)</Form.Label>
                  <Form.Control
                    type="tel"
                    name="telefone"
                    value={formData.telefone}
                    onChange={handleChange}
                    placeholder="+5511999999999"
                    required
                  />
                  <Form.Text className="text-muted">
                    Formato: +5511999999999
                  </Form.Text>
                </Form.Group>
              </Col>

              <Col md={6}>
                <Form.Group className="mb-3">
                  <Form.Label>Email</Form.Label>
                  <Form.Control
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                  />
                </Form.Group>
              </Col>
            </Row>

            <Row>
              <Col md={6}>
                <Form.Group className="mb-3">
                  <Form.Label>Tipo de Usuário</Form.Label>
                  <Form.Select
                    name="tipoUsuario"
                    value={formData.tipoUsuario}
                    onChange={handleChange}
                    required
                  >
                    <option value="CIDADAO">Cidadão</option>
                    <option value="BOMBEIRO">Bombeiro</option>
                    <option value="ADMINISTRADOR">Administrador</option>
                  </Form.Select>
                </Form.Group>
              </Col>

              <Col md={6}>
                <Form.Group className="mb-3">
                  <Form.Label>Cidade</Form.Label>
                  <Form.Select
                    name="cidadeId"
                    value={formData.cidadeId}
                    onChange={handleChange}
                    required
                  >
                    <option value="">Selecione uma cidade</option>
                    {cidades?.map(cidade => (
                      <option key={cidade.id} value={cidade.id}>
                        {cidade.nome} - {cidade.estado}
                      </option>
                    ))}
                  </Form.Select>
                </Form.Group>
              </Col>
            </Row>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleClose}>
              Cancelar
            </Button>
            <Button variant="primary" type="submit">
              {editingUsuario ? 'Atualizar' : 'Cadastrar'}
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>
    </>
  );
}

export default GerenciarUsuarios;