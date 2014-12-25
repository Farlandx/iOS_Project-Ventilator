//
//  NfcA1Device.h
//  easykeypro
//
//  Created by Jason Tsai on 9/24/12.
//  Copyright (c) 2012 Jason Tsai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>

@protocol NfcA1ProtocolDelegate <NSObject>
@required
- (void) receivedMessage: (SInt32)type
                  Result: (Boolean)result
                    Data: (void *)data;
@end


#define AudioBufferCount        1

#define MESSAGE_GET_BATTERY_VALUE       0
#define MESSAGE_TAG_GET_UID             1
#define MESSAGE_TAG_SET_AB_KEY          2
#define MESSAGE_TAG_CHECK_AB_KEY        3
#define MESSAGE_TAG_WRITE_DATA          4
#define MESSAGE_TAG_READ_DATA           5
#define MESSAGE_TAG_WRITE_SECTOR_DATA   6
#define MESSAGE_TAG_READ_SECTOR_DATA    7

#define MESSAGE_READER_GET_TAG_UID         10
#define MESSAGE_READER_WRITE_TAG_DATA      11
#define MESSAGE_READER_READ_TAG_DATA       12
#define MESSAGE_READER_SET_TAG_AB_KEY      13
#define MESSAGE_READER_CHECK_TAG_AB_KEY         14
#define MESSAGE_READER_WRITE_TAG_SECTOR_DATA    16
#define MESSAGE_READER_READ_TAG_SECTOR_DATA     17

#define MESSAGE_READER_WRITE_ULTRALIGHT    64
#define MESSAGE_READER_READ_ULTRALIGHT     65

#define MESSAGE_READER_WRITE_ULTRALIGHT_1K 54
#define MESSAGE_READER_READ_ULTRALIGHT_1K  55

#define MESSAGE_RUN_IR_DEVICE     69

#define STATUS_FAIL 0xff

typedef struct _MSG_INFORM_DATA
{
    UInt8 data[48];
    UInt16 version;
    UInt8 status;
    UInt8 battery;
}MSG_INFORM_DATA;


@interface NfcA1Device : NSOperation
{
}

@property (nonatomic, retain) id <NfcA1ProtocolDelegate> delegate;



- (Boolean) tagGetUID;
- (Boolean) tagSetABKey:(UInt8 *) aBKey
                BlockNo:(UInt8)no;
- (Boolean) tagCheckABKey:(UInt8 *) aBKey
                  BlockNo:(UInt8)no;
- (Boolean) tagWriteData:(UInt8 *) data
                 BlockNo:(UInt8)no;
- (Boolean) tagReadData:(UInt8)no;
- (Boolean) tagWriteSectorData:(UInt8 *) data
                      SectorNo:(UInt8)no;
- (Boolean) tagReadSectorData:(UInt8)no;


- (Boolean) readerGetTagUID;
- (Boolean) readerWriteTagData:(UInt8 *) data
                       BlockNo:(UInt8)no;
- (Boolean) readerReadTagData:(UInt8)no;
- (Boolean) readerSetTagABKey:(UInt8 *) aBKey
                      BlockNo:(UInt8)no;
- (Boolean) readerCheckTagABKey:(UInt8 *) aBKey
                        BlockNo:(UInt8)no;
- (Boolean) readerWriteTagSectorData:(UInt8 *) data
                            SectorNo:(UInt8)no;
- (Boolean) readerReadTagSectorData:(UInt8)no;


- (Boolean) readerWriteUltralight:(UInt8)pos
                           Length:(UInt8)length
                              UID:(UInt8 *)uid
                             Data:(UInt8 *)data;
- (Boolean) readerReadUltralight:(UInt8)pos
                          Length:(UInt8)length;
- (Boolean) readerWriteUltralight1K:(UInt8)pos
                             Length:(UInt8)length
                                UID:(UInt8 *)uid
                               Data:(UInt8 *)data;
- (Boolean) readerReadUltralight1K:(UInt8)pos
                            Length:(UInt8)length;

- (Boolean) runIrDevice:(SInt16 *)waveformData
         WaveformLength:(SInt32)waveformLength
          SignalInverse:(Boolean)signalInverse
               FreqHigh:(UInt8)freqHigh
                FreqLow:(UInt8)freqLow
             RepeatTime:(UInt8)repeatTime;


- (Boolean) getBatteryStatus;

@end
