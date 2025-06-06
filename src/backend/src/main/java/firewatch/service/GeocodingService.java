package firewatch.service;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@Service
public class GeocodingService {

    private final WebClient webClient;

    public GeocodingService() {
        this.webClient = WebClient.builder()
                .baseUrl("https://nominatim.openstreetmap.org")
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(1024 * 1024)) // 1MB limit
                .build();
    }

    public double[] geocode(String endereco) {
        try {
            String enderecoFormatado = formatarEndereco(endereco);
            
            List<GeocodingResponse> responses = webClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/search")
                            .queryParam("q", enderecoFormatado)
                            .queryParam("format", "json")
                            .queryParam("limit", "1")
                            .queryParam("countrycodes", "br")
                            .build())
                    .header("User-Agent", "FireWatch/1.0")
                    .retrieve()
                    .bodyToFlux(GeocodingResponse.class)
                    .collectList()
                    .timeout(java.time.Duration.ofSeconds(20))
                    .block();

            if (responses != null && !responses.isEmpty()) {
                GeocodingResponse response = responses.get(0);
                double latitude = Double.parseDouble(response.lat);
                double longitude = Double.parseDouble(response.lon);
                
                // Validar se as coordenadas estão no Brasil
                if (latitude >= -35 && latitude <= 5 && longitude >= -75 && longitude <= -30) {
                    return new double[]{latitude, longitude};
                }
            }
        } catch (Exception e) {
            System.err.println("Erro ao geocodificar endereço: " + e.getMessage());
            e.printStackTrace(); // Adicione esta linha
        }
        
        return null;
    }

    private String formatarEndereco(String endereco) {
        // Adicionar "Brasil" se não estiver presente
        if (!endereco.toLowerCase().contains("brasil") && !endereco.toLowerCase().contains("brazil")) {
            endereco += ", Brasil";
        }
        return endereco.trim();
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class GeocodingResponse {
        @JsonProperty("lat")
        public String lat;
        
        @JsonProperty("lon")
        public String lon;
        
        @JsonProperty("display_name")
        public String displayName;
    }
}