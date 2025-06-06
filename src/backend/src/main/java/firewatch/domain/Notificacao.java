package firewatch.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Notificacao {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String mensagem;

  private LocalDateTime timestamp;
  
  private String status;
  
  private String tipoNotificacao;

  @ManyToOne
  @JoinColumn(name = "usuario_id")
  private Usuario usuario;
  
  @ManyToOne
  @JoinColumn(name = "ocorrencia_id")
  private Ocorrencia ocorrencia;

  public Notificacao() {}

  public Notificacao(String mensagem, LocalDateTime timestamp, String tipoNotificacao, Usuario usuario, Ocorrencia ocorrencia) {
    this.mensagem = mensagem;
    this.timestamp = timestamp;
    this.tipoNotificacao = tipoNotificacao;
    this.usuario = usuario;
    this.ocorrencia = ocorrencia;
    this.status = "ENVIADA";
  }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  
  public String getMensagem() { return mensagem; }
  public void setMensagem(String mensagem) { this.mensagem = mensagem; }
  
  public LocalDateTime getTimestamp() { return timestamp; }
  public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
  
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  
  public String getTipoNotificacao() { return tipoNotificacao; }
  public void setTipoNotificacao(String tipoNotificacao) { this.tipoNotificacao = tipoNotificacao; }
  
  public Usuario getUsuario() { return usuario; }
  public void setUsuario(Usuario usuario) { this.usuario = usuario; }
  
  public Ocorrencia getOcorrencia() { return ocorrencia; }
  public void setOcorrencia(Ocorrencia ocorrencia) { this.ocorrencia = ocorrencia; }
}
