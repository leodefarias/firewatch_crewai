package firewatch.controller;

import firewatch.domain.Notificacao;
import firewatch.service.NotificacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notificacoes")
@CrossOrigin(origins = "*")
public class NotificacaoController {

  @Autowired
  private NotificacaoService notificacaoService;

  @GetMapping
  public List<Notificacao> listarTodas() {
    return notificacaoService.listarTodas();
  }

  @GetMapping("/usuario/{usuarioId}")
  public List<Notificacao> buscarPorUsuario(@PathVariable Long usuarioId) {
    return notificacaoService.buscarPorUsuario(usuarioId);
  }

  @GetMapping("/ocorrencia/{ocorrenciaId}")
  public List<Notificacao> buscarPorOcorrencia(@PathVariable Long ocorrenciaId) {
    return notificacaoService.buscarPorOcorrencia(ocorrenciaId);
  }
}