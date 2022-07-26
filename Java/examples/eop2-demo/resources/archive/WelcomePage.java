/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * @author tchen
 *
 * Jun 25, 2022
 */
package archive;

import io.undertow.Undertow;
import io.undertow.server.ListenerRegistry.Listener;
import io.undertow.server.handlers.resource.ClassPathResourceManager;
import io.undertow.servlet.Servlets;
import io.undertow.servlet.api.DeploymentInfo;
import io.undertow.servlet.api.FilterInfo;
import io.undertow.util.Headers;

import static io.undertow.Handlers.path;
import static io.undertow.Handlers.resource;

public class WelcomePage {
    
    public static void mainX(String[] args) {
        Undertow server = Undertow.builder()
                // Set up the listener - you can change the port/host here
                // 0.0.0.0 means "listen on ALL available addresses"
                .addHttpListener(8080, "0.0.0.0")

                .setHandler(exchange -> {
                    // Sets the return Content-Type to text/html
                    exchange.getResponseHeaders()
                            .put(Headers.CONTENT_TYPE, "text/html");

                    // Returns a hard-coded HTML document
                    exchange.getResponseSender()
                            .send("<html>" +
                                    "<body>" +
                                    "<h1>Hello, world!</h1>" +
                                    "</body>" +
                                    "</html>");
                }).build();

        // Boot the web server
        server.start();
    }
    
    public static void mainY(String[] args) {

        Undertow server = Undertow.builder()
                .addHttpListener(8080, "localhost")
                .setHandler(exchange -> {
                    exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                    exchange.getResponseSender().send("Hello there");
                }).build();

        server.start();
    }

    public static void main(String[] args) {
        Undertow server = Undertow.builder()
                .addHttpListener(8080, "localhost")
                .setHandler(path().addPrefixPath("/",
                        resource(new ClassPathResourceManager(
                                    WelcomePage.class.getClassLoader()))
                                .addWelcomeFiles("index.html")))
                .build();

        server.start();
    }
}
