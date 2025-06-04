package firewatch.domain;

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
  
  private Double latitude;
  
  private Double longitude;
  
  private String endereco;
  
  private String status;
  
  @ManyToOne
  @JoinColumn(name = "cidade_id")
  private Cidade cidade;
  
  @ManyToOne
  @JoinColumn(name = "equipe_id")
  private EquipeCombate equipeResponsavel;

  public Ocorrencia() {}

  public Ocorrencia(LocalDateTime dataHora, int severidade, String descricao, Double latitude, Double longitude, Cidade cidade) {
    this.dataHora = dataHora;
    this.severidade = severidade;
    this.descricao = descricao;
    this.latitude = latitude;
    this.longitude = longitude;
    this.cidade = cidade;
    this.status = "ABERTA";
  }

  public Ocorrencia(LocalDateTime dataHora, int severidade, String descricao, String endereco, Cidade cidade) {
    this.dataHora = dataHora;
    this.severidade = severidade;
    this.descricao = descricao;
    this.endereco = endereco;
    this.cidade = cidade;
    this.status = "ABERTA";
  }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  
  public LocalDateTime getDataHora() { return dataHora; }
  public void setDataHora(LocalDateTime dataHora) { this.dataHora = dataHora; }
  
  public int getSeveridade() { return severidade; }
  public void setSeveridade(int severidade) { this.severidade = severidade; }
  
  public String getDescricao() { return descricao; }
  public void setDescricao(String descricao) { this.descricao = descricao; }
  
  public Double getLatitude() { return latitude; }
  public void setLatitude(Double latitude) { this.latitude = latitude; }
  
  public Double getLongitude() { return longitude; }
  public void setLongitude(Double longitude) { this.longitude = longitude; }
  
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  
  public Cidade getCidade() { return cidade; }
  public void setCidade(Cidade cidade) { this.cidade = cidade; }
  
  public String getEndereco() { return endereco; }
  public void setEndereco(String endereco) { this.endereco = endereco; }
  
  public EquipeCombate getEquipeResponsavel() { return equipeResponsavel; }
  public void setEquipeResponsavel(EquipeCombate equipeResponsavel) { this.equipeResponsavel = equipeResponsavel; }
}
