package firewatch.controller;

import firewatch.domain.Usuario;
import firewatch.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*")
public class UsuarioController {

  @Autowired
  private UsuarioService usuarioService;

  @PostMapping
  public ResponseEntity<Usuario> cadastrar(@RequestBody Usuario usuario) {
    try {
      Usuario novo = usuarioService.cadastrar(usuario);
      return ResponseEntity.ok(novo);
    } catch (Exception e) {
      return ResponseEntity.badRequest().build();
    }
  }

  @GetMapping
  public List<Usuario> listarTodos() {
    return usuarioService.listarTodos();
  }
  
  @GetMapping("/{id}")
  public ResponseEntity<Usuario> buscarPorId(@PathVariable Long id) {
    Optional<Usuario> usuario = usuarioService.buscarPorId(id);
    return usuario.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }

  @GetMapping("/cidade/{cidadeId}")
  public List<Usuario> listarPorCidade(@PathVariable Long cidadeId) {
    return usuarioService.listarPorCidade(cidadeId);
  }
  
  @GetMapping("/telefone/{telefone}")
  public ResponseEntity<Usuario> buscarPorTelefone(@PathVariable String telefone) {
    Optional<Usuario> usuario = usuarioService.buscarPorTelefone(telefone);
    return usuario.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  
  @GetMapping("/email/{email}")
  public ResponseEntity<Usuario> buscarPorEmail(@PathVariable String email) {
    Optional<Usuario> usuario = usuarioService.buscarPorEmail(email);
    return usuario.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  
  @GetMapping("/tipo/{tipoUsuario}")
  public List<Usuario> buscarPorTipo(@PathVariable String tipoUsuario) {
    return usuarioService.buscarPorTipo(tipoUsuario);
  }
  
  @PutMapping("/{id}")
  public ResponseEntity<Usuario> atualizar(@PathVariable Long id, @RequestBody Usuario usuario) {
    try {
      Usuario atualizado = usuarioService.atualizar(id, usuario);
      return ResponseEntity.ok(atualizado);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deletar(@PathVariable Long id) {
    try {
      usuarioService.deletar(id);
      return ResponseEntity.ok().build();
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
