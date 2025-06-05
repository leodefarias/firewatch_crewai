package firewatch.controller;

import firewatch.domain.Ocorrencia;
import firewatch.service.OcorrenciaService;
import firewatch.service.GeocodingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Controller responsável por gerenciar as operações relacionadas às ocorrências de incêndio.
 * Fornece endpoints para criação, consulta e atualização de ocorrências.
 */
@RestController
@RequestMapping("/api/ocorrencias")
@CrossOrigin(origins = "*")
public class OcorrenciaController {

  @Autowired
  private OcorrenciaService ocorrenciaService;

  @Autowired
  private GeocodingService geocodingService;

  /**
   * Registra uma nova ocorrência de incêndio.
   * Se fornecido um endereço sem coordenadas, realiza geocodificação automática.
   * 
   * @param ocorrencia Dados da ocorrência a ser registrada
   * @return ResponseEntity com a ocorrência criada ou erro em caso de falha
   */
  @PostMapping
  public ResponseEntity<Ocorrencia> registrar(@RequestBody Ocorrencia ocorrencia) {
    try {
      // Se o endereço foi fornecido e não há coordenadas, fazer geocodificação
      if (ocorrencia.getEndereco() != null && !ocorrencia.getEndereco().trim().isEmpty() &&
          (ocorrencia.getLatitude() == null || ocorrencia.getLongitude() == null)) {
        
        double[] coords = geocodingService.geocode(ocorrencia.getEndereco());
        if (coords != null) {
          ocorrencia.setLatitude(coords[0]);
          ocorrencia.setLongitude(coords[1]);
        }
      }
      
      Ocorrencia nova = ocorrenciaService.registrar(ocorrencia);
      return ResponseEntity.ok(nova);
    } catch (Exception e) {
      return ResponseEntity.badRequest().build();
    }
  }

  /**
   * Lista todas as ocorrências registradas no sistema.
   * 
   * @return Lista com todas as ocorrências
   */
  @GetMapping
  public List<Ocorrencia> listarTodas() {
    return ocorrenciaService.listarTodas();
  }

  /**
   * Busca uma ocorrência específica pelo ID.
   * 
   * @param id ID da ocorrência
   * @return ResponseEntity com a ocorrência encontrada ou 404 se não existir
   */
  @GetMapping("/{id}")
  public ResponseEntity<Ocorrencia> buscarPorId(@PathVariable Long id) {
    Optional<Ocorrencia> ocorrencia = ocorrenciaService.buscarPorId(id);
    return ocorrencia.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }

  /**
   * Lista as ocorrências mais recentes de uma cidade específica.
   * 
   * @param cidadeId ID da cidade
   * @return Lista de ocorrências recentes da cidade
   */
  @GetMapping("/cidade/{cidadeId}")
  public List<Ocorrencia> listarRecentes(@PathVariable Long cidadeId) {
    return ocorrenciaService.buscarRecentes(cidadeId);
  }
  
  /**
   * Lista as ocorrências ordenadas por prioridade (severidade).
   * 
   * @return Lista de ocorrências ordenadas por prioridade
   */
  @GetMapping("/prioridade")
  public List<Ocorrencia> listarPorPrioridade() {
    return ocorrenciaService.buscarPorPrioridade();
  }
  
  /**
   * Atribui uma equipe de combate a uma ocorrência específica.
   * 
   * @param id ID da ocorrência
   * @param equipeId ID da equipe a ser atribuída
   * @return ResponseEntity com a ocorrência atualizada ou erro
   */
  @PutMapping("/{id}/atribuir-equipe/{equipeId}")
  public ResponseEntity<Ocorrencia> atribuirEquipe(@PathVariable Long id, @PathVariable Long equipeId) {
    try {
      Ocorrencia ocorrencia = ocorrenciaService.atribuirEquipe(id, equipeId);
      return ResponseEntity.ok(ocorrencia);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
  
  /**
   * Finaliza uma ocorrência, alterando seu status para FINALIZADA.
   * 
   * @param id ID da ocorrência a ser finalizada
   * @return ResponseEntity com a ocorrência finalizada ou erro
   */
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
