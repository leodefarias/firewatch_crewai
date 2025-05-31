package com.firewatch.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Notificacao {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String mensagem;

  private LocalDateTime timestamp;

  @ManyToOne
  @JoinColumn(name = "usuario_id")
  private Usuario usuario;

  public Notificacao() {}

  public Notificacao(String mensagem, LocalDateTime timestamp, Usuario usuario) {
    this.mensagem = mensagem;
    this.timestamp = timestamp;
    this.usuario = usuario;
  }

  public Long getId() { return id; }
}
