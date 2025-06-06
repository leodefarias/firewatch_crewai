package firewatch.service;

import firewatch.domain.Cidade;
import firewatch.repository.CidadeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CidadeService {

  @Autowired
  private CidadeRepository cidadeRepository;

  public Cidade cadastrar(Cidade cidade) {
    return cidadeRepository.save(cidade);
  }

  public List<Cidade> listarTodas() {
    return cidadeRepository.findAll();
  }

  public Optional<Cidade> buscarPorId(Long id) {
    return cidadeRepository.findById(id);
  }
  
  public Optional<Cidade> buscarPorNome(String nome) {
    return cidadeRepository.findByNome(nome);
  }
  
  public List<Cidade> buscarPorEstado(String estado) {
    return cidadeRepository.findByEstado(estado);
  }
  
  public Cidade atualizar(Long id, Cidade cidadeAtualizada) {
    Optional<Cidade> cidadeExistente = cidadeRepository.findById(id);
    if (cidadeExistente.isPresent()) {
      Cidade cidade = cidadeExistente.get();
      cidade.setNome(cidadeAtualizada.getNome());
      cidade.setLatitude(cidadeAtualizada.getLatitude());
      cidade.setLongitude(cidadeAtualizada.getLongitude());
      cidade.setEstado(cidadeAtualizada.getEstado());
      return cidadeRepository.save(cidade);
    }
    throw new RuntimeException("Cidade não encontrada");
  }
  
  public void deletar(Long id) {
    cidadeRepository.deleteById(id);
  }
}
