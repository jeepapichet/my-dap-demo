package com.cyberarkdemo.app;
import net.conjur.api.*;

/**
 * Hello world!
 *
 */
public class App 
{

    private static String DEFAULT_VARIABLE_ID = "javaapp/database_password";

    public static void main( String[] args )
    {
        System.out.println( "Hello World 123!" );

	System.out.println("---Environment Variable---");
        System.out.println("CONJUR_APPLIANCE_URL: " + System.getenv("CONJUR_APPLIANCE_URL"));
        System.out.println("CONJUR_ACCOUNT: " + System.getenv("CONJUR_ACCOUNT"));
        System.out.println("CONJUR_AUTHN_LOGIN: " + System.getenv("CONJUR_AUTHN_LOGIN"));
        System.out.println("CONJUR_AUTHN_API_KEY: " + System.getenv("CONJUR_AUTHN_API_KEY"));
        System.out.println("VARIABLE_ID: " + System.getenv("VARIABLE_ID"));

	System.out.println("\n---Java System Properties---");
        System.out.println("CONJUR_APPLIANCE_URL: " + System.getProperty("CONJUR_APPLIANCE_URL"));
        System.out.println("CONJUR_ACCOUNT: " + System.getProperty("CONJUR_ACCOUNT"));
        System.out.println("CONJUR_AUTHN_LOGIN: " + System.getProperty("CONJUR_AUTHN_LOGIN"));
        System.out.println("CONJUR_AUTHN_API_KEY: " + System.getProperty("CONJUR_AUTHN_API_KEY"));
        System.out.println("VARIABLE_ID: " + System.getProperty("VARIABLE_ID"));

//        String applianceUrl = System.getProperty("CONJUR_APPLIANCE_URL");
//        String login = System.getProperty("CONJUR_AUTHN_LOGIN");
//        String password = System.getProperty("CONJUR_AUTHN_API_KEY");
        String variable_id = (System.getProperty("VARIABLE_ID") != null) ? System.getProperty("VARIABLE_ID") : DEFAULT_VARIABLE_ID;

        System.out.println("Initialize Conjur Java API");

        Conjur conjur = new Conjur();
/* v4
 *         Endpoints endpoints = Endpoints.getApplianceEndpoints(applianceUrl);
 *                 Conjur conjur = new Conjur(login, password, endpoints);
 *                 */
        System.out.println( "Hello World!");
        System.out.println("Conjur Login OK");
        String retrievedSecret = conjur.variables().retrieveSecret(variable_id);
        System.out.println( variable_id + " = " + retrievedSecret);

    }
}
