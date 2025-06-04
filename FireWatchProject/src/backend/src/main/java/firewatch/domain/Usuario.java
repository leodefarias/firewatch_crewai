package firewatch.domain;

import jakarta.persistence.*;

@Entity
public class Usuario {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  private String telefone;
  
  private String email;
  
  private String endereco;
  
  private String tipoUsuario;

  @ManyToOne
  @JoinColumn(name = "cidade_id")
  private Cidade cidade;

  public Usuario() {}

  public Usuario(String nome, String telefone, String email, String endereco, String tipoUsuario, Cidade cidade) {
    this.nome = nome;
    this.telefone = telefone;
    this.email = email;
    this.endereco = endereco;
    this.tipoUsuario = tipoUsuario;
    this.cidade = cidade;
  }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  
  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }
  
  public String getTelefone() { return telefone; }
  public void setTelefone(String telefone) { this.telefone = telefone; }
  
  public String getEmail() { return email; }
  public void setEmail(String email) { this.email = email; }
  
  public String getEndereco() { return endereco; }
  public void setEndereco(String endereco) { this.endereco = endereco; }
  
  public String getTipoUsuario() { return tipoUsuario; }
  public void setTipoUsuario(String tipoUsuario) { this.tipoUsuario = tipoUsuario; }
  
  public Cidade getCidade() { return cidade; }
  public void setCidade(Cidade cidade) { this.cidade = cidade; }
}
