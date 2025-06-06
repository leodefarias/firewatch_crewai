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

/**
 * Serviço responsável pela lógica de negócio das ocorrências de incêndio.
 * Gerencia o ciclo de vida completo das ocorrências, desde o registro até a finalização.
 */
@Service
public class OcorrenciaService {

  @Autowired
  private OcorrenciaRepository ocorrenciaRepository;
  
  @Autowired
  private EquipeCombateRepository equipeRepository;
  
  @Autowired
  private NotificacaoService notificacaoService;

  /**
   * Registra uma nova ocorrência no sistema.
   * Define automaticamente data/hora atual e status como ABERTA, além de enviar alertas.
   * 
   * @param ocorrencia Dados da ocorrência a ser registrada
   * @return Ocorrência registrada com ID gerado
   */
  public Ocorrencia registrar(Ocorrencia ocorrencia) {
    ocorrencia.setDataHora(LocalDateTime.now());
    ocorrencia.setStatus("ABERTA");
    Ocorrencia salva = ocorrenciaRepository.save(ocorrencia);
    
    notificacaoService.enviarAlertas(salva);
    
    return salva;
  }

  /**
   * Busca ocorrências recentes de uma cidade (da última hora).
   * 
   * @param cidadeId ID da cidade
   * @return Lista de ocorrências da última hora na cidade
   */
  public List<Ocorrencia> buscarRecentes(Long cidadeId) {
    LocalDateTime umaHoraAtras = LocalDateTime.now().minusHours(1);
    return ocorrenciaRepository.findByCidadeIdAndDataHoraAfter(cidadeId, umaHoraAtras);
  }
  
  /**
   * Busca ocorrências abertas ordenadas por prioridade (severidade).
   * 
   * @return Lista de ocorrências abertas ordenadas por severidade
   */
  public List<Ocorrencia> buscarPorPrioridade() {
    return ocorrenciaRepository.findOcorrenciasAbertasPorPrioridade();
  }
  
  /**
   * Atribui uma equipe de combate a uma ocorrência.
   * Altera o status da ocorrência para EM_ATENDIMENTO e da equipe para EM_ACAO.
   * 
   * @param ocorrenciaId ID da ocorrência
   * @param equipeId ID da equipe
   * @return Ocorrência atualizada com equipe atribuída
   * @throws RuntimeException se ocorrência ou equipe não for encontrada
   */
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
  
  /**
   * Finaliza uma ocorrência, alterando status para FINALIZADA.
   * Libera a equipe responsável alterando seu status para DISPONIVEL.
   * 
   * @param ocorrenciaId ID da ocorrência a ser finalizada
   * @return Ocorrência finalizada
   * @throws RuntimeException se ocorrência não for encontrada
   */
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
  
  /**
   * Lista todas as ocorrências do sistema.
   * 
   * @return Lista completa de ocorrências
   */
  public List<Ocorrencia> listarTodas() {
    return ocorrenciaRepository.findAll();
  }
  
  /**
   * Busca uma ocorrência pelo ID.
   * 
   * @param id ID da ocorrência
   * @return Optional contendo a ocorrência se encontrada
   */
  public Optional<Ocorrencia> buscarPorId(Long id) {
    return ocorrenciaRepository.findById(id);
  }
}
