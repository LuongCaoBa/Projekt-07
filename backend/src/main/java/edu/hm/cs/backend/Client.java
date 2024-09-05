package edu.hm.cs.backend;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.*;

import java.util.HashSet;

@Entity
class Client {
    private String username;
    private String password;
    private @Id
    @GeneratedValue Long id;
    private String email;
    private boolean enabeld;
    private int role;

    private String Studiengang;

    private int Semester;

    @ManyToMany(mappedBy = "clients")
    @JsonIgnore
    private Set<Group> groups = new HashSet<>();
    public Client() {
    }
    public Client(String username, String password, String email, boolean enabeld, int role, int semester, String studiengang) {
        this.username = username;
        this.password = password;
        this.email= email;
        this.enabeld = enabeld;
        this.role = role;
        this.Semester = semester;
        this.Studiengang = studiengang;
    }
    public String getUsername() {
        return this.username;
    }
    public String getPassword() {
        return this.password;
    }
    public String getEmail() {
        return this.email;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public void setPassword(String password) {
        this.password= password;
    }
    public void setEmail(String email) {
        this.email= email;
    }
    public Long getId() {
        return this.id;
    }
    public boolean getEnabeld() {
        return this.enabeld;
    }
    public void setEnabeld(boolean enabeld) {

        this.enabeld = enabeld;
    }
    public int getRole() {
        return this.role;
    }
    public void setRole(int role) {
        this.role = role;
    }
    public Set<Group> getGroups() {
        return groups;
    }
    public void setGroups(Set<Group> groups) {
        this.groups = groups;
    }
    public void addToGroup(Group group) {
        this.groups.add(group);
        group.getClients().add(this);
    }
    public void removeFromGroup(Group group) {
        this.groups.remove(group);
        group.getClients().remove(this);
    }
    public String getCombinedUsername() {
        return this.username + "#" + this.id;
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Client client)) return false;
        return Objects.equals(this.id, client.id) && Objects.equals(this.email, client.email);
    }
    @Override
    public int hashCode() {
        return Objects.hash(this.id, this.email);
    }

    public String getStudiengang() {
        return Studiengang;
    }

    public Integer getSemester() {
        return Semester;
    }
}