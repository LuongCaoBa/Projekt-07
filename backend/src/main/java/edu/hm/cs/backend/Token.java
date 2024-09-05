package edu.hm.cs.backend;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

import java.util.Objects;

@Entity
class Token {

    private @Id @GeneratedValue Long token;

    private Long userId;

    private Long expirationDate;

    public Token() {
    }

    public Token(Long userId) {
        this.userId = userId;
        expirationDate = System.currentTimeMillis() + 1000 * 60 * 60 * 2;
    }

    public Long getToken() {
        return token;
    }

    public Long getUserId() {
        return userId;
    }

    public Long getExpirationDate() {
        return expirationDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Token)) return false;
        Token token1 = (Token) o;
        return Objects.equals(token, token1.token);
    }

    @Override
    public int hashCode() {
        return Objects.hash(token);
    }


}
