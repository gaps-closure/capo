package com.peratonlabs.closure.eop2.level.high;

import java.io.BufferedReader;
import java.io.IOException;

import java.io.PrintWriter;
import java.util.Date;
import java.util.Set;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.peratonlabs.closure.eop2.video.requester.Request;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContainerInitializer;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebListener;
import javax.servlet.annotation.ServletSecurity;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.HandlesTypes;

@SuppressWarnings("serial")
@WebServlet(
    name = "AnnotatedServlet", 
    description = "A annotated servlet", 
    urlPatterns = { "/request" }, 
    initParams = { 
        @WebInitParam(name = "level", value = "high") 
    }
)
@ServletSecurity()
public class VideoServletHigh extends HttpServlet 
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter writer = response.getWriter();
        writer.println("<html>OK!</html>");
        writer.flush();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuffer jb = new StringBuffer();
        String line = null;
        try {
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null)
                jb.append(line);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("High: " + jb.toString());
        Request req = Request.fromJson(jb.toString());
        VideoRequesterHigh.handleRequest(req);
        
        PrintWriter writer = response.getWriter();
        writer.println("<html>OK</html>");
        writer.flush();
    }

    @WebFilter(
        urlPatterns = { "/*" }, 
        initParams = {
            @WebInitParam(
                name = "test-param", 
                value = "Initialization Paramter")
        }
    )
    
    public static class LogFilter implements Filter {
        @Override
        public void init(FilterConfig config) throws ServletException {
            // Get init parameter
            String testParam = config.getInitParameter("test-param");

            // Print the init parameter
            System.out.println("Test Param: " + testParam);
        }

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                throws IOException, ServletException {
            // Log the current timestamp.
            System.out.println("Time " + new Date().toString());

            // Pass request back down the filter chain
            chain.doFilter(request, response);
        }

        @Override
        public void destroy() {
            /*
             * Called before the Filter instance is removed from service by the web
             * container
             */
            System.out.println("Filter destroied");
        }
    }

    @WebListener
    public static class ContextListener implements ServletContextListener {
        @Override
        public void contextInitialized(ServletContextEvent event) {
            System.out.println("The application started");
        }

        @Override
        public void contextDestroyed(ServletContextEvent event) {
            System.out.println("The application stopped");
        }
    }

    @HandlesTypes({
        javax.servlet.http.HttpServlet.class,
        javax.servlet.Filter.class
    })
    public static class AppInitializer implements ServletContainerInitializer {
        @Override
        public void onStartup(Set<Class<?>> classes, ServletContext context)
                throws ServletException {
            System.out.println("Classes "+classes+" getting initialized.");
        }
    }
}