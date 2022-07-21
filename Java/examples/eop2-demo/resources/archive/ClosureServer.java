/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * Jun 26, 2022
 */
package archive;

import io.undertow.Handlers;
import io.undertow.Undertow;
import io.undertow.server.HttpHandler;
import io.undertow.server.RoutingHandler;
import io.undertow.server.handlers.PathHandler;
import io.undertow.server.handlers.resource.ClassPathResourceManager;
import static io.undertow.Handlers.path;
import static io.undertow.Handlers.resource;

import com.peratonlabs.closure.eop2.VideoServer;
import com.peratonlabs.closure.eop2.video.manager.VideoManager;
import com.peratonlabs.closure.eop2.video.requester.VideoRequester;

public class ClosureServer 
{
    private HttpHandler handler = new PathHandler()
//            .addPrefixPath("/video", WebSocketServer.createWebSocketHandler())
            .addPrefixPath("/", resource(new ClassPathResourceManager(ClosureServer.class.getClassLoader()))
                                        .addWelcomeFiles("index.html"))
            
            .addPrefixPath("/about", RoutingHandlers.plainTextHandler("GET - about"))
            .addPrefixPath("/controller", Handlers.routing()
                    .post("/{id}", exchange -> {
                        String id = exchange.getQueryParameters().get("id").getFirst();
                        System.out.println("############ " + id);
                    })
                    )
            .addPrefixPath("/request", Handlers.routing()
                    .post("/{request}", VideoServer.createRequest())
                    )
            // REST API path
            .addPrefixPath("/api", Handlers.routing()
                .get("/customers", exchange -> {System.out.println("customers");})
                .delete("/customers/{customerId}", exchange -> {System.out.println("delete");})
                .setFallbackHandler(exchange -> {System.out.println("fallback");}))

            // Redirect root path to /static to serve the index.html by default
//            .addExactPath("/", Handlers.redirect("/static"))

            // Serve all static files from a folder
//            .addPrefixPath("/static", new ResourceHandler(
//                new PathResourceManager(Paths.get("/path/to/www/"), 100))
//                .setWelcomeFiles("index.html"))                        
    ;
    
    public static void main(final String[] args) {
        ClosureServer closure = new ClosureServer();
        
        Undertow server = Undertow.builder()
                .addHttpListener(8080, "localhost")
                .setHandler(closure.handler)
                .build();
        server.start();
    }

}
