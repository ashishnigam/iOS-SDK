//
//  WeemoData.h
//  iOS-SDK
//
//  Created by Charles Thierry on 7/16/13.
//  Copyright (c) 2013 Weemo. All rights reserved.
//


/**
 *\brief This structure is to be used by the host app to get a few statistics about the connection and the related call's status. Note: these data are for information purposes only.
 */
typedef struct
{
	uint8_t  LocalCPU; //< the local CPU time usage
	uint32_t NetworkLatency; //< the round-trip time to the platform we are connected to.
	
	uint32_t Audio_SentIPThroughput; //< throughput related to the outgoing audio
	uint32_t Audio_ReceivedIPThroughput; //< throughput related to the incoming audio
	uint32_t Audio_SentPcktLoss; //< Outgoing Audio packet loss
	uint32_t Audio_ReceivedPcktLoss; //< Incoming Audio packet loss
	
	uint32_t Video_SentIPThroughput; //< network throughput related to the outgoing video
	uint32_t Video_ReceivedIPThroughput; //< throughput related to the incoming video
	float	 Video_RealSentRate; //< Capture framerate
	float	 Video_ReceivedRate; //< Incoming video receive rate
	uint32_t Video_SentPcktLoss; //< Outgoing Video packet loss
	uint32_t Video_ReceivedPcktLoss; //< Incoming Video packet loss
	uint16_t Video_ReceivedJitter; //< Incoming Video Jitter
	uint16_t Video_SendWidth; //< Width of the outgoing video (in px)
	uint16_t Video_SendHeight; //< Height of the outgoing video (in px)
	uint16_t Video_ReceivedWidth; //< Height of the incoming video (in px)
	uint16_t Video_ReceivedHeight; //< Height of the outgoing video (in px)
	char	 pfm[8]; //< The platform name
} WeemoStat;


#pragma mark - CallStatus

#define CALLSTATUS_INCOMING 				0x7110
#define CALLSTATUS_RINGING 					0x7120
#define CALLSTATUS_ACTIVE 					0x7130
#define CALLSTATUS_ENDED 					0x7140
#define CALLSTATUS_PROCEEDING 				0x7150
#define CALLSTATUS_PAUSED 					0x7160
#define CALLSTATUS_USERNOTAVAILABLE			0x7170

#pragma mark - Error codes

#define ERROR_SIPNOK	0x0030				//< Server error
#define ERROR_SIPNOK1	ERROR_SIPNOK|1		//< Server connection lost

#define ERROR_INIT		0x0010				//< Error while initializing the Weemo

#define ERROR_CLOSE		0x0020
#define ERROR_CLOSE1	ERROR_CLOSE|1		//< Media Layer closing error
#define ERROR_CLOSE2	ERROR_CLOSE|2		//< Network disconnection error
#define ERROR_CLOSE3	ERROR_CLOSE|3		//< Network closing error

