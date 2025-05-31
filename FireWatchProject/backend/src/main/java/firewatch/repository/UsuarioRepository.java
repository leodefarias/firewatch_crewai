package com.firewatch.repository;

import com.firewatch.domain.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    List<Usuario> findByCidadeId(Long cidadeId);
}
