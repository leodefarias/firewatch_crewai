package firewatch.controller;

import firewatch.domain.EquipeCombate;
import firewatch.service.EquipeCombateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/equipes")
@CrossOrigin(origins = "*")
public class EquipeCombateController {

  @Autowired
  private EquipeCombateService equipeService;

  @PostMapping
  public ResponseEntity<EquipeCombate> cadastrar(@RequestBody EquipeCombate equipe) {
    try {
      EquipeCombate nova = equipeService.cadastrar(equipe);
      return ResponseEntity.ok(nova);
    } catch (Exception e) {
      return ResponseEntity.badRequest().build();
    }
  }

  @GetMapping
  public List<EquipeCombate> listarTodas() {
    return equipeService.listarTodas();
  }
  
  @GetMapping("/{id}")
  public ResponseEntity<EquipeCombate> buscarPorId(@PathVariable Long id) {
    Optional<EquipeCombate> equipe = equipeService.buscarPorId(id);
    return equipe.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  
  @GetMapping("/status/{status}")
  public List<EquipeCombate> buscarPorStatus(@PathVariable String status) {
    return equipeService.buscarPorStatus(status);
  }
  
  @GetMapping("/regiao/{regiao}")
  public List<EquipeCombate> buscarPorRegiao(@PathVariable String regiao) {
    return equipeService.buscarPorRegiao(regiao);
  }
  
  @GetMapping("/disponiveis")
  public List<EquipeCombate> buscarDisponiveis() {
    return equipeService.buscarDisponiveis();
  }
  
  @GetMapping("/disponiveis/regiao/{regiao}")
  public List<EquipeCombate> buscarDisponiveisPorRegiao(@PathVariable String regiao) {
    return equipeService.buscarDisponiveisPorRegiao(regiao);
  }

  @PutMapping("/{id}/status")
  public ResponseEntity<EquipeCombate> atualizarStatus(@PathVariable Long id, @RequestParam String status) {
    try {
      EquipeCombate equipe = equipeService.atualizarStatus(id, status);
      return ResponseEntity.ok(equipe);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  @PutMapping("/{id}")
  public ResponseEntity<EquipeCombate> atualizar(@PathVariable Long id, @RequestBody EquipeCombate equipe) {
    try {
      EquipeCombate atualizada = equipeService.atualizar(id, equipe);
      return ResponseEntity.ok(atualizada);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deletar(@PathVariable Long id) {
    try {
      equipeService.deletar(id);
      return ResponseEntity.ok().build();
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
