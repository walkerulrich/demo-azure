package fr.walker.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@SpringBootApplication
@RestController
public class App {

    private static final Logger log = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @GetMapping("/hello")
    public String hello(@RequestParam(defaultValue = "Azure") String name) {
        log.info("Requete /hello recue");
        return "Hello " + name;
    }

    // Sert a fabriquer un incident a analyser dans Kibana et Grafana
    @GetMapping("/api/error")
    public String error() {
        log.error("Incident simule : dependance paiement indisponible");
        throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "incident simule");
    }
}