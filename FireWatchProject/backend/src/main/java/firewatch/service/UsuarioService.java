package com.firewatch.service;

import com.firewatch.domain.Usuario;
import com.firewatch.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

  @Autowired
  private UsuarioRepository usuarioRepository;

  public Usuario cadastrar(Usuario usuario) {
    return usuarioRepository.save(usuario);
  }

  public List<Usuario> listarTodos() {
    return usuarioRepository.findAll();
  }

  public List<Usuario> listarPorCidade(Long cidadeId) {
    return usuarioRepository.findByCidadeId(cidadeId);
  }
}
