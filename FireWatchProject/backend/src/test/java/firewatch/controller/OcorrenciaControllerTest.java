package firewatch.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import firewatch.domain.Cidade;
import firewatch.domain.Ocorrencia;
import firewatch.service.OcorrenciaService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(OcorrenciaController.class)
@ActiveProfiles("test")
public class OcorrenciaControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private OcorrenciaService ocorrenciaService;

    @Autowired
    private ObjectMapper objectMapper;

    private Cidade cidade;
    private Ocorrencia ocorrencia;

    @BeforeEach
    void setUp() {
        cidade = new Cidade("São Paulo", -23.5505, -46.6333, "SP");
        cidade.setId(1L);
        
        ocorrencia = new Ocorrencia(
            LocalDateTime.now(),
            8,
            "Incêndio de grandes proporções",
            -23.5505,
            -46.6333,
            cidade
        );
        ocorrencia.setId(1L);
    }

    @Test
    void deveListarTodasOcorrencias() throws Exception {
        when(ocorrenciaService.listarTodas()).thenReturn(Arrays.asList(ocorrencia));

        mockMvc.perform(get("/api/ocorrencias"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].severidade").value(8))
                .andExpect(jsonPath("$[0].descricao").value("Incêndio de grandes proporções"));
    }

    @Test
    void deveBuscarOcorrenciaPorId() throws Exception {
        when(ocorrenciaService.buscarPorId(1L)).thenReturn(Optional.of(ocorrencia));

        mockMvc.perform(get("/api/ocorrencias/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.severidade").value(8));
    }

    @Test
    void deveRetornar404QuandoOcorrenciaNaoEncontrada() throws Exception {
        when(ocorrenciaService.buscarPorId(999L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/ocorrencias/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void deveRegistrarNovaOcorrencia() throws Exception {
        when(ocorrenciaService.registrar(any(Ocorrencia.class))).thenReturn(ocorrencia);

        String ocorrenciaJson = objectMapper.writeValueAsString(ocorrencia);

        mockMvc.perform(post("/api/ocorrencias")
                .contentType(MediaType.APPLICATION_JSON)
                .content(ocorrenciaJson))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.severidade").value(8))
                .andExpect(jsonPath("$.descricao").value("Incêndio de grandes proporções"));
    }

    @Test
    void deveAtribuirEquipeAOcorrencia() throws Exception {
        when(ocorrenciaService.atribuirEquipe(1L, 1L)).thenReturn(ocorrencia);

        mockMvc.perform(put("/api/ocorrencias/1/atribuir-equipe/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    void deveFinalizarOcorrencia() throws Exception {
        ocorrencia.setStatus("FINALIZADA");
        when(ocorrenciaService.finalizarOcorrencia(1L)).thenReturn(ocorrencia);

        mockMvc.perform(put("/api/ocorrencias/1/finalizar"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value("FINALIZADA"));
    }

    @Test
    void deveListarOcorrenciasPorPrioridade() throws Exception {
        when(ocorrenciaService.buscarPorPrioridade()).thenReturn(Arrays.asList(ocorrencia));

        mockMvc.perform(get("/api/ocorrencias/prioridade"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].severidade").value(8));
    }
}