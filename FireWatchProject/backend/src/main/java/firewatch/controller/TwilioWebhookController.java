package firewatch.controller;

import firewatch.domain.Cidade;
import firewatch.domain.Ocorrencia;
import firewatch.service.CidadeService;
import firewatch.service.OcorrenciaService;
import firewatch.service.TwilioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api/webhook")
public class TwilioWebhookController {

    @Autowired
    private OcorrenciaService ocorrenciaService;

    @Autowired
    private CidadeService cidadeService;

    @Autowired
    private TwilioService twilioService;

    @PostMapping("/whatsapp")
    public ResponseEntity<String> receberWhatsApp(
            @RequestParam("From") String from,
            @RequestParam("Body") String body,
            @RequestParam(value = "Latitude", required = false) String latitude,
            @RequestParam(value = "Longitude", required = false) String longitude) {

        try {
            System.out.println("Mensagem recebida de: " + from);
            System.out.println("Conteúdo: " + body);
            System.out.println("Latitude: " + latitude);
            System.out.println("Longitude: " + longitude);

            // Parse das coordenadas da mensagem ou dos parâmetros
            Double lat = null;
            Double lng = null;

            // Tentar extrair coordenadas dos parâmetros Twilio primeiro
            if (latitude != null && longitude != null) {
                try {
                    lat = Double.parseDouble(latitude);
                    lng = Double.parseDouble(longitude);
                } catch (NumberFormatException e) {
                    System.out.println("Erro ao converter coordenadas dos parâmetros");
                }
            }

            // Se não encontrou nos parâmetros, tentar extrair da mensagem
            if (lat == null || lng == null) {
                double[] coords = extrairCoordenadas(body);
                if (coords != null) {
                    lat = coords[0];
                    lng = coords[1];
                }
            }

            if (lat != null && lng != null) {
                // Encontrar cidade mais próxima ou usar padrão
                Cidade cidade = encontrarCidadeMaisProxima(lat, lng);
                if (cidade == null) {
                    // Usar cidade padrão ou criar uma nova
                    Optional<Cidade> cidadePadrao = cidadeService.buscarPorId(1L);
                    cidade = cidadePadrao.orElse(criarCidadePadrao());
                }

                // Determinar severidade baseada na mensagem
                int severidade = determinarSeveridade(body);

                // Extrair descrição da mensagem
                String descricao = extrairDescricao(body);

                // Criar nova ocorrência
                Ocorrencia ocorrencia = new Ocorrencia();
                ocorrencia.setDataHora(LocalDateTime.now());
                ocorrencia.setSeveridade(severidade);
                ocorrencia.setDescricao(descricao);
                ocorrencia.setLatitude(lat);
                ocorrencia.setLongitude(lng);
                ocorrencia.setCidade(cidade);
                ocorrencia.setStatus("ABERTA");

                // Registrar ocorrência (vai disparar notificações)
                Ocorrencia ocorrenciaSalva = ocorrenciaService.registrar(ocorrencia);

                // Responder ao usuário
                String resposta = String.format(
                    "🔥 FIREWATCH - Ocorrência registrada!\n\n" +
                    "📍 Localização: %.6f, %.6f\n" +
                    "🏙️ Cidade: %s\n" +
                    "⚠️ Severidade: %d/10\n" +
                    "🆔 ID: %d\n\n" +
                    "✅ Equipes de combate foram notificadas!\n" +
                    "🚒 Aguarde o atendimento.",
                    lat, lng, cidade.getNome(), severidade, ocorrenciaSalva.getId()
                );

                twilioService.enviarWhatsApp(from.replace("whatsapp:", ""), resposta);

                return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            } else {
                // Solicitar localização
                String resposta = 
                    "🔥 FIREWATCH - Para reportar um incêndio preciso da sua localização!\n\n" +
                    "📍 Envie sua localização através do WhatsApp:\n" +
                    "1. Toque no clipe 📎\n" +
                    "2. Selecione 'Localização'\n" +
                    "3. Escolha 'Localização atual'\n\n" +
                    "Ou envie as coordenadas no formato:\n" +
                    "Lat: -23.5505, Long: -46.6333\n\n" +
                    "🚨 Sua denúncia é importante!";

                twilioService.enviarWhatsApp(from.replace("whatsapp:", ""), resposta);
                return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            }

        } catch (Exception e) {
            System.err.println("Erro ao processar webhook: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
        }
    }

    private double[] extrairCoordenadas(String mensagem) {
        // Padrões para extrair coordenadas
        String[] padroes = {
            "(?i)lat[itude]*\\s*:?\\s*(-?\\d+\\.\\d+).*?lo?ng[itude]*\\s*:?\\s*(-?\\d+\\.\\d+)",
            "(-?\\d+\\.\\d+),\\s*(-?\\d+\\.\\d+)",
            "(-?\\d+\\.\\d+)\\s+(-?\\d+\\.\\d+)"
        };

        for (String padrao : padroes) {
            Pattern pattern = Pattern.compile(padrao);
            Matcher matcher = pattern.matcher(mensagem);
            if (matcher.find()) {
                try {
                    double lat = Double.parseDouble(matcher.group(1));
                    double lng = Double.parseDouble(matcher.group(2));
                    // Validar se as coordenadas são válidas (aproximadamente Brasil)
                    if (lat >= -35 && lat <= 5 && lng >= -75 && lng <= -30) {
                        return new double[]{lat, lng};
                    }
                } catch (NumberFormatException e) {
                    continue;
                }
            }
        }
        return null;
    }

    private int determinarSeveridade(String mensagem) {
        String msgLower = mensagem.toLowerCase();
        
        // Palavras que indicam alta severidade
        if (msgLower.contains("urgente") || msgLower.contains("grande") || 
            msgLower.contains("descontrolado") || msgLower.contains("emergência")) {
            return 9;
        }
        
        // Palavras que indicam média severidade
        if (msgLower.contains("incêndio") || msgLower.contains("fogo") || 
            msgLower.contains("queimada") || msgLower.contains("fumaça")) {
            return 7;
        }
        
        // Palavras que indicam baixa severidade
        if (msgLower.contains("pequeno") || msgLower.contains("controlado") || 
            msgLower.contains("suspeita")) {
            return 4;
        }
        
        // Severidade padrão
        return 6;
    }

    private String extrairDescricao(String mensagem) {
        // Remover coordenadas da descrição
        String descricao = mensagem.replaceAll("(?i)lat[itude]*\\s*:?\\s*-?\\d+\\.\\d+", "")
                                  .replaceAll("(?i)lo?ng[itude]*\\s*:?\\s*-?\\d+\\.\\d+", "")
                                  .replaceAll("-?\\d+\\.\\d+,\\s*-?\\d+\\.\\d+", "")
                                  .trim();
        
        if (descricao.isEmpty()) {
            descricao = "Ocorrência reportada via WhatsApp";
        }
        
        return "Via WhatsApp: " + descricao;
    }

    private Cidade encontrarCidadeMaisProxima(Double latitude, Double longitude) {
        // Implementação simples - pode ser melhorada com cálculo de distância real
        return cidadeService.listarTodas().stream()
                .filter(cidade -> cidade.getLatitude() != null && cidade.getLongitude() != null)
                .min((c1, c2) -> {
                    double dist1 = calcularDistancia(latitude, longitude, c1.getLatitude(), c1.getLongitude());
                    double dist2 = calcularDistancia(latitude, longitude, c2.getLatitude(), c2.getLongitude());
                    return Double.compare(dist1, dist2);
                })
                .orElse(null);
    }

    private double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
        double earthRadius = 6371; // km
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon/2) * Math.sin(dLon/2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return earthRadius * c;
    }

    private Cidade criarCidadePadrao() {
        Cidade cidade = new Cidade();
        cidade.setNome("Localização via WhatsApp");
        cidade.setEstado("SP");
        cidade.setLatitude(-23.5505);
        cidade.setLongitude(-46.6333);
        return cidadeService.cadastrar(cidade);
    }
}