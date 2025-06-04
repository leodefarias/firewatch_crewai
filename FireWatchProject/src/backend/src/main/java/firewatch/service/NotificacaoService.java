package firewatch.service;

import firewatch.domain.Notificacao;
import firewatch.domain.Usuario;
import firewatch.domain.Ocorrencia;
import firewatch.repository.NotificacaoRepository;
import firewatch.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class NotificacaoService {

  @Autowired
  private NotificacaoRepository notificacaoRepository;
  
  @Autowired
  private UsuarioRepository usuarioRepository;
  
  @Autowired
  private TwilioService twilioService;

  public Notificacao registrarNotificacao(Usuario usuario, String mensagem, String tipo, Ocorrencia ocorrencia) {
    Notificacao notificacao = new Notificacao(mensagem, LocalDateTime.now(), tipo, usuario, ocorrencia);
    return notificacaoRepository.save(notificacao);
  }
  
  public void enviarAlertas(Ocorrencia ocorrencia) {
    String mensagem = String.format(
      "🔥 ALERTA FIREWATCH 🔥\n\n" +
      "Nova ocorrência detectada!\n" +
      "Localização: %s\n" +
      "Severidade: %d/10\n" +
      "Descrição: %s\n" +
      "Data/Hora: %s\n\n" +
      "Coordenadas: %.6f, %.6f",
      ocorrencia.getCidade().getNome(),
      ocorrencia.getSeveridade(),
      ocorrencia.getDescricao(),
      ocorrencia.getDataHora().toString(),
      ocorrencia.getLatitude(),
      ocorrencia.getLongitude()
    );
    
    List<Usuario> usuariosRegiao = usuarioRepository.findByCidadeId(ocorrencia.getCidade().getId());
    
    for (Usuario usuario : usuariosRegiao) {
      try {
        twilioService.enviarWhatsApp(usuario.getTelefone(), mensagem);
        registrarNotificacao(usuario, mensagem, "WHATSAPP_ALERTA", ocorrencia);
      } catch (Exception e) {
        System.err.println("Erro ao enviar notificação para " + usuario.getTelefone() + ": " + e.getMessage());
      }
    }
  }
  
  public List<Notificacao> buscarPorUsuario(Long usuarioId) {
    return notificacaoRepository.findByUsuarioId(usuarioId);
  }
  
  public List<Notificacao> buscarPorOcorrencia(Long ocorrenciaId) {
    return notificacaoRepository.findByOcorrenciaId(ocorrenciaId);
  }
  
  public List<Notificacao> listarTodas() {
    return notificacaoRepository.findAll();
  }
}
