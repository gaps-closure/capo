import numpy as np
import cv2

#src = 'rtsp://admin:Boosters@10.139.80.245'
src = 'rtsp://admin:Boosters@192.168.0.203'
cap = cv2.VideoCapture(src)

while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    frame = cv2.resize(frame, (960, 540))
    # Our operations on the frame come here
    #    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Display the resulting frame
    cv2.imshow('frame',frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture

cap.release()

cv2.destroyAllWindows()
