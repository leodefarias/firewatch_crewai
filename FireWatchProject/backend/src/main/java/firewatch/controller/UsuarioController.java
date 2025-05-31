package com.firewatch.controller;

import com.firewatch.domain.Usuario;
import com.firewatch.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

  @Autowired
  private UsuarioService usuarioService;

  @PostMapping
  public Usuario cadastrar(@RequestBody Usuario usuario) {
    return usuarioService.cadastrar(usuario);
  }

  @GetMapping
  public List<Usuario> listarTodos() {
    return usuarioService.listarTodos();
  }

  @GetMapping("/cidade/{cidadeId}")
  public List<Usuario> listarPorCidade(@PathVariable Long cidadeId) {
    return usuarioService.listarPorCidade(cidadeId);
  }
}
