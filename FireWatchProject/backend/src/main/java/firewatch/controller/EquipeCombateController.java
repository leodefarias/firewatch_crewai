package com.firewatch.controller;

import com.firewatch.domain.EquipeCombate;
import com.firewatch.service.EquipeCombateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/equipes")
public class EquipeCombateController {

  @Autowired
  private EquipeCombateService equipeService;

  @PostMapping
  public EquipeCombate cadastrar(@RequestBody EquipeCombate equipe) {
    return equipeService.cadastrar(equipe);
  }

  @GetMapping
  public List<EquipeCombate> listarTodas() {
    return equipeService.listarTodas();
  }

  @PutMapping("/{id}/status")
  public EquipeCombate atualizarStatus(@PathVariable Long id, @RequestParam String status) {
    return equipeService.atualizarStatus(id, status);
  }
}
