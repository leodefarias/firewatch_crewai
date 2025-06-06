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

/**
 * Serviço responsável por gerenciar notificações e alertas do sistema.
 * Gerencia o envio de alertas via WhatsApp para usuários cadastrados na região das ocorrências.
 */
@Service
public class NotificacaoService {

  @Autowired
  private NotificacaoRepository notificacaoRepository;
  
  @Autowired
  private UsuarioRepository usuarioRepository;
  
  @Autowired
  private TwilioService twilioService;

  /**
   * Registra uma nova notificação no sistema.
   * 
   * @param usuario Usuário destinatário da notificação
   * @param mensagem Conteúdo da mensagem
   * @param tipo Tipo da notificação (WHATSAPP_ALERTA, SMS_ALERTA, etc.)
   * @param ocorrencia Ocorrência relacionada à notificação
   * @return Notificação registrada
   */
  public Notificacao registrarNotificacao(Usuario usuario, String mensagem, String tipo, Ocorrencia ocorrencia) {
    Notificacao notificacao = new Notificacao(mensagem, LocalDateTime.now(), tipo, usuario, ocorrencia);
    return notificacaoRepository.save(notificacao);
  }
  
  /**
   * Envia alertas via WhatsApp para todos os usuários cadastrados na região da ocorrência.
   * A mensagem inclui detalhes da ocorrência, incluindo localização e endereço quando disponível.
   * 
   * @param ocorrencia Ocorrência para a qual os alertas serão enviados
   */
  public void enviarAlertas(Ocorrencia ocorrencia) {
    String localizacao = ocorrencia.getCidade().getNome();
    if (ocorrencia.getEndereco() != null && !ocorrencia.getEndereco().trim().isEmpty()) {
      localizacao += "\nEndereço: " + ocorrencia.getEndereco();
    }
    
    String mensagem = String.format(
      "🔥 ALERTA FIREWATCH 🔥\n\n" +
      "Nova ocorrência detectada!\n" +
      "Localização: %s\n" +
      "Severidade: %d/10\n" +
      "Descrição: %s\n" +
      "Data/Hora: %s\n\n" +
      "Coordenadas: %.6f, %.6f",
      localizacao,
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
  
  /**
   * Busca todas as notificações de um usuário específico.
   * 
   * @param usuarioId ID do usuário
   * @return Lista de notificações do usuário
   */
  public List<Notificacao> buscarPorUsuario(Long usuarioId) {
    return notificacaoRepository.findByUsuarioId(usuarioId);
  }
  
  /**
   * Busca todas as notificações relacionadas a uma ocorrência específica.
   * 
   * @param ocorrenciaId ID da ocorrência
   * @return Lista de notificações da ocorrência
   */
  public List<Notificacao> buscarPorOcorrencia(Long ocorrenciaId) {
    return notificacaoRepository.findByOcorrenciaId(ocorrenciaId);
  }
  
  /**
   * Lista todas as notificações registradas no sistema.
   * 
   * @return Lista completa de notificações
   */
  public List<Notificacao> listarTodas() {
    return notificacaoRepository.findAll();
  }
}
