#include "cameractl.h"
#include "klvparser.h"

#include "OrionPublicPacket.h"
#include "OrionComm.h"
#include "Constants.h"
#include "fielddecode.h"
#include "earthposition.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <arpa/inet.h>
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavutil/mathematics.h"
#include "libavutil/opt.h"
#include "libavutil/rational.h"
#include "libavutil/avstring.h"
#include "libavutil/imgutils.h"
#include "libswscale/swscale.h"

#if LIBAVCODEC_VERSION_INT < AV_VERSION_INT(55,28,1)
#error "libavcodec version >= 55.28.1 required"
#endif

// For GEDL heuristics
void outhint(void *from, void *to, int sz) { }

// Incoming and outgoing packet structures. 
#pragma cle begin ORANGE_NOSHARE
OrionPkt_t PktOut;
OrionPkt_t PktIn;
AVFormatContext *pInputContext = NULL;
AVCodecContext  *pDecodeContext = NULL;
AVCodecContext  *pEncodeContext = NULL;
AVFrame *pFrame = NULL;
AVPacket Packet;
AVPacket OutPacket;
int VideoStream = 0;
int DataStream = 0;
#pragma cle end ORANGE_NOSHARE

void stream_close(void) {
  av_frame_free(&pFrame);
  if (pDecodeContext) {
    avcodec_close(pDecodeContext);
    av_free(pDecodeContext);
  }
  if (pEncodeContext) {
    avcodec_close(pEncodeContext);
    av_free(pEncodeContext);
  }
  if (pInputContext) {
    av_read_pause(pInputContext);
    avformat_close_input(&pInputContext);
    avformat_free_context(pInputContext);
  }
  pDecodeContext  = NULL;
  pEncodeContext  = NULL;
  pFrame         = NULL;
  pInputContext = NULL;
}

int cam_close(void) {
  stream_close();
#ifdef ORION_COMM_
  OrionCommClose();
#endif /* ORION_COMM_ */
  return(1);
}

int stream_open(const char *pUrl) {
  AVCodec *pDeCodec;
  AVCodec *pEnCodec;

  avcodec_register_all();
  av_register_all();
  avformat_network_init();
  av_log_set_level(AV_LOG_QUIET);

  pInputContext = avformat_alloc_context();

  // Have avformat_open_input timeout after 5s
  AVDictionary *pOptions = 0;
  av_dict_set(&pOptions, "timeout", "5000000", 0);

  // If the stream doesn't open
  if (avformat_open_input(&pInputContext, pUrl, NULL, &pOptions) < 0) {
    // Clean up the allocated resources (if any...) and exit with a failure code
    stream_close();
    return 0;
  }

  // If there don't appear to be an valid streams in the transport stream
  if (pInputContext->nb_streams == 0) {
    stream_close();
    return 0;
  }

  // Get the stream indices for video and metadata
  VideoStream = av_find_best_stream(pInputContext, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
  DataStream  = av_find_best_stream(pInputContext, AVMEDIA_TYPE_DATA,  -1, -1, NULL, 0);

  // Set the format context to playing
  av_read_play(pInputContext);

  // Get a codec pointer based on the video stream's codec ID and allocate a context
  pDeCodec = avcodec_find_decoder(pInputContext->streams[VideoStream]->codec->codec_id);
  pDecodeContext = avcodec_alloc_context3(pDeCodec);

  // Open the newly allocated decoder codec context
  avcodec_open2(pDecodeContext, pDeCodec, NULL);

  // Get a codec pointer for encoding format and allocate a context
  pEnCodec = avcodec_find_encoder(AV_CODEC_ID_H264);
  pEncodeContext = avcodec_alloc_context3(pEnCodec);

  // Set encoding parameters
  pEncodeContext->bit_rate = 400000;
  pEncodeContext->width = 320;
  pEncodeContext->height = 180;
  pEncodeContext->time_base = (AVRational){1, 25};
  pEncodeContext->framerate = (AVRational){25, 1};
  pEncodeContext->gop_size = 10;
  pEncodeContext->max_b_frames = 1;
  pEncodeContext->pix_fmt = AV_PIX_FMT_YUV420P;
  if (pEnCodec->id == AV_CODEC_ID_H264)
    av_opt_set(pEncodeContext->priv_data, "preset", "slow", 0);

  // Open the newly allocated encoder codec context
  avcodec_open2(pEncodeContext, pEnCodec, NULL);

  // Allocate the decode frame structure
  pFrame = av_frame_alloc();

  // Finally, initialize the AVPacket structure
  av_init_packet(&Packet);
  Packet.data = NULL;
  Packet.size = 0;

  av_init_packet(&OutPacket);
  OutPacket.data = NULL;
  OutPacket.size = 0;

  // Done - return 1 to indicate success
  return 1;
}

int cam_open(char *myaddr, char *camaddr) {
  uint8_t VideoFrame[1280 * 720 * 3] = { 0 };
  OrionNetworkVideo_t Settings;
  char VideoUrl[32] = "";

  // Zero out the video settings packet to set everything to 'no change'
  memset(&Settings, 0, sizeof(Settings));

  // Video port will default to 15004
  Settings.Port = 15004;
  Settings.StreamType = STREAM_TYPE_H264;

  uint8_t Octets[4];
  if (sscanf(myaddr, "%3hhu.%3hhu.%3hhu.%3hhu", &Octets[0], &Octets[1], &Octets[2], &Octets[3])) {
    int Index = 0;
    Settings.DestIp = uint32FromBeBytes(Octets, &Index);
    sprintf(VideoUrl, "udp://%s:%d", myaddr, Settings.Port);
  }

  // Send the network video settings
  encodeOrionNetworkVideoPacketStructure(&PktOut, &Settings);

#ifdef ORION_COMM_
  // If we can't connect to a gimbal, kill the app right now
  if (OrionCommOpenNetworkIp(camaddr) == FALSE) {
    fprintf(stderr, "Closing communications on gimbal connect error\n");
    cam_close();
    return(1);
  }
  OrionCommSend(&PktOut);
#endif /* ORION_COMM_ */

  // If we can't open the video stream
  if (stream_open(VideoUrl) == 0) {
    fprintf(stderr, "Failed to open video at %s\n", VideoUrl);
    cam_close();
    return(1);
  }
  return 0;
}

struct framebuf_st * get_framebuf() {
  static struct framebuf_st wp;
  static int inited = 0;
  if (!inited) { inited  = 1; wp.newf = 0; wp.size = 0; }
  return &wp;
}

struct llat_st * get_mdatabuf() {
  static struct llat_st wp;
  static int inited = 0;
  if (!inited) { inited  = 1; wp.newf = 0; }
  return &wp;
}

#pragma cle begin XDLINKAGE_GET_FRAME
int get_frame(char buf[static MAX_FRAME_BUF]) {
#pragma cle end XDLINKAGE_GET_FRAME
#pragma cle begin ORANGE_SHARE
  int sz;
  struct framebuf_st *wp;
#pragma cle end ORANGE_SHARE
  
  outhint(buf, NULL, MAX_FRAME_BUF); // only a hint for GEDL
  wp = get_framebuf();
  pthread_mutex_lock(&wp->flk);
  if (wp->newf == 1 && wp->size > 0) {
     memcpy(buf, wp->data, wp->size);
     wp->newf = 0;  // mark frame not new 
     sz = wp->size;
  } else {
     sz = 0;
  }
  pthread_mutex_unlock(&wp->flk);
  return sz;
}

#pragma cle begin XDLINKAGE_GET_METADATA
int get_metadata(double *lat, double *lon, double *alt, double *ts) {
#pragma cle end XDLINKAGE_GET_METADATA
#pragma cle begin ORANGE_SHARE
  struct llat_st *wp;
  int ret = 0;
#pragma cle end ORANGE_SHARE

  // only a hint for GEDL
  outhint(lat, NULL, sizeof(double)); 
  outhint(lon, NULL, sizeof(double)); 
  outhint(alt, NULL, sizeof(double)); 
  outhint(ts, NULL, sizeof(double)); 

  wp = get_mdatabuf();
  pthread_mutex_lock(&wp->flk);
  if (wp->newf == 1) {
    *lat = wp->lat;
    *lon = wp->lon;
    *alt = wp->alt;
    *ts  = wp->ts;
    wp->newf = 0;  // mark data not new 
    ret = 1;
  } 
  pthread_mutex_unlock(&wp->flk);
  return ret;
}

void put_frame(AVPacket *pkt) {
  struct framebuf_st *wp;
  wp = get_framebuf();
  pthread_mutex_lock(&wp->flk);
  if (pkt->size <= MAX_FRAME_BUF) {
    memcpy(wp->data, pkt->data, pkt->size);
    wp->size = pkt->size;
    wp->newf = 1;
  }
  else {
    fprintf(stderr, "Compressed frame larger than buffer\n");
    wp->size = 0;
    wp->newf = 0;
  }
  pthread_mutex_unlock(&wp->flk);
}

void put_metadata(double lat, double lon, double alt, double ts) {
  struct llat_st *wp;
  wp = get_mdatabuf();
  pthread_mutex_lock(&wp->flk);
  wp->lat = lat;
  wp->lon = lon;
  wp->alt = alt;
  wp->ts  = ts;
  wp->newf = 1; 
  pthread_mutex_unlock(&wp->flk);
}

void re_encode(AVCodecContext *ectx, AVFrame *frame, AVPacket *pkt) {
  int ret;
  int idx;
  ret = avcodec_send_frame(ectx, frame);
  if (ret < 0) {
    fprintf(stderr, "Error sending a frame for encoding:%s\n",av_err2str(ret));
    return;
  }
  while (ret >= 0) {
    ret = avcodec_receive_packet(ectx, pkt);
    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
      return;
    }
    else if (ret < 0) {
      fprintf(stderr, "Error during encoding:%s\n", av_err2str(ret));
      exit(1);
    }
    // fprintf(stderr, "Write packet %3"PRId64" (size=%5d)\n", pkt->pts, pkt->size);
    put_frame(pkt);
  }
}

void pull_md(char *mbuf, int msz) {
  int Result;
  double lat, lon, alt;
  uint64_t ts;

  // Send the new metadata to the KLV parser
  KlvNewData(mbuf, msz);

  // Grab the gimbal's LLA and TS out of the KLV data
  lat = KlvGetValueDouble(KLV_UAS_SENSOR_LAT, &Result);
  lon = KlvGetValueDouble(KLV_UAS_SENSOR_LON, &Result);
  alt = KlvGetValueDouble(KLV_UAS_SENSOR_MSL, &Result);
  ts  = KlvGetValueUInt(KLV_UAS_TIME_STAMP,   &Result);

  put_metadata(degrees(lat), degrees(lon), alt, (double) ts);
  //fprintf(stderr, "\nImage LLAT: %11.6lf %11.6lf %7.1lf %ld", degrees(lat), degrees(lon), alt, ts);
}

int extract_metadata() {
  static uint8_t *pMetaData = NULL;
  static uint64_t MetaDataBufferSize = 0;
  static uint64_t MetaDataSize = 0;
  static uint64_t MetaDataBytes = 0;

  // If we have a full metadata packet in memory, zero out the size and index
  if (MetaDataBytes == MetaDataSize)
    MetaDataBytes = MetaDataSize = 0;

  // If we don't have any metadata buffered up yet and this packet is big enough for a US key and size
  if ((MetaDataBytes == 0) && (Packet.size > 17)) {
    // UAS LS universal key
    static const uint8_t KlvHeader[16] = {
      0x06, 0x0E, 0x2B, 0x34, 0x02, 0x0B, 0x01, 0x01,
      0x0E, 0x01, 0x03, 0x01, 0x01, 0x00, 0x00, 0x00
    };

    // Try finding the KLV header in this packet
    const uint8_t *pStart = memmem(Packet.data, Packet.size, KlvHeader, 16);
    const uint8_t *pSize = pStart + 16;

    // If we found the header and the size tag is contained in this packet
    if ((pStart != 0) && ((pSize - Packet.data) < Packet.size)) {
      // Initialize the header size to US key + 1 size byte and zero KLV tag bytes
      uint64_t KlvSize = 0, HeaderSize = 17;

      // If the size is a multi-byte BER-OID size
      if (pSize[0] & 0x80) {
        // Get the size of the size (up to )
        int Bytes = pSize[0] & 0x07, i;

        // If the entire size field is contained in this packet
        if (&pSize[Bytes] < &Packet.data[Packet.size]) {
          // Build the size up from the individual bytes
          for (i = 0; i < Bytes; i++)
            KlvSize = (KlvSize << 8) | pSize[i + 1];
         }

         // Add the additional size bytes to the header size
         HeaderSize += Bytes;
      }
      // Otherwise, just read the size byte straight out of byte 16
      else
        KlvSize = pSize[0];

      // If we got a valid local set size
      if (KlvSize > 0) {
        // Compute the maximum bytes to copy out of the packet
        int MaxBytes = Packet.size - (pStart - Packet.data);
        int TotalSize = HeaderSize + KlvSize;
        int BytesToCopy = MIN(MaxBytes, TotalSize);

        // If our local buffer is too small for the incoming data
        if (MetaDataBufferSize < TotalSize) {
          // Reallocate enough space and store the new buffer size
          pMetaData = (uint8_t *)realloc(pMetaData, TotalSize);
          MetaDataBufferSize = TotalSize;
        }

        // Now copy the new data into the start of the local buffer
        memcpy(pMetaData, pStart, BytesToCopy);
        MetaDataSize = TotalSize;
        MetaDataBytes = BytesToCopy;
      }
    }
  }
  // Otherwise, if we're mid-packet
  else if (MetaDataBytes < MetaDataSize) {
    // Figure out the number of bytes to copy out of this particular packet
    int BytesToCopy = MIN(Packet.size, MetaDataSize - MetaDataBytes);

    // Copy into the local buffer in the right spot and increment the index
    memcpy(&pMetaData[MetaDataBytes], Packet.data, BytesToCopy);
    MetaDataBytes += BytesToCopy;
  }

  // There's new metadata if the size is non-zero and equal to the number of bytes read in
  if ((MetaDataSize != 0) && (MetaDataBytes == MetaDataSize) && (pMetaData != 0)) {
    pull_md(pMetaData, MetaDataBytes);
    // save metadata here
    // memcpy(buf, &md, mdsize);
    return 1;
  }
  return 0;
}

int stream_process() {
  // New video/metadata flags - note that NewMetaData == 1 if it's not in the TS
  int NewVideo = 0, NewMetaData = (pInputContext->nb_streams < 2);
  while (av_read_frame(pInputContext, &Packet) >= 0) {
    int Index = Packet.stream_index;
    if (Index == VideoStream) {
      avcodec_decode_video2(pDecodeContext, pFrame, &NewVideo, &Packet);
      if (NewVideo) {
        re_encode(pEncodeContext, pFrame, &OutPacket);
        av_frame_unref(pFrame);
      }
    }
    else if (Index == DataStream) {
      NewMetaData = extract_metadata();
    }
    av_free_packet(&Packet);
    av_free_packet(&OutPacket);
    if (NewVideo && NewMetaData) return 1; 
  }
  return 0; 
}

int wait_for_response() {
  int retries = 0;
#ifdef ORION_COMM_ 
  while (++retries < 20) {
    while (OrionCommReceive(&PktIn)) {
      if (PktIn.ID == ORION_PKT_CMD) return 1;
    }
    usleep(100000); // wait 100ms
  }
#endif /* ORION_COMM_ */
  return 0;
}

#pragma cle begin XDLINKAGE_SEND_CAMCMD
int send_camcmd(double pan, double tilt, double imptime, char mode, char stab) {
#pragma cle end XDLINKAGE_SEND_CAMCMD
#pragma cle begin ORANGE_SHARE
  int ret = 0;
#pragma cle end ORANGE_SHARE
  OrionCmd_t Cmd  = { { 0, 0 } };
  Cmd.Target[0]   = deg2radf(pan);
  Cmd.Target[1]   = deg2radf(tilt);
  Cmd.ImpulseTime = imptime;
  Cmd.Stabilized  = (stab == 1);
  Cmd.Mode        = ORION_MODE_RATE;
  switch (mode) {
    case 'P':
      Cmd.Mode = ORION_MODE_POSITION;
      break;
    case 'D':
      Cmd.Mode = ORION_MODE_DISABLED;
      break;
    case 'F':
      // Note that we use the 'auto' FFC mode. To FFC at a specific location, change this line:
      Cmd.Mode = ORION_MODE_FFC_AUTO;
      break;
    case 'R':
    default:
      Cmd.Mode = ORION_MODE_RATE;
      break;
  };

  encodeOrionCmdPacket(&PktOut, &Cmd);

#ifdef ORION_COMM_ 
  OrionCommSend(&PktOut);
#endif /* ORION_COMM_ */
  ret = wait_for_response();
  return ret;
}

void *process_video(void *arg) {
  char *addrs = (char *)arg;
  while (cam_open(&addrs[0], &addrs[16]) != 0) {
    fprintf(stderr, "Unable to open camera, sleeping for 5 seconds\n");
    sleep(5);
  }
  for(;;) {
    while (stream_process() == 0) continue;
    usleep(5000);
  }
  return NULL;
}

int isValidIPv4(char *ipAddress)
{
    struct sockaddr_in sa;
    return inet_pton(AF_INET, ipAddress, &(sa.sin_addr));
}

#pragma cle begin XDLINKAGE_RUN_VIDEOPROC
int run_videoproc(void) {
#pragma cle end XDLINKAGE_RUN_VIDEOPROC
  static int inited = 0;
  static char arg[32];
  char *myaddr;
  char *camaddr;
#pragma cle begin ORANGE_SHARE
  int ret = 0;
#pragma cle end ORANGE_SHARE

  if(!inited) {
    inited = 1;
    myaddr = getenv("MYADDR");
    camaddr = getenv("CAMADDR");
    if(!myaddr || !camaddr || !isValidIPv4(myaddr) || !isValidIPv4(camaddr)) {
      fprintf(stderr, "Error with environment variables MYADDR and CAMADDR\n");
      ret = -1;
      return ret;
    }

    fprintf(stderr, "Initializing video processing with myaddr %s and camaddr %s\n", myaddr, camaddr);

    strncpy(&arg[0], myaddr, 16);
    strncpy(&arg[16], camaddr, 16);
 
    pthread_t thread_id = (pthread_t) 0;
    pthread_attr_t attr;
    (void) pthread_attr_init(&attr);
    (void) pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&thread_id, &attr, (void *(*) (void *)) process_video, (void *) arg);
    pthread_attr_destroy(&attr);
  }
  return ret;
}

