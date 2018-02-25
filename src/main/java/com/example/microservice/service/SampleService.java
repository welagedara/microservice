package com.example.microservice.service;

import com.example.microservice.Dto.MessageDto;
import com.example.microservice.database.entity.Greeting;
import com.example.microservice.database.repository.GreetingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Random;

@Service
public class SampleService {

    @Autowired
    private GreetingRepository greetingRepository;

    public MessageDto sayHello() {
        return new MessageDto("this works");
//        List<Greeting> greetings = greetingRepository.findAll();
//
//        // Pick a random greeting
//        Random random = new Random();
//        return new MessageDto(greetings.get(random.nextInt(greetings.size())).getMessage());
    }
}
