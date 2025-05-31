package firewatch.repository;

import firewatch.domain.EquipeCombate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EquipeCombateRepository extends JpaRepository<EquipeCombate, Long> {
    List<EquipeCombate> findByStatus(String status);
    List<EquipeCombate> findByRegiao(String regiao);
    List<EquipeCombate> findByStatusAndRegiao(String status, String regiao);
}
