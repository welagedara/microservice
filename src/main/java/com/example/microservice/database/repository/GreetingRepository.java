package com.example.microservice.database.repository;

import com.example.microservice.database.entity.Greeting;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GreetingRepository extends JpaRepository<Greeting, Integer> {
}
