package com.xifeng.eagle.config;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class EagleConfigApplication {
    public static void main(String[] args) {
        SpringApplication.run(EagleConfigApplication.class, args);
    }
}
