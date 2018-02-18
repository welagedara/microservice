package com.example.microservice.database.entity;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "greeting")
public class Greeting {

    @Id
    @GeneratedValue
    @Column(name = "id")
    private int id;

    @Column(name = "message")
    @NotNull
    private String message;

    public Greeting() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
