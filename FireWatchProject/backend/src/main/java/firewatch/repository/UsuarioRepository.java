package firewatch.repository;

import firewatch.domain.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    List<Usuario> findByCidadeId(Long cidadeId);
    Optional<Usuario> findByTelefone(String telefone);
    Optional<Usuario> findByEmail(String email);
    List<Usuario> findByTipoUsuario(String tipoUsuario);
}
