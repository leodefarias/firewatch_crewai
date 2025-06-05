import React, { useState } from 'react';
import { Card, Form, Button, Row, Col, Alert } from 'react-bootstrap';
import api from '../services/api';

function CadastroOcorrencia({ cidades, onOcorrenciaAdicionada }) {
  const [formData, setFormData] = useState({
    descricao: '',
    severidade: 1,
    latitude: '',
    longitude: '',
    endereco: '',
    cidadeId: '',
    tipoLocalizacao: 'endereco' // 'endereco' ou 'coordenadas'
  });
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      const cidadeSelecionada = cidades.find(c => c.id === parseInt(formData.cidadeId));
      
      const ocorrenciaData = {
        descricao: formData.descricao,
        severidade: parseInt(formData.severidade),
        cidade: cidadeSelecionada
      };

      // Adicionar localização baseada no tipo selecionado
      if (formData.tipoLocalizacao === 'endereco' && formData.endereco.trim()) {
        ocorrenciaData.endereco = formData.endereco;
      } else if (formData.tipoLocalizacao === 'coordenadas' && formData.latitude && formData.longitude) {
        ocorrenciaData.latitude = parseFloat(formData.latitude);
        ocorrenciaData.longitude = parseFloat(formData.longitude);
      }

      const response = await api.post('/ocorrencias', ocorrenciaData);
      
      setMessage({ type: 'success', text: 'Ocorrência registrada com sucesso! Alertas enviados.' });
      if (onOcorrenciaAdicionada) {
        onOcorrenciaAdicionada(response.data);
      }
      
      // Reset form
      setFormData({
        descricao: '',
        severidade: 1,
        latitude: '',
        longitude: '',
        endereco: '',
        cidadeId: '',
        tipoLocalizacao: 'endereco'
      });
    } catch (error) {
      console.error('Erro ao registrar ocorrência:', error);
      setMessage({ type: 'danger', text: 'Erro ao registrar ocorrência. Verifique os dados.' });
    } finally {
      setLoading(false);
    }
  };

  const obterLocalizacaoAtual = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setFormData(prev => ({
            ...prev,
            latitude: position.coords.latitude.toString(),
            longitude: position.coords.longitude.toString()
          }));
          setMessage({ type: 'info', text: 'Localização atual obtida com sucesso!' });
        },
        (error) => {
          console.error('Erro ao obter localização:', error);
          setMessage({ type: 'warning', text: 'Não foi possível obter a localização atual.' });
        }
      );
    } else {
      setMessage({ type: 'warning', text: 'Geolocalização não é suportada neste navegador.' });
    }
  };

  const getSeverityColor = (severidade) => {
    if (severidade >= 7) return 'danger';
    if (severidade >= 4) return 'warning';
    return 'success';
  };

  return (
    <Row className="justify-content-center">
      <Col lg={8}>
        <Card>
          <Card.Header>
            <h4 className="mb-0">🔥 Registrar Nova Ocorrência</h4>
          </Card.Header>
          <Card.Body>
            {message.text && (
              <Alert variant={message.type} dismissible onClose={() => setMessage({ type: '', text: '' })}>
                {message.text}
              </Alert>
            )}

            <Form onSubmit={handleSubmit}>
              <Row>
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

                <Col md={6}>
                  <Form.Group className="mb-3">
                    <Form.Label>
                      Severidade: {formData.severidade}/10
                      <span className={`badge bg-${getSeverityColor(formData.severidade)} ms-2`}>
                        {formData.severidade >= 7 ? 'Alta' : 
                         formData.severidade >= 4 ? 'Média' : 'Baixa'}
                      </span>
                    </Form.Label>
                    <Form.Range
                      name="severidade"
                      min="1"
                      max="10"
                      value={formData.severidade}
                      onChange={handleChange}
                    />
                  </Form.Group>
                </Col>
              </Row>

              <Form.Group className="mb-3">
                <Form.Label>Descrição</Form.Label>
                <Form.Control
                  as="textarea"
                  rows={3}
                  name="descricao"
                  value={formData.descricao}
                  onChange={handleChange}
                  placeholder="Descreva a ocorrência de incêndio..."
                  required
                />
              </Form.Group>

              {/* Seleção do tipo de localização */}
              <Form.Group className="mb-3">
                <Form.Label>Como você quer informar a localização?</Form.Label>
                <Row>
                  <Col md={6}>
                    <Form.Check
                      type="radio"
                      id="tipo-endereco"
                      name="tipoLocalizacao"
                      value="endereco"
                      label="📍 Endereço (mais fácil)"
                      checked={formData.tipoLocalizacao === 'endereco'}
                      onChange={handleChange}
                    />
                  </Col>
                  <Col md={6}>
                    <Form.Check
                      type="radio"
                      id="tipo-coordenadas"
                      name="tipoLocalizacao"
                      value="coordenadas"
                      label="🗺️ Coordenadas GPS"
                      checked={formData.tipoLocalizacao === 'coordenadas'}
                      onChange={handleChange}
                    />
                  </Col>
                </Row>
              </Form.Group>

              {/* Campo de endereço */}
              {formData.tipoLocalizacao === 'endereco' && (
                <Form.Group className="mb-3">
                  <Form.Label>Endereço do Incêndio</Form.Label>
                  <Form.Control
                    type="text"
                    name="endereco"
                    value={formData.endereco}
                    onChange={handleChange}
                    placeholder="Ex: Rua das Flores, 123, Centro, São Paulo, SP"
                    required={formData.tipoLocalizacao === 'endereco'}
                  />
                  <Form.Text className="text-muted">
                    Informe o endereço mais completo possível (rua, número, bairro, cidade)
                  </Form.Text>
                </Form.Group>
              )}

              {/* Campos de coordenadas */}
              {formData.tipoLocalizacao === 'coordenadas' && (
                <Row>
                  <Col md={5}>
                    <Form.Group className="mb-3">
                      <Form.Label>Latitude</Form.Label>
                      <Form.Control
                        type="number"
                        step="any"
                        name="latitude"
                        value={formData.latitude}
                        onChange={handleChange}
                        placeholder="-14.235"
                        required={formData.tipoLocalizacao === 'coordenadas'}
                      />
                    </Form.Group>
                  </Col>

                  <Col md={5}>
                    <Form.Group className="mb-3">
                      <Form.Label>Longitude</Form.Label>
                      <Form.Control
                        type="number"
                        step="any"
                        name="longitude"
                        value={formData.longitude}
                        onChange={handleChange}
                        placeholder="-51.925"
                        required={formData.tipoLocalizacao === 'coordenadas'}
                      />
                    </Form.Group>
                  </Col>

                  <Col md={2}>
                    <Form.Label>&nbsp;</Form.Label>
                    <Button
                      variant="outline-primary"
                      className="d-block w-100"
                      onClick={obterLocalizacaoAtual}
                      type="button"
                    >
                      📍 GPS
                    </Button>
                  </Col>
                </Row>
              )}

              <div className="d-grid">
                <Button
                  variant="danger"
                  type="submit"
                  disabled={loading}
                  size="lg"
                >
                  {loading ? 'Registrando...' : '🚨 Registrar Ocorrência'}
                </Button>
              </div>
            </Form>
          </Card.Body>
        </Card>
      </Col>
    </Row>
  );
}

export default CadastroOcorrencia;