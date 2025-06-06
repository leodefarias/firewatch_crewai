import React, { useState, useEffect, useRef } from 'react';
import { Container, Row, Col, Nav, Navbar, Toast, ToastContainer } from 'react-bootstrap';
import MapaOcorrencias from './components/MapaOcorrencias';
import ListaOcorrencias from './components/ListaOcorrencias';
import DashboardStats from './components/DashboardStats';
import CadastroOcorrencia from './components/CadastroOcorrencia';
import GerenciarEquipes from './components/GerenciarEquipes';
import GerenciarUsuarios from './components/GerenciarUsuarios';
import NotificacoesPanel from './components/NotificacoesPanel';
import api from './services/api';
import './App.css';

function App() {
  const [activeTab, setActiveTab] = useState('dashboard');
  const [ocorrencias, setOcorrencias] = useState([]);
  const [equipes, setEquipes] = useState([]);
  const [usuarios, setUsuarios] = useState([]);
  const [notificacoes, setNotificacoes] = useState([]);
  const [cidades, setCidades] = useState([]);
  const [novasOcorrencias, setNovasOcorrencias] = useState([]);
  const [showToast, setShowToast] = useState(false);
  const ultimaVerificacao = useRef(Date.now());

  useEffect(() => {
    carregarDados();
    const interval = setInterval(carregarDados, 30000); // Reduzido para 30 segundos para evitar sobrecarga
    return () => clearInterval(interval);
  }, []);

  const carregarDados = async () => {
    try {
      const [
        ocorrenciasRes,
        equipesRes,
        usuariosRes,
        notificacoesRes,
        cidadesRes
      ] = await Promise.all([
        api.get('/ocorrencias'),
        api.get('/equipes'),
        api.get('/usuarios'),
        api.get('/notificacoes'),
        api.get('/cidades')
      ]);

      // Verificar se há novas ocorrências desde a última verificação
      const agora = Date.now();
      const novasOcorrenciasEncontradas = ocorrenciasRes.data.filter(occ => {
        const dataOcorrencia = new Date(occ.dataHora).getTime();
        return dataOcorrencia > ultimaVerificacao.current;
      });

      if (novasOcorrenciasEncontradas.length > 0) {
        setNovasOcorrencias(novasOcorrenciasEncontradas);
        setShowToast(true);
        
        // Som de notificação (opcional)
        if ('Notification' in window && Notification.permission === 'granted') {
          novasOcorrenciasEncontradas.forEach(occ => {
            new Notification('🔥 Nova Ocorrência FireWatch', {
              body: `${occ.descricao} - Severidade: ${occ.severidade}/10`,
              icon: '/favicon.ico'
            });
          });
        }
      }

      ultimaVerificacao.current = agora;
      setOcorrencias(ocorrenciasRes.data);
      setEquipes(equipesRes.data);
      setUsuarios(usuariosRes.data);
      setNotificacoes(notificacoesRes.data);
      setCidades(cidadesRes.data);
    } catch (error) {
      console.error('Erro ao carregar dados:', error);
    }
  };

  // Solicitar permissão para notificações
  useEffect(() => {
    if ('Notification' in window && Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  const adicionarOcorrencia = (novaOcorrencia) => {
    setOcorrencias([...ocorrencias, novaOcorrencia]);
    carregarDados(); // Recarregar todos os dados para manter sincronizado
  };

  const renderContent = () => {
    switch (activeTab) {
      case 'dashboard':
        return (
          <>
            <DashboardStats 
              ocorrencias={ocorrencias} 
              equipes={equipes} 
              usuarios={usuarios} 
            />
            <Row className="mt-4">
              <Col lg={8}>
                <MapaOcorrencias ocorrencias={ocorrencias} cidades={cidades} />
              </Col>
              <Col lg={4}>
                <ListaOcorrencias 
                  ocorrencias={ocorrencias} 
                  onRefresh={carregarDados}
                />
              </Col>
            </Row>
          </>
        );
      case 'cadastro':
        return (
          <CadastroOcorrencia 
            cidades={cidades}
            onOcorrenciaAdicionada={adicionarOcorrencia}
          />
        );
      case 'equipes':
        return (
          <GerenciarEquipes 
            equipes={equipes}
            onRefresh={carregarDados}
          />
        );
      case 'usuarios':
        return (
          <GerenciarUsuarios 
            usuarios={usuarios}
            cidades={cidades}
            onRefresh={carregarDados}
          />
        );
      case 'notificacoes':
        return (
          <NotificacoesPanel 
            notificacoes={notificacoes}
            onRefresh={carregarDados}
          />
        );
      default:
        return null;
    }
  };

  return (
    <div className="App">
      <Navbar bg="dark" variant="dark" expand="lg">
        <Container>
          <Navbar.Brand href="#dashboard">
            🔥 FireWatch
          </Navbar.Brand>
          <Nav className="me-auto">
            <Nav.Link 
              active={activeTab === 'dashboard'}
              onClick={() => setActiveTab('dashboard')}
            >
              Dashboard
            </Nav.Link>
            <Nav.Link 
              active={activeTab === 'cadastro'}
              onClick={() => setActiveTab('cadastro')}
            >
              Nova Ocorrência
            </Nav.Link>
            <Nav.Link 
              active={activeTab === 'equipes'}
              onClick={() => setActiveTab('equipes')}
            >
              Equipes
            </Nav.Link>
            <Nav.Link 
              active={activeTab === 'usuarios'}
              onClick={() => setActiveTab('usuarios')}
            >
              Usuários
            </Nav.Link>
            <Nav.Link 
              active={activeTab === 'notificacoes'}
              onClick={() => setActiveTab('notificacoes')}
            >
              Notificações
            </Nav.Link>
          </Nav>
        </Container>
      </Navbar>

      <Container fluid className="mt-3">
        {renderContent()}
      </Container>

      {/* Toast para novas ocorrências */}
      <ToastContainer position="top-end" className="p-3">
        <Toast
          show={showToast}
          onClose={() => setShowToast(false)}
          delay={5000}
          autohide
          className="border-danger"
        >
          <Toast.Header className="bg-danger text-white">
            <strong className="me-auto">🔥 Nova Ocorrência via WhatsApp!</strong>
          </Toast.Header>
          <Toast.Body>
            {novasOcorrencias.map((occ, index) => (
              <div key={occ.id} className={index > 0 ? 'border-top pt-2 mt-2' : ''}>
                <strong>#{occ.id}</strong> - {occ.descricao}<br/>
                <small className="text-muted">
                  📍 {occ.cidade?.nome} | Severidade: {occ.severidade}/10
                </small>
              </div>
            ))}
          </Toast.Body>
        </Toast>
      </ToastContainer>
    </div>
  );
}

export default App;