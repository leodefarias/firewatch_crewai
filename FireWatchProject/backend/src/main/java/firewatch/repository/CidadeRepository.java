package firewatch.repository;

import firewatch.domain.Cidade;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CidadeRepository extends JpaRepository<Cidade, Long> {
    Optional<Cidade> findByNome(String nome);
    List<Cidade> findByEstado(String estado);
}
