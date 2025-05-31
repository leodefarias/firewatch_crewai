package firewatch.controller;

import firewatch.domain.Ocorrencia;
import firewatch.service.OcorrenciaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/ocorrencias")
@CrossOrigin(origins = "*")
public class OcorrenciaController {

  @Autowired
  private OcorrenciaService ocorrenciaService;

  @PostMapping
  public ResponseEntity<Ocorrencia> registrar(@RequestBody Ocorrencia ocorrencia) {
    try {
      Ocorrencia nova = ocorrenciaService.registrar(ocorrencia);
      return ResponseEntity.ok(nova);
    } catch (Exception e) {
      return ResponseEntity.badRequest().build();
    }
  }

  @GetMapping
  public List<Ocorrencia> listarTodas() {
    return ocorrenciaService.listarTodas();
  }

  @GetMapping("/{id}")
  public ResponseEntity<Ocorrencia> buscarPorId(@PathVariable Long id) {
    Optional<Ocorrencia> ocorrencia = ocorrenciaService.buscarPorId(id);
    return ocorrencia.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }

  @GetMapping("/cidade/{cidadeId}")
  public List<Ocorrencia> listarRecentes(@PathVariable Long cidadeId) {
    return ocorrenciaService.buscarRecentes(cidadeId);
  }
  
  @GetMapping("/prioridade")
  public List<Ocorrencia> listarPorPrioridade() {
    return ocorrenciaService.buscarPorPrioridade();
  }
  
  @PutMapping("/{id}/atribuir-equipe/{equipeId}")
  public ResponseEntity<Ocorrencia> atribuirEquipe(@PathVariable Long id, @PathVariable Long equipeId) {
    try {
      Ocorrencia ocorrencia = ocorrenciaService.atribuirEquipe(id, equipeId);
      return ResponseEntity.ok(ocorrencia);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  @PutMapping("/{id}/finalizar")
  public ResponseEntity<Ocorrencia> finalizar(@PathVariable Long id) {
    try {
      Ocorrencia ocorrencia = ocorrenciaService.finalizarOcorrencia(id);
      return ResponseEntity.ok(ocorrencia);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
