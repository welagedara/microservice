package com.example.microservice.controller;

import com.example.microservice.Dto.MessageDto;
import com.example.microservice.service.SampleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

    @Autowired
    private SampleService sampleService;

    @GetMapping("/hello")
    public ResponseEntity<MessageDto> sayHello() {
        return new ResponseEntity<MessageDto>(sampleService.sayHello(), HttpStatus.OK);
    }


}
