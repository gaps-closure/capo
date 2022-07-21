package com.peratonlabs.closure.eop2.transcoder;

import org.opencv.core.*;
import org.opencv.imgcodecs.*; 
import org.opencv.videoio.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.highgui.HighGui;
import java.lang.Thread;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class FrameStream {

	private VideoCapture capture;
	private Integer frameRate;
	private long delay;
	private boolean isGrayScale;
	private boolean addBlur;
	private boolean scaleImage;
	private Integer imageScale;
	
	public FrameStream()
	{
		capture = new VideoCapture(0);
		frameRate = 60;
		// Delay is in milliseconds 
		delay = (1/frameRate) * 1000; 
		isGrayScale = false;
		addBlur = false;
		scaleImage = false;
		imageScale = 100;
	}
	
	public FrameStream(Integer rate)
	{
		capture = new VideoCapture(0);
		frameRate = rate;
		// Delay is in milliseconds 
		delay = (1/frameRate) * 1000; 
		isGrayScale = false;
		addBlur = false;
		scaleImage = false;
		imageScale = 100;
	}
        
    public Mat getNextFrame()
    {
    	// Do not send back a frame until delay has passed (sets a frame rate)
    	try {
    		Thread.sleep(delay);
    	}
    	catch (Exception e) {
    		System.out.println(e);
    	}

    	  Mat mat = new Mat();
          capture.read(mat);
          if (isGrayScale)
		  {
        	  mat = convertGrayScale(mat);
		  }
          
          if (addBlur)
          {
        	  mat = addBlur(mat);
          }
          
          if (scaleImage)
          {
        	  mat = changeImageScale(mat);
          }
          return mat;
    }
    
    public void setFrameRate(Integer newRate)
    {
    	frameRate = newRate;
    }
	
    
    public void setGrayScale(Boolean flag)
    {
    	isGrayScale = flag;
    }
    
    public void addBlur(Boolean flag)
    {
    	addBlur = flag;
    }
    
    public void disableImageScaling(Boolean flag)
    {
    	scaleImage = false;
    }
    
    public void scaleImages(Integer percent)
    {
    	scaleImage = true;
    	imageScale = percent;
    }
    
    public void setRes_1080p()
    {
    	capture.set(3, 1920);
    	capture.set(4, 1080);
    }
    
    public void setRes_720p()
    {
    	capture.set(3, 1280);
    	capture.set(4, 720);
    }
    
    public void setRes_480p()
    {
    	capture.set(3, 640);
    	capture.set(4, 480);
    }
    
    public void setRes(Integer height, Integer width)
    {
    	capture.set(3, width);
    	capture.set(4, height);
    }
    
    
    private Mat changeImageScale(Mat frame)
    {
    	Integer width = (int) frame.size().width;
    	Integer height = (int) frame.size().height;
    	Integer newWidth = (int)(width * imageScale/ 100);
    	Integer newHeight = (int)(height * imageScale/ 100);
    	
    	Size newSz = new Size(newWidth,newHeight);
    	Imgproc.resize(frame, frame, newSz);
    	
    	Size sz = new Size(width,height);
    	Imgproc.resize(frame, frame, sz);
    	return frame;
    }
    
    private Mat convertGrayScale(Mat frame)
    {
    	Mat grayMat = new Mat();
    	Imgproc.cvtColor(frame, grayMat, Imgproc.COLOR_RGB2GRAY);
	    return grayMat;
    }
    
    
    private Mat addBlur(Mat frame)
    {
    	Size size = new Size(45, 45);
        Point point = new Point(20, 30);
    	Imgproc.blur(frame, frame, size, point, Core.BORDER_DEFAULT);
    	return frame;
    }
}
