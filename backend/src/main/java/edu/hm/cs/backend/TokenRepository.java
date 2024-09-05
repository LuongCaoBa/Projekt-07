package edu.hm.cs.backend;

import org.springframework.data.jpa.repository.JpaRepository;
public interface TokenRepository extends JpaRepository<Token, Long>{
}
