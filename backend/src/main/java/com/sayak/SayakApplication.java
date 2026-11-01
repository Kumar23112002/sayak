package com.sayak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

@SpringBootApplication
public class SayakApplication {

    public static void main(String[] args) {
        loadDotEnv();
        SpringApplication.run(SayakApplication.class, args);
        System.out.println("=================================================");
        System.out.println(" Sayak Groceries Spring Boot Backend is Running! ");
        System.out.println(" API Port: http://localhost:8080/api/auth        ");
        System.out.println("=================================================");
    }

    /**
     * Automatically loads .env file into Java System Properties if present.
     * Searches current directory, backend/.env, and parent directory.
     */
    private static void loadDotEnv() {
        String[] candidates = {".env", "backend/.env", "../.env"};
        File envFile = null;
        for (String path : candidates) {
            File f = new File(path);
            if (f.exists() && f.isFile()) {
                envFile = f;
                break;
            }
        }

        if (envFile != null) {
            System.out.println("[Sayak] Loading configuration from: " + envFile.getAbsolutePath());
            try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    int eqIndex = line.indexOf('=');
                    if (eqIndex > 0) {
                        String key = line.substring(0, eqIndex).trim();
                        String val = line.substring(eqIndex + 1).trim();
                        if ((val.startsWith("\"") && val.endsWith("\"")) ||
                            (val.startsWith("'") && val.endsWith("'"))) {
                            val = val.substring(1, val.length() - 1);
                        }
                        // Only set if not already present in OS environment or system properties
                        if (System.getProperty(key) == null && System.getenv(key) == null) {
                            System.setProperty(key, val);
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("[Sayak] Error reading .env file: " + e.getMessage());
            }
        } else {
            System.out.println("[Sayak] No .env file found; using system environment variables or defaults.");
        }
    }
}
