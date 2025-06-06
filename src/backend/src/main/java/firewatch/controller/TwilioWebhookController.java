package firewatch.controller;

import firewatch.domain.Cidade;
import firewatch.domain.Ocorrencia;
import firewatch.domain.Usuario;
import firewatch.service.CidadeService;
import firewatch.service.GeocodingService;
import firewatch.service.OcorrenciaService;
import firewatch.service.TwilioService;
import firewatch.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api")
public class TwilioWebhookController {
    
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("FireWatch API is running!");
    }
    
    @GetMapping("/test-geocoding")
    public ResponseEntity<String> testGeocoding(@RequestParam String endereco) {
        try {
            double[] coords = geocodingService.geocode(endereco);
            if (coords != null) {
                return ResponseEntity.ok(String.format("Geocodificação bem-sucedida: %.6f, %.6f", coords[0], coords[1]));
            } else {
                return ResponseEntity.ok("Geocodificação falhou: endereço não encontrado");
            }
        } catch (Exception e) {
            return ResponseEntity.ok("Erro na geocodificação: " + e.getMessage());
        }
    }

    @Autowired
    private OcorrenciaService ocorrenciaService;

    @Autowired
    private CidadeService cidadeService;

    @Autowired
    private TwilioService twilioService;
    
    @Autowired
    private UsuarioService usuarioService;
    
    @Autowired
    private GeocodingService geocodingService;

    @PostMapping({"/webhook/whatsapp", "/app/api/webhook/whatsapp"})
    public ResponseEntity<String> receberWhatsApp(
            @RequestParam("From") String from,
            @RequestParam("Body") String body,
            @RequestParam(value = "Latitude", required = false) String latitude,
            @RequestParam(value = "Longitude", required = false) String longitude) {

        try {
            // Decodificar URL encoding
            String bodyDecodificado = URLDecoder.decode(body, StandardCharsets.UTF_8);
            
            System.out.println("=== WEBHOOK TWILIO ===");
            System.out.println("Mensagem recebida de: " + from);
            System.out.println("Conteúdo original: " + body);
            System.out.println("Conteúdo decodificado: " + bodyDecodificado);
            System.out.println("Latitude: " + latitude);
            System.out.println("Longitude: " + longitude);
            System.out.println("=====================");

            String numeroLimpo = from.replace("whatsapp:", "");
            
            // Verificar se usuário já existe
            System.out.println("Buscando usuário: " + numeroLimpo);
            Optional<Usuario> usuarioExistente = usuarioService.buscarPorTelefone(numeroLimpo);
            
            if (usuarioExistente.isEmpty()) {
                System.out.println("Usuário não encontrado - iniciando cadastro");
                // Usuário novo - iniciar processo de cadastro
                return processarCadastroUsuario(numeroLimpo, bodyDecodificado);
            } else {
                System.out.println("Usuário encontrado: " + usuarioExistente.get().getNome());
                // Usuário existente - processar denúncia de incêndio
                return processarDenunciaIncendio(usuarioExistente.get(), bodyDecodificado, latitude, longitude);
            }

        } catch (Exception e) {
            System.err.println("=== ERRO NO WEBHOOK ===");
            System.err.println("Erro ao processar webhook: " + e.getMessage());
            e.printStackTrace();
            System.err.println("========================");
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
    
    private ResponseEntity<String> processarCadastroUsuario(String telefone, String mensagem) {
        String resposta = 
            "🔥 Bem-vindo ao FIREWATCH! 🔥\n\n" +
            "Para reportar incêndios, preciso cadastrar seus dados.\n\n" +
            "📝 Por favor, envie seus dados no seguinte formato:\n\n" +
            "NOME: Seu Nome Completo\n" +
            "ENDERECO: Sua Rua, Número, Bairro\n" +
            "CIDADE: Sua Cidade\n\n" +
            "📱 Exemplo:\n" +
            "NOME: João Silva\n" +
            "ENDERECO: Rua das Flores, 123, Centro\n" +
            "CIDADE: São Paulo\n\n" +
            "🚨 Após o cadastro, você poderá reportar incêndios!";
        
        // Verificar se a mensagem contém dados de cadastro
        if (mensagem.toUpperCase().contains("NOME:") && 
            mensagem.toUpperCase().contains("ENDERECO:") && 
            mensagem.toUpperCase().contains("CIDADE:")) {
            
            return finalizarCadastroUsuario(telefone, mensagem);
        }
        
        twilioService.enviarWhatsApp(telefone, resposta);
        return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
    }
    
    private ResponseEntity<String> finalizarCadastroUsuario(String telefone, String mensagem) {
        try {
            // Extrair dados da mensagem
            String nome = extrairDado(mensagem, "NOME:");
            String endereco = extrairDado(mensagem, "ENDERECO:");
            String nomeCidade = extrairDado(mensagem, "CIDADE:");
            
            if (nome.isEmpty() || endereco.isEmpty() || nomeCidade.isEmpty()) {
                String resposta = 
                    "❌ Dados incompletos!\n\n" +
                    "📝 Por favor, envie novamente no formato:\n\n" +
                    "NOME: Seu Nome Completo\n" +
                    "ENDERECO: Sua Rua, Número, Bairro\n" +
                    "CIDADE: Sua Cidade";
                
                twilioService.enviarWhatsApp(telefone, resposta);
                return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            }
            
            // Buscar ou criar cidade
            Cidade cidade = cidadeService.listarTodas().stream()
                .filter(c -> c.getNome().toLowerCase().contains(nomeCidade.toLowerCase()))
                .findFirst()
                .orElse(criarNovaCidade(nomeCidade));
            
            // Criar usuário
            Usuario novoUsuario = new Usuario();
            novoUsuario.setNome(nome);
            novoUsuario.setTelefone(telefone);
            novoUsuario.setEndereco(endereco);
            novoUsuario.setTipoUsuario("CIDADAO");
            novoUsuario.setCidade(cidade);
            
            usuarioService.cadastrar(novoUsuario);
            
            String resposta = String.format(
                "✅ Cadastro realizado com sucesso!\n\n" +
                "👤 Nome: %s\n" +
                "📍 Endereço: %s\n" +
                "🏙️ Cidade: %s\n" +
                "📱 Telefone: %s\n\n" +
                "🔥 Agora você pode reportar incêndios!\n" +
                "📍 Envie sua localização ou coordenadas quando detectar um incêndio.",
                nome, endereco, cidade.getNome(), telefone
            );
            
            twilioService.enviarWhatsApp(telefone, resposta);
            return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            
        } catch (Exception e) {
            System.err.println("Erro ao cadastrar usuário: " + e.getMessage());
            String resposta = 
                "❌ Erro no cadastro!\n\n" +
                "📝 Tente novamente no formato:\n" +
                "NOME: Seu Nome\n" +
                "ENDERECO: Seu Endereço\n" +
                "CIDADE: Sua Cidade";
            
            twilioService.enviarWhatsApp(telefone, resposta);
            return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
        }
    }
    
    private ResponseEntity<String> processarDenunciaIncendio(Usuario usuario, String mensagem, String latitude, String longitude) {
        try {
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
                double[] coords = extrairCoordenadas(mensagem);
                if (coords != null) {
                    lat = coords[0];
                    lng = coords[1];
                }
            }
            
            // Se ainda não encontrou coordenadas, tentar geocodificar a mensagem como endereço
            String enderecoOcorrencia = null;
            if ((lat == null || lng == null) && mensagem.length() > 10) {
                try {
                    System.out.println("Tentando geocodificar: " + mensagem.substring(0, Math.min(50, mensagem.length())));
                    double[] coordsGeocodificadas = geocodingService.geocode(mensagem);
                    if (coordsGeocodificadas != null) {
                        lat = coordsGeocodificadas[0];
                        lng = coordsGeocodificadas[1];
                        enderecoOcorrencia = mensagem.trim(); // Salvar o endereço que foi geocodificado
                        System.out.println("Geocodificação bem-sucedida: " + lat + ", " + lng);
                    }
                } catch (Exception e) {
                    System.err.println("Erro na geocodificação: " + e.getMessage());
                }
            }

            if (lat != null && lng != null) {
                // Encontrar cidade mais próxima ou usar a cidade do usuário
                Cidade cidade = encontrarCidadeMaisProxima(lat, lng);
                if (cidade == null) {
                    cidade = usuario.getCidade();
                }

                // Determinar severidade baseada na mensagem
                int severidade = determinarSeveridade(mensagem);

                // Extrair descrição da mensagem
                String descricao = extrairDescricao(mensagem);

                // Criar nova ocorrência
                Ocorrencia ocorrencia = new Ocorrencia();
                ocorrencia.setDataHora(LocalDateTime.now());
                ocorrencia.setSeveridade(severidade);
                ocorrencia.setDescricao("Reportado por " + usuario.getNome() + ": " + descricao);
                ocorrencia.setLatitude(lat);
                ocorrencia.setLongitude(lng);
                ocorrencia.setCidade(cidade);
                ocorrencia.setStatus("ABERTA");
                
                // Definir endereço se foi geocodificado
                if (enderecoOcorrencia != null) {
                    ocorrencia.setEndereco(enderecoOcorrencia);
                }

                // Registrar ocorrência (vai disparar notificações)
                Ocorrencia ocorrenciaSalva = ocorrenciaService.registrar(ocorrencia);

                // Determinar se foi geocodificado
                boolean foiGeocodificado = (latitude == null || longitude == null) && 
                                         extrairCoordenadas(mensagem) == null;
                
                // Responder ao usuário
                String resposta = String.format(
                    "🔥 FIREWATCH - Ocorrência registrada!\n\n" +
                    "👤 Reportado por: %s\n" +
                    "📍 Localização: %.6f, %.6f%s\n" +
                    "🏙️ Cidade: %s\n" +
                    "⚠️ Severidade: %d/10\n" +
                    "🆔 ID: %d\n\n" +
                    "✅ Equipes de combate foram notificadas!\n" +
                    "🚒 Aguarde o atendimento.\n\n" +
                    "Obrigado por ajudar a proteger nossa comunidade! 🙏",
                    usuario.getNome(), 
                    lat, lng, 
                    foiGeocodificado ? " (geocodificado)" : "",
                    cidade.getNome(), 
                    severidade, 
                    ocorrenciaSalva.getId()
                );

                twilioService.enviarWhatsApp(usuario.getTelefone(), resposta);
                return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            } else {
                // Solicitar localização
                String resposta = String.format(
                    "Olá %s! 👋\n\n" +
                    "🔥 Para reportar o incêndio, preciso da localização!\n\n" +
                    "📍 Opções para enviar localização:\n\n" +
                    "1️⃣ Compartilhar localização pelo WhatsApp:\n" +
                    "   • Toque no clipe 📎\n" +
                    "   • Selecione 'Localização'\n" +
                    "   • Escolha 'Localização atual'\n\n" +
                    "2️⃣ Enviar coordenadas:\n" +
                    "   Lat: -23.5505, Long: -46.6333\n\n" +
                    "3️⃣ Enviar endereço:\n" +
                    "   Rua das Flores, 123, Vila Nova, São Paulo\n" +
                    "   Av. Paulista, 1000, Bela Vista\n\n" +
                    "🚨 Cada segundo conta!",
                    usuario.getNome()
                );

                twilioService.enviarWhatsApp(usuario.getTelefone(), resposta);
                return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
            }
        } catch (Exception e) {
            System.err.println("Erro ao processar denúncia: " + e.getMessage());
            String resposta = "❌ Erro ao processar denúncia. Tente novamente.";
            twilioService.enviarWhatsApp(usuario.getTelefone(), resposta);
            return ResponseEntity.ok("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>");
        }
    }
    
    private String extrairDado(String mensagem, String chave) {
        String[] linhas = mensagem.split("\n");
        for (String linha : linhas) {
            if (linha.toUpperCase().contains(chave)) {
                return linha.substring(linha.indexOf(":") + 1).trim();
            }
        }
        return "";
    }
    
    private Cidade criarNovaCidade(String nomeCidade) {
        Cidade cidade = new Cidade();
        cidade.setNome(nomeCidade);
        cidade.setEstado("BR");
        cidade.setLatitude(-14.235); // Centro do Brasil
        cidade.setLongitude(-51.925);
        return cidadeService.cadastrar(cidade);
    }
}