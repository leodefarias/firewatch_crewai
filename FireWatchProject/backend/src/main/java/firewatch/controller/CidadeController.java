package firewatch.controller;

import firewatch.domain.Cidade;
import firewatch.service.CidadeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cidades")
@CrossOrigin(origins = "*")
public class CidadeController {

  @Autowired
  private CidadeService cidadeService;

  @PostMapping
  public ResponseEntity<Cidade> cadastrar(@RequestBody Cidade cidade) {
    try {
      Cidade nova = cidadeService.cadastrar(cidade);
      return ResponseEntity.ok(nova);
    } catch (Exception e) {
      return ResponseEntity.badRequest().build();
    }
  }

  @GetMapping
  public List<Cidade> listarTodas() {
    return cidadeService.listarTodas();
  }
  
  @GetMapping("/{id}")
  public ResponseEntity<Cidade> buscarPorId(@PathVariable Long id) {
    Optional<Cidade> cidade = cidadeService.buscarPorId(id);
    return cidade.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  
  @GetMapping("/nome/{nome}")
  public ResponseEntity<Cidade> buscarPorNome(@PathVariable String nome) {
    Optional<Cidade> cidade = cidadeService.buscarPorNome(nome);
    return cidade.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  
  @GetMapping("/estado/{estado}")
  public List<Cidade> buscarPorEstado(@PathVariable String estado) {
    return cidadeService.buscarPorEstado(estado);
  }
  
  @PutMapping("/{id}")
  public ResponseEntity<Cidade> atualizar(@PathVariable Long id, @RequestBody Cidade cidade) {
    try {
      Cidade atualizada = cidadeService.atualizar(id, cidade);
      return ResponseEntity.ok(atualizada);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deletar(@PathVariable Long id) {
    try {
      cidadeService.deletar(id);
      return ResponseEntity.ok().build();
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
