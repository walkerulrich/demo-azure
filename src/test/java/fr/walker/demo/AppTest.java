package fr.walker.demo;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest(properties = "management.tracing.enabled=false")
@AutoConfigureMockMvc
class AppTest {

    @Autowired
    MockMvc mvc;

    @Test
    void helloRepondAvecLeNom() throws Exception {
        mvc.perform(get("/hello").param("name", "Walker"))
           .andExpect(status().isOk())
           .andExpect(content().string("Hello Walker"));
    }

    @Test
    void erreurSimuleeRepond500() throws Exception {
        mvc.perform(get("/api/error")).andExpect(status().isInternalServerError());
    }
}