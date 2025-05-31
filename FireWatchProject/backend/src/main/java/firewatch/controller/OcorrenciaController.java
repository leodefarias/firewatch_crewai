package com.firewatch.controller;

import com.firewatch.domain.Ocorrencia;
import com.firewatch.service.OcorrenciaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ocorrencias")
public class OcorrenciaController {

  @Autowired
  private OcorrenciaService ocorrenciaService;

  @PostMapping
  public Ocorrencia registrar(@RequestBody Ocorrencia ocorrencia) {
    return ocorrenciaService.registrar(ocorrencia);
  }

  @GetMapping("/cidade/{cidadeId}")
  public List<Ocorrencia> listarRecentes(@PathVariable Long cidadeId) {
    return ocorrenciaService.buscarRecentes(cidadeId);
  }
}
