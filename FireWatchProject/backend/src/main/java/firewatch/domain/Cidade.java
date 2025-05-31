package com.firewatch.domain;

import jakarta.persistence.*;

@Entity
public class Cidade {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  public Cidade() {}

  public Cidade(String nome) {
    this.nome = nome;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }
}
