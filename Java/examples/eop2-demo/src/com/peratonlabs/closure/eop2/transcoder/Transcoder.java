package com.peratonlabs.closure.eop2.transcoder;

import org.opencv.core.*;

import com.peratonlabs.closure.eop2.level.high.VideoRequesterHigh;
import com.peratonlabs.closure.eop2.level.normal.VideoRequesterNormal;
import com.peratonlabs.closure.eop2.video.requester.Request;
import com.peratonlabs.closure.eop2.video.requester.RequestHigh;
import com.peratonlabs.closure.annotations.*;

import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.util.concurrent.LinkedBlockingQueue;

public class Transcoder implements Runnable
{
    private static final int MAX_NORMAL_SCALE = 75;
    
    private Request request;
    private RequestHigh requestHigh;
    private Thread worker;

    
    private LinkedBlockingQueue<Mat> queue = new LinkedBlockingQueue<Mat>();
    
    @PurpleShareable
    private Mat currFrame;
    private boolean high;

    // when partitioned, HalZmq will catch the interrupt and fail to exit run()
    private boolean interrupted = false;   

    
    public Transcoder(boolean high, String id) {
        this.high = high;
        this.request = new Request(id);
        this.requestHigh = new RequestHigh(id);
        
        System.out.println(high);
        if (!high)
            request.setScalePercentage(MAX_NORMAL_SCALE);
    }
    
    private boolean show(Mat mat) {
        Mat mmm = mat.clone();
        if (!request.isColor())
            mmm = convertGrayScale(mmm);
        
        if (request.isBlur())
            mmm = addBlur(mmm, false);
        
        if (request.isScale()) {
            if (request.getScalePercentage() > MAX_NORMAL_SCALE) {
                request.setScalePercentage(MAX_NORMAL_SCALE);
            }
            mmm = changeImageScale(mmm, request);
        }
        else if (!high) {
            if (request.getScalePercentage() >= MAX_NORMAL_SCALE) {
                request.setScalePercentage(MAX_NORMAL_SCALE);
                mmm = changeImageScale(mmm, request);
            }
        }
        
        MatOfByte mem = new MatOfByte();
        Imgcodecs.imencode(".jpg", mmm, mem);
        byte[] memBytes = mem.toArray();

        VideoRequesterNormal.send(request.getId(), memBytes);
        
        if (request.getDelay() > 0) {
            try {
                Thread.sleep(request.getDelay());
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return true;
    }

    private boolean showHigh(Mat mat) {
        Mat mmm = mat.clone();
        if (!requestHigh.isColor())
            mmm = convertGrayScale(mmm);
        
        if (requestHigh.isBlur())
            mmm = addBlur(mmm, false);
        
        if (request.isScale()) {
            if (requestHigh.getScalePercentage() > MAX_NORMAL_SCALE) {
                requestHigh.setScalePercentage(MAX_NORMAL_SCALE);
            }
            mmm = changeImageScaleHigh(mmm, requestHigh);
        }

        MatOfByte mem = new MatOfByte();
        Imgcodecs.imencode(".jpg", mmm, mem);
        byte[] memBytes = mem.toArray();

        VideoRequesterHigh.send(requestHigh.getId(), memBytes);
   
        
        if (request.getDelay() > 0) {
            try {
                Thread.sleep(request.getDelay());
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return true;
    }
    
    private Mat changeImageScale(Mat frame, Request request) {
        double scale = request.getScalePercentage() / (double) 100;
        Imgproc.resize(frame, frame, new Size(0, 0), scale, scale, Imgproc.INTER_AREA);

        return frame;
    }

    private Mat changeImageScaleHigh(Mat frame, RequestHigh request) {
        double scale = request.getScalePercentage() / (double) 100;
        Imgproc.resize(frame, frame, new Size(0, 0), scale, scale, Imgproc.INTER_AREA);

        return frame;
    }
    
    private Mat convertGrayScale(Mat frame) {
        Mat grayMat = new Mat();
        Imgproc.cvtColor(frame, grayMat, Imgproc.COLOR_RGB2GRAY);
        return grayMat;
    }

    private Mat addBlur(Mat frame, boolean whole) {
        if (whole) {
            Size size = new Size(45, 45);
            Point point = new Point(20, 30);
            Imgproc.blur(frame, frame, size, point, Core.BORDER_DEFAULT);
        }
        else {
            // drawing a rectangle
            Point point1 = new Point(100, 100);
            Point point2 = new Point(500, 300);
            Scalar color = new Scalar(0, 255, 0);
            int thickness = 1;
            Imgproc.rectangle (frame, point1, point2, color, thickness);

            Rect rect = new Rect(point1, point2);
            Mat mask = frame.submat(rect);
            Imgproc.GaussianBlur(mask, mask, new Size(55, 55), 55); // or any other processing
        }
        
        return frame;
    }
    
    public void interrupt() {
        worker.interrupt();
        interrupted = true;
    }
    
    public void start() {
        worker = new Thread(this);
        worker.start();
    }
 
    @Override
    public void run() {
        while (true) {
            try {
                currFrame = queue.take();
                if (interrupted)
                    break;
                if (high)
                {
                    if (!showHigh(currFrame))
                        break;
                }
                else
                {
                    if (!show(currFrame))
                        break;
                }
                
            }
            catch (InterruptedException e) {
                break;
            }
        }
        System.out.println("transcoder interrupted.......");
    }
    
    public void add(Mat mat) {
        queue.add(mat);
    }

    public Request getRequest() {
        return request;
    }

    public RequestHigh getRequestHigh() {
        return requestHigh;
    }

    public void setRequest(Request request) {
        this.request = request;
    }


    public void setRequestHigh(RequestHigh request) {
        this.requestHigh = request;
    }
}

//long imgSize = mat.total() * mat.elemSize();
//
//byte[] bytes = new byte[(int) imgSize];
//mat.get(0, 0, bytes);

//          Mat m2 = new Mat(mat.rows(), mat.cols(), mat.type());
//          m2.put(0,0, bytes);
