package com.firewatch.service;

import com.firewatch.domain.Notificacao;
import com.firewatch.domain.Usuario;
import com.firewatch.repository.NotificacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class NotificacaoService {

  @Autowired
  private NotificacaoRepository notificacaoRepository;

  public Notificacao registrarNotificacao(Usuario usuario, String mensagem) {
    Notificacao notificacao = new Notificacao(mensagem, LocalDateTime.now(), usuario);
    return notificacaoRepository.save(notificacao);
  }
}
