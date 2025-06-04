package firewatch.service;

import firewatch.domain.Ocorrencia;
import firewatch.domain.EquipeCombate;
import firewatch.repository.OcorrenciaRepository;
import firewatch.repository.EquipeCombateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class OcorrenciaService {

  @Autowired
  private OcorrenciaRepository ocorrenciaRepository;
  
  @Autowired
  private EquipeCombateRepository equipeRepository;
  
  @Autowired
  private NotificacaoService notificacaoService;

  public Ocorrencia registrar(Ocorrencia ocorrencia) {
    ocorrencia.setDataHora(LocalDateTime.now());
    ocorrencia.setStatus("ABERTA");
    Ocorrencia salva = ocorrenciaRepository.save(ocorrencia);
    
    notificacaoService.enviarAlertas(salva);
    
    return salva;
  }

  public List<Ocorrencia> buscarRecentes(Long cidadeId) {
    LocalDateTime umaHoraAtras = LocalDateTime.now().minusHours(1);
    return ocorrenciaRepository.findByCidadeIdAndDataHoraAfter(cidadeId, umaHoraAtras);
  }
  
  public List<Ocorrencia> buscarPorPrioridade() {
    return ocorrenciaRepository.findOcorrenciasAbertasPorPrioridade();
  }
  
  public Ocorrencia atribuirEquipe(Long ocorrenciaId, Long equipeId) {
    Optional<Ocorrencia> ocorrencia = ocorrenciaRepository.findById(ocorrenciaId);
    Optional<EquipeCombate> equipe = equipeRepository.findById(equipeId);
    
    if (ocorrencia.isPresent() && equipe.isPresent()) {
      Ocorrencia occ = ocorrencia.get();
      EquipeCombate eq = equipe.get();
      
      occ.setEquipeResponsavel(eq);
      occ.setStatus("EM_ATENDIMENTO");
      eq.setStatus("EM_ACAO");
      
      equipeRepository.save(eq);
      return ocorrenciaRepository.save(occ);
    }
    
    throw new RuntimeException("Ocorrência ou equipe não encontrada");
  }
  
  public Ocorrencia finalizarOcorrencia(Long ocorrenciaId) {
    Optional<Ocorrencia> ocorrencia = ocorrenciaRepository.findById(ocorrenciaId);
    
    if (ocorrencia.isPresent()) {
      Ocorrencia occ = ocorrencia.get();
      occ.setStatus("FINALIZADA");
      
      if (occ.getEquipeResponsavel() != null) {
        EquipeCombate equipe = occ.getEquipeResponsavel();
        equipe.setStatus("DISPONIVEL");
        equipeRepository.save(equipe);
      }
      
      return ocorrenciaRepository.save(occ);
    }
    
    throw new RuntimeException("Ocorrência não encontrada");
  }
  
  public List<Ocorrencia> listarTodas() {
    return ocorrenciaRepository.findAll();
  }
  
  public Optional<Ocorrencia> buscarPorId(Long id) {
    return ocorrenciaRepository.findById(id);
  }
}
