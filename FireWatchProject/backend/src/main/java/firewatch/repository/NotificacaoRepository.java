package firewatch.repository;

import firewatch.domain.Notificacao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificacaoRepository extends JpaRepository<Notificacao, Long> {
    List<Notificacao> findByUsuarioId(Long usuarioId);
    List<Notificacao> findByOcorrenciaId(Long ocorrenciaId);
    List<Notificacao> findByStatus(String status);
    List<Notificacao> findByTipoNotificacao(String tipoNotificacao);
}
