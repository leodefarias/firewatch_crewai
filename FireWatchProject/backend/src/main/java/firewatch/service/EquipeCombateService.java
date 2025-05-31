package com.firewatch.service;

import com.firewatch.domain.EquipeCombate;
import com.firewatch.repository.EquipeCombateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EquipeCombateService {

  @Autowired
  private EquipeCombateRepository equipeCombateRepository;

  public EquipeCombate cadastrar(EquipeCombate equipe) {
    return equipeCombateRepository.save(equipe);
  }

  public List<EquipeCombate> listarTodas() {
    return equipeCombateRepository.findAll();
  }

  public EquipeCombate buscarPorId(Long id) {
    return equipeCombateRepository.findById(id).orElse(null);
  }

  public EquipeCombate atualizarStatus(Long id, String novoStatus) {
    EquipeCombate equipe = buscarPorId(id);
    if (equipe != null) {
      equipe.setStatus(novoStatus);
      return equipeCombateRepository.save(equipe);
    }
    return null;
  }
}
