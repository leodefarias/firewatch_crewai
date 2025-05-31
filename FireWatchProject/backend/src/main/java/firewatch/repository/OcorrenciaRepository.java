package com.firewatch.repository;

import com.firewatch.domain.Ocorrencia;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface OcorrenciaRepository extends JpaRepository<Ocorrencia, Long> {
    List<Ocorrencia> findByCidadeIdAndDataHoraAfter(Long cidadeId, LocalDateTime dataHora);
}
