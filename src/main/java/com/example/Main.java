package com.example;

import java.io.InputStream;
import java.util.Properties;

public class Main {

    public static void main(String[] args) {
        try {
            // Load the properties file
            InputStream input = Main.class.getClassLoader().getResourceAsStream("application.properties");
            if (input == null) {
                System.out.println("Sorry, unable to find application.properties");
                return;
            }

            // Load the properties from the file
            Properties properties = new Properties();
            properties.load(input);

            // Read properties
            String appName = properties.getProperty("app.name");
            String dbUrl = properties.getProperty("db.url");
            String env = properties.getProperty("env");

            System.out.println("Hola, Senores!");

            // Print the values to check if they are loaded correctly
            System.out.println("App Name: " + appName);
            System.out.println("DB URL: " + dbUrl);
            System.out.println("Environment: " + env);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
