package firewatch.domain;

import jakarta.persistence.*;

@Entity
public class Cidade {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;
  
  private Double latitude;
  
  private Double longitude;
  
  private String estado;

  public Cidade() {}

  public Cidade(String nome, Double latitude, Double longitude, String estado) {
    this.nome = nome;
    this.latitude = latitude;
    this.longitude = longitude;
    this.estado = estado;
  }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  
  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }
  
  public Double getLatitude() { return latitude; }
  public void setLatitude(Double latitude) { this.latitude = latitude; }
  
  public Double getLongitude() { return longitude; }
  public void setLongitude(Double longitude) { this.longitude = longitude; }
  
  public String getEstado() { return estado; }
  public void setEstado(String estado) { this.estado = estado; }
}
