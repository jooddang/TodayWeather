//
//  ClinetConnector.m
//  SocketClient
//
//  Created by 이진호 on 10. 4. 29..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClinetConnector.h"
#import <CFNetwork/CFNetwork.h>
#include <sys/socket.h>
#include <netinet/in.h>


@implementation ClinetConnector

- (id) init {
	
	host = nil;
	port = 0;
	instream = nil;
	outstream = nil;
	return self;	
}
- (id) initWithIF:(id)aif {
	
	[self init];
	rcvif = aif;
	return self;
}

- (void) dealloc {

	[instream release];
	[outstream release];
	[super dealloc];
}
- (void) connect:(NSString*)ip port:(int)remoteport {
	

	//host = CFSTR([ip UTF8String]);
	host = CFStringCreateWithCString(kCFAllocatorDefault, [ip UTF8String], NSUnicodeStringEncoding);	
	//int size = [host length];
	port = remoteport;
	
	CFReadStreamRef		readStream = NULL;
	CFWriteStreamRef	writeStream = NULL;
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port,  &readStream, &writeStream);
	
	instream = (NSInputStream*)readStream;
	[instream retain];
	outstream =(NSOutputStream*)writeStream;
	[outstream retain];
	
	[instream setDelegate:self];
	[instream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[instream open];
	[outstream open];
	
	CFRelease(readStream);
	CFRelease(writeStream);
/*

	CFSocketContext context = { 0, self, NULL, NULL, NULL};
	CFSocketRef client = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack, (CFSocketCallBack)MyCallBack, &context);
	CFDataRef addressData;
	
	struct sockaddr_in theName;
	struct hostent *hp;
	theName.sin_port = hosts(port);
	theName.sin_family = AF_INET;
	
	strcpy(theName.sin_addr.s_addr, "61.74.231.65");
	addressData = CFDataCreate(NULL, (UInt8*)&theName, (CFIndex)sizeof(struct sockaddr_in));
	

	CFSocketConnectToAddress(client, addressData, 1);
	CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, client, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
	CFRunLoopRun();
*/
}

- (void)send:(NSString*)msg {
	
	if (outstream == nil) {
		NSLog(@"send: outstream=nil");
		return;
	}
	
	if ([outstream streamStatus] == NSStreamStatusOpen ||
		[outstream streamStatus] == NSStreamStatusReading ||
		[outstream streamStatus] == NSStreamStatusWriting) {

		[outstream write:(const uint8_t *)[msg  UTF8String] maxLength:(NSUInteger)[msg lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

	}
	NSLog(@"send: outstream [%@] status [%@]", outstream, [outstream streamStatus]);
}

- (void)disconnect {
	
	if(instream) {
		
		[instream setDelegate:nil];
		[instream close];
		[instream release];
		[outstream close]; 
		[outstream release];
		[rcvif OnDisconnect];
	}
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    switch(eventCode) {
        case NSStreamEventOpenCompleted:
            [self OnOpened];
            break;
        case NSStreamEventHasBytesAvailable:
            [self OnHasRead];
            break;
        case NSStreamEventHasSpaceAvailable:
            [self OnHasWrite];
            break;
        case NSStreamEventErrorOccurred:
            [self OnError];
            break;
        case NSStreamEventEndEncountered:
            [self OnEOF];
            break;
        default:
			NSLog(@"unknown NSStreamEvent %i", eventCode);
            break;
    }
}


-(void) OnOpened {
	
	[rcvif OnConnected];
	NSLog(@"Stream Open");
}

-(void) OnHasRead {
	
	NSInteger       bytesRead;
	uint8_t         buffer[32768];
	
	bytesRead =[instream read:buffer maxLength:sizeof(buffer)];
	
	if (bytesRead == 0) {
		[rcvif OnDisconnect];
		[self disconnect];
		return;
	}
		
	NSString * msg = [[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSUTF8StringEncoding];
	[rcvif OnReceive:msg]; 
	[msg release];
}

-(void) OnHasWrite{
}

-(void) OnError {
	
    NSError *error = instream.streamError;
    if( error ) {
		[rcvif OnError:error];
	}
}

-(void) OnEOF {
	
	NSLog(@"OnEOF....");
}

@end
