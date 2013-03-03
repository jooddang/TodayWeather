//
//  ClinetConnector.h
//  SocketClient
//
//  Created by 이진호 on 10. 4. 29..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>


@protocol ClientIF

- (void) OnReceive:(NSString*) msg;
- (void) OnDisconnect;
- (void) OnConnected;
- (void) OnError:(NSError*) err;
@end

@interface ClinetConnector : NSObject {

	CFStringRef		host;
	int				port;
	NSInputStream *instream;
//	NSStream*	instream;
	NSOutputStream *outstream;
//	NSStream*	outstream;
	id			rcvif;
}

- (id) initWithIF:(id)aif;
- (void) connect:(NSString*)ip port:(int)remoteport;
- (void)send:(NSString*)msg;
- (void)disconnect;

-(void) OnOpened;
-(void) OnHasRead;
-(void) OnHasWrite;
-(void) OnError;
-(void) OnEOF;

@end

