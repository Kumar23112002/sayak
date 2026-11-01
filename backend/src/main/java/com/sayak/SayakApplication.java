package com.sayak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SayakApplication {

    public static void main(String[] args) {
        SpringApplication.run(SayakApplication.class, args);
        System.out.println("=================================================");
        System.out.println(" Sayak Groceries Spring Boot Backend is Running! ");
        System.out.println(" API Port: http://localhost:8080/api/auth        ");
        System.out.println("=================================================");
    }
}
