package com.firewatch.service;

import com.firewatch.domain.Cidade;
import com.firewatch.repository.CidadeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CidadeService {

  @Autowired
  private CidadeRepository cidadeRepository;

  public Cidade cadastrar(Cidade cidade) {
    return cidadeRepository.save(cidade);
  }

  public List<Cidade> listarTodas() {
    return cidadeRepository.findAll();
  }

  public Cidade buscarPorId(Long id) {
    return cidadeRepository.findById(id).orElse(null);
  }
}
