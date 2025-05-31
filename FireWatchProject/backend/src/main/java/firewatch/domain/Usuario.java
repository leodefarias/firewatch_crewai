package com.firewatch.domain;

import jakarta.persistence.*;

@Entity
public class Usuario {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  private String telefone;

  @ManyToOne
  @JoinColumn(name = "cidade_id")
  private Cidade cidade;

  public Usuario() {}

  public Usuario(String nome, String telefone, Cidade cidade) {
    this.nome = nome;
    this.telefone = telefone;
    this.cidade = cidade;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public String getTelefone() { return telefone; }
  public Cidade getCidade() { return cidade; }
}
