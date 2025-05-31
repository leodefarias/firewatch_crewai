package firewatch.repository;

import firewatch.domain.Ocorrencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface OcorrenciaRepository extends JpaRepository<Ocorrencia, Long> {
    List<Ocorrencia> findByCidadeIdAndDataHoraAfter(Long cidadeId, LocalDateTime dataHora);
    List<Ocorrencia> findByStatus(String status);
    List<Ocorrencia> findBySeveridadeGreaterThanEqual(int severidade);
    
    @Query("SELECT o FROM Ocorrencia o WHERE o.status = 'ABERTA' ORDER BY o.severidade DESC, o.dataHora ASC")
    List<Ocorrencia> findOcorrenciasAbertasPorPrioridade();
}
