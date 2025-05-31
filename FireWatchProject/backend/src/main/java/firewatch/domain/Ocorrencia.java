package com.firewatch.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Ocorrencia {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private LocalDateTime dataHora;

  private int severidade;

  private String descricao;

  @ManyToOne
  @JoinColumn(name = "cidade_id")
  private Cidade cidade;

  public Ocorrencia() {}

  public Ocorrencia(LocalDateTime dataHora, int severidade, String descricao, Cidade cidade) {
    this.dataHora = dataHora;
    this.severidade = severidade;
    this.descricao = descricao;
    this.cidade = cidade;
  }

  public Long getId() { return id; }
  public int getSeveridade() { return severidade; }
}
