package com.firewatch.controller;

import com.firewatch.domain.Cidade;
import com.firewatch.service.CidadeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cidades")
public class CidadeController {

  @Autowired
  private CidadeService cidadeService;

  @PostMapping
  public Cidade cadastrar(@RequestBody Cidade cidade) {
    return cidadeService.cadastrar(cidade);
  }

  @GetMapping
  public List<Cidade> listarTodas() {
    return cidadeService.listarTodas();
  }
}
