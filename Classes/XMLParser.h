//
//  XMLParser.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 13..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NSXMLParserDelegate;


@interface XMLParser : NSObject <NSXMLParserDelegate> {
	
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	
	
	//UIActivityIndicatorView * activityIndicator;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
//	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	
	NSMutableString *temp, *wfkor, *probRain, *amountRain, *humidity;	// 온도, 날씨(한글), 강수확률, 예상강수량, 습도
	NSMutableString *reportTime;	// 예보시간
	// value, key 순서임. 헷갈리지 말것. 기상청 xml 문법이 바뀌면 여기서 value 를 바꾸면 됨.
	NSDictionary *weatherXML;
	// weather image png파일 이름이 여기에 저장되어있음.
	NSDictionary *weatherImage;
	NSString *selectedImage;
}

- (NSDictionary *) parseXMLFileAtURL:(NSString *)URL;

@end
