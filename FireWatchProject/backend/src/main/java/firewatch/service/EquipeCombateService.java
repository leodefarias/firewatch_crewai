package firewatch.service;

import firewatch.domain.EquipeCombate;
import firewatch.repository.EquipeCombateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EquipeCombateService {

  @Autowired
  private EquipeCombateRepository equipeCombateRepository;

  public EquipeCombate cadastrar(EquipeCombate equipe) {
    equipe.setStatus("DISPONIVEL");
    return equipeCombateRepository.save(equipe);
  }

  public List<EquipeCombate> listarTodas() {
    return equipeCombateRepository.findAll();
  }

  public Optional<EquipeCombate> buscarPorId(Long id) {
    return equipeCombateRepository.findById(id);
  }
  
  public List<EquipeCombate> buscarPorStatus(String status) {
    return equipeCombateRepository.findByStatus(status);
  }
  
  public List<EquipeCombate> buscarPorRegiao(String regiao) {
    return equipeCombateRepository.findByRegiao(regiao);
  }
  
  public List<EquipeCombate> buscarDisponiveis() {
    return equipeCombateRepository.findByStatus("DISPONIVEL");
  }
  
  public List<EquipeCombate> buscarDisponiveisPorRegiao(String regiao) {
    return equipeCombateRepository.findByStatusAndRegiao("DISPONIVEL", regiao);
  }

  public EquipeCombate atualizarStatus(Long id, String novoStatus) {
    Optional<EquipeCombate> equipeOpt = equipeCombateRepository.findById(id);
    if (equipeOpt.isPresent()) {
      EquipeCombate equipe = equipeOpt.get();
      equipe.setStatus(novoStatus);
      return equipeCombateRepository.save(equipe);
    }
    throw new RuntimeException("Equipe não encontrada");
  }
  
  public EquipeCombate atualizar(Long id, EquipeCombate equipeAtualizada) {
    Optional<EquipeCombate> equipeExistente = equipeCombateRepository.findById(id);
    if (equipeExistente.isPresent()) {
      EquipeCombate equipe = equipeExistente.get();
      equipe.setNome(equipeAtualizada.getNome());
      equipe.setRegiao(equipeAtualizada.getRegiao());
      equipe.setNumeroMembros(equipeAtualizada.getNumeroMembros());
      equipe.setTipoEquipamento(equipeAtualizada.getTipoEquipamento());
      return equipeCombateRepository.save(equipe);
    }
    throw new RuntimeException("Equipe não encontrada");
  }
  
  public void deletar(Long id) {
    equipeCombateRepository.deleteById(id);
  }
}
