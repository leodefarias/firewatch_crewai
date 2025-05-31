package firewatch.service;

import firewatch.domain.Cidade;
import firewatch.domain.EquipeCombate;
import firewatch.domain.Ocorrencia;
import firewatch.repository.EquipeCombateRepository;
import firewatch.repository.OcorrenciaRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class OcorrenciaServiceTest {

    @Mock
    private OcorrenciaRepository ocorrenciaRepository;

    @Mock
    private EquipeCombateRepository equipeRepository;

    @Mock
    private NotificacaoService notificacaoService;

    @InjectMocks
    private OcorrenciaService ocorrenciaService;

    private Cidade cidade;
    private Ocorrencia ocorrencia;
    private EquipeCombate equipe;

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

        equipe = new EquipeCombate("Bombeiros SP", "DISPONIVEL", "São Paulo", 5, "Caminhão-pipa");
        equipe.setId(1L);
    }

    @Test
    void deveRegistrarOcorrencia() {
        // Given
        when(ocorrenciaRepository.save(any(Ocorrencia.class))).thenReturn(ocorrencia);
        doNothing().when(notificacaoService).enviarAlertas(any(Ocorrencia.class));

        // When
        Ocorrencia resultado = ocorrenciaService.registrar(ocorrencia);

        // Then
        assertNotNull(resultado);
        assertEquals("ABERTA", resultado.getStatus());
        assertNotNull(resultado.getDataHora());
        verify(ocorrenciaRepository).save(ocorrencia);
        verify(notificacaoService).enviarAlertas(ocorrencia);
    }

    @Test
    void deveListarTodasOcorrencias() {
        // Given
        List<Ocorrencia> ocorrencias = Arrays.asList(ocorrencia);
        when(ocorrenciaRepository.findAll()).thenReturn(ocorrencias);

        // When
        List<Ocorrencia> resultado = ocorrenciaService.listarTodas();

        // Then
        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals(ocorrencia.getId(), resultado.get(0).getId());
        verify(ocorrenciaRepository).findAll();
    }

    @Test
    void deveBuscarOcorrenciaPorId() {
        // Given
        when(ocorrenciaRepository.findById(1L)).thenReturn(Optional.of(ocorrencia));

        // When
        Optional<Ocorrencia> resultado = ocorrenciaService.buscarPorId(1L);

        // Then
        assertTrue(resultado.isPresent());
        assertEquals(ocorrencia.getId(), resultado.get().getId());
        verify(ocorrenciaRepository).findById(1L);
    }

    @Test
    void deveAtribuirEquipeAOcorrencia() {
        // Given
        when(ocorrenciaRepository.findById(1L)).thenReturn(Optional.of(ocorrencia));
        when(equipeRepository.findById(1L)).thenReturn(Optional.of(equipe));
        when(ocorrenciaRepository.save(any(Ocorrencia.class))).thenReturn(ocorrencia);
        when(equipeRepository.save(any(EquipeCombate.class))).thenReturn(equipe);

        // When
        Ocorrencia resultado = ocorrenciaService.atribuirEquipe(1L, 1L);

        // Then
        assertNotNull(resultado);
        assertEquals("EM_ATENDIMENTO", resultado.getStatus());
        assertEquals(equipe, resultado.getEquipeResponsavel());
        assertEquals("EM_ACAO", equipe.getStatus());
        verify(ocorrenciaRepository).save(ocorrencia);
        verify(equipeRepository).save(equipe);
    }

    @Test
    void deveFinalizarOcorrencia() {
        // Given
        ocorrencia.setEquipeResponsavel(equipe);
        equipe.setStatus("EM_ACAO");
        when(ocorrenciaRepository.findById(1L)).thenReturn(Optional.of(ocorrencia));
        when(ocorrenciaRepository.save(any(Ocorrencia.class))).thenReturn(ocorrencia);
        when(equipeRepository.save(any(EquipeCombate.class))).thenReturn(equipe);

        // When
        Ocorrencia resultado = ocorrenciaService.finalizarOcorrencia(1L);

        // Then
        assertNotNull(resultado);
        assertEquals("FINALIZADA", resultado.getStatus());
        assertEquals("DISPONIVEL", equipe.getStatus());
        verify(ocorrenciaRepository).save(ocorrencia);
        verify(equipeRepository).save(equipe);
    }

    @Test
    void deveLancarExcecaoQuandoOcorrenciaNaoEncontrada() {
        // Given
        when(ocorrenciaRepository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            ocorrenciaService.finalizarOcorrencia(999L);
        });

        assertEquals("Ocorrência não encontrada", exception.getMessage());
        verify(ocorrenciaRepository).findById(999L);
        verify(ocorrenciaRepository, never()).save(any());
    }

    @Test
    void deveBuscarOcorrenciasPorPrioridade() {
        // Given
        List<Ocorrencia> ocorrencias = Arrays.asList(ocorrencia);
        when(ocorrenciaRepository.findOcorrenciasAbertasPorPrioridade()).thenReturn(ocorrencias);

        // When
        List<Ocorrencia> resultado = ocorrenciaService.buscarPorPrioridade();

        // Then
        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(ocorrenciaRepository).findOcorrenciasAbertasPorPrioridade();
    }

    @Test
    void deveBuscarOcorrenciasRecentes() {
        // Given
        List<Ocorrencia> ocorrencias = Arrays.asList(ocorrencia);
        when(ocorrenciaRepository.findByCidadeIdAndDataHoraAfter(anyLong(), any(LocalDateTime.class)))
            .thenReturn(ocorrencias);

        // When
        List<Ocorrencia> resultado = ocorrenciaService.buscarRecentes(1L);

        // Then
        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(ocorrenciaRepository).findByCidadeIdAndDataHoraAfter(anyLong(), any(LocalDateTime.class));
    }
}