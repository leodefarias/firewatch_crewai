package com.firewatch.domain;

import jakarta.persistence.*;

@Entity
public class EquipeCombate {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  private String status; // Ex: disponível, em ação, indisponível

  private String regiao;

  public EquipeCombate() {}

  public EquipeCombate(String nome, String status, String regiao) {
    this.nome = nome;
    this.status = status;
    this.regiao = regiao;
  }

  public Long getId() { return id; }
}
