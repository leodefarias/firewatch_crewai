package firewatch.domain;

import jakarta.persistence.*;

@Entity
public class EquipeCombate {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  private String status;

  private String regiao;
  
  private int numeroMembros;
  
  private String tipoEquipamento;

  public EquipeCombate() {}

  public EquipeCombate(String nome, String status, String regiao, int numeroMembros, String tipoEquipamento) {
    this.nome = nome;
    this.status = status;
    this.regiao = regiao;
    this.numeroMembros = numeroMembros;
    this.tipoEquipamento = tipoEquipamento;
  }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  
  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }
  
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  
  public String getRegiao() { return regiao; }
  public void setRegiao(String regiao) { this.regiao = regiao; }
  
  public int getNumeroMembros() { return numeroMembros; }
  public void setNumeroMembros(int numeroMembros) { this.numeroMembros = numeroMembros; }
  
  public String getTipoEquipamento() { return tipoEquipamento; }
  public void setTipoEquipamento(String tipoEquipamento) { this.tipoEquipamento = tipoEquipamento; }
}
