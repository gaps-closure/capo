package com.peratonlabs.closure.eop2.level.normal;

import java.io.BufferedReader;
import java.io.IOException;

import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.peratonlabs.closure.eop2.video.requester.Request;

import javax.servlet.annotation.ServletSecurity;
import javax.servlet.annotation.WebInitParam;

@SuppressWarnings("serial")
@WebServlet(
    name = "AnnotatedServlet", 
    description = "An annotated servlet", 
    urlPatterns = { "/request" }, 
    initParams = { 
        @WebInitParam(name = "level", value = "normal") 
    }
)
@ServletSecurity()
public class VideoServletNormal extends HttpServlet 
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter writer = response.getWriter();
        writer.println("<html>Got it!</html>");
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

        System.out.println("Normal: " + jb.toString());
        Request req = Request.fromJson(jb.toString());
        
        VideoRequesterNormal.handleRequest(req);
        
        PrintWriter writer = response.getWriter();
        writer.println("<html>OK</html>");
        writer.flush();
    }
}