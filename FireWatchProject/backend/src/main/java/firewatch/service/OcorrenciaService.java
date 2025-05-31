package com.firewatch.service;

import com.firewatch.domain.Ocorrencia;
import com.firewatch.repository.OcorrenciaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OcorrenciaService {

  @Autowired
  private OcorrenciaRepository ocorrenciaRepository;

  public Ocorrencia registrar(Ocorrencia ocorrencia) {
    ocorrencia.setDataHora(LocalDateTime.now());
    return ocorrenciaRepository.save(ocorrencia);
  }

  public List<Ocorrencia> buscarRecentes(Long cidadeId) {
    LocalDateTime umaHoraAtras = LocalDateTime.now().minusHours(1);
    return ocorrenciaRepository.findByCidadeIdAndDataHoraAfter(cidadeId, umaHoraAtras);
  }
}
