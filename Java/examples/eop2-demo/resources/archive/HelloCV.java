/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * @author tchen
 *
 * Jun 22, 2022
 */
package archive;

import org.opencv.core.*;
import org.opencv.imgcodecs.*; 
import org.opencv.videoio.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.highgui.HighGui;

import com.peratonlabs.closure.eop2.transcoder.*;

import javax.swing.*;




public class HelloCV
{
//    public static void mainX(String[] args) {
//        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
//        Mat mat = Mat.eye(3, 3, CvType.CV_8UC1);
//        System.out.println("mat = " + mat.dump());
//    }

//    public static void mainY(String[] args) {
//
//        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
//
//        var srcImage = Imgcodecs.imread("/home/tchen/duke.png", Imgcodecs.IMREAD_UNCHANGED);
//
//        List<Mat> channels = new ArrayList<>();
//        Core.split(srcImage, channels);
//        var chAlpha = channels.get(3); // 4th channel = Alpha
//
//        Imgproc.cvtColor(srcImage, srcImage, Imgproc.COLOR_BGRA2GRAY);
//
//        List<Mat> greyChannel = new ArrayList<>();
//        Core.split(srcImage, greyChannel);
//        var chGray = greyChannel.get(0);
//
//        Mat grayDuke = new Mat();
//        var listMat = Arrays.asList(chGray, chGray, chGray, chAlpha); // 3
//                                                                      // channels
//                                                                      // + Alpha
//        Core.merge(listMat, grayDuke);
//
//        Imgcodecs.imwrite("duke_gray.png", grayDuke);
//
//    }

    public static void main(String[] args) {
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        
        // Instantiating the VideoCapture class (camera:: 0)
//        VideoCapture capture = new VideoCapture(0);
        
        FrameStream fs = new FrameStream();
//        fs.setGrayScale(true);
//        fs.addBlur(true);
        fs.scaleImages(10);
//        fs.setRes_480p();
        while (true) {
        	Mat frame;
        	frame = fs.getNextFrame();
        	HighGui.imshow("Image", frame);
        	HighGui.waitKey();
        }
        
        // Reading the next video frame from the camera
//        while (true) {
//            Mat mat = new Mat();
//            capture.read(mat);
//
//            long imgSize = mat.total() * mat.elemSize();
//
//            byte[] bytes = new byte[(int) imgSize];
//            mat.get(0,0,bytes);
//            // now somehow save mat.type(), mat.rows(), mat.cols() and the bytes, later restore it:
//            Mat m2 = new Mat(mat.rows(), mat.cols(), mat.type());
//            m2.put(0,0, bytes);
////            imshow("Display",mat);
//
////            System.out.println("image size : " + imgSize + " rows: " + mat.rows() + " cols: " + mat.cols() + " :" + mat.type());
////            System.out.println(mat.toString());
//
//            HighGui.imshow("Image", mat);
//            HighGui.waitKey();
//        }
    }
}
