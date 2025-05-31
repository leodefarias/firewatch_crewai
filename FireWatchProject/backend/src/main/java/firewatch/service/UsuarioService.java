package firewatch.service;

import firewatch.domain.Usuario;
import firewatch.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

  @Autowired
  private UsuarioRepository usuarioRepository;

  public Usuario cadastrar(Usuario usuario) {
    return usuarioRepository.save(usuario);
  }

  public List<Usuario> listarTodos() {
    return usuarioRepository.findAll();
  }

  public List<Usuario> listarPorCidade(Long cidadeId) {
    return usuarioRepository.findByCidadeId(cidadeId);
  }
  
  public Optional<Usuario> buscarPorId(Long id) {
    return usuarioRepository.findById(id);
  }
  
  public Optional<Usuario> buscarPorTelefone(String telefone) {
    return usuarioRepository.findByTelefone(telefone);
  }
  
  public Optional<Usuario> buscarPorEmail(String email) {
    return usuarioRepository.findByEmail(email);
  }
  
  public List<Usuario> buscarPorTipo(String tipoUsuario) {
    return usuarioRepository.findByTipoUsuario(tipoUsuario);
  }
  
  public Usuario atualizar(Long id, Usuario usuarioAtualizado) {
    Optional<Usuario> usuarioExistente = usuarioRepository.findById(id);
    if (usuarioExistente.isPresent()) {
      Usuario usuario = usuarioExistente.get();
      usuario.setNome(usuarioAtualizado.getNome());
      usuario.setTelefone(usuarioAtualizado.getTelefone());
      usuario.setEmail(usuarioAtualizado.getEmail());
      usuario.setTipoUsuario(usuarioAtualizado.getTipoUsuario());
      usuario.setCidade(usuarioAtualizado.getCidade());
      return usuarioRepository.save(usuario);
    }
    throw new RuntimeException("Usuário não encontrado");
  }
  
  public void deletar(Long id) {
    usuarioRepository.deleteById(id);
  }
}
