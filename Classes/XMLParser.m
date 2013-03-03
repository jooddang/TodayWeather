//
//  XMLParser.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 13..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser




- (NSString *) gimmeDescription:(NSMutableArray *)chunk
{
	/////////////// get reportTime
	NSString *reportTimeIs = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"reportTime"]]
							  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSLog(@"reporttime = [%@]", reportTimeIs);
	
	
	int hoursForward = 5;
	
	/////////////// get min temperature, and max temperature
	NSArray *arrayTemp = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"temp"]] componentsSeparatedByString:@"\n"];
	//NSArray *arrayTemp = [NSArray arrayWithObjects:@"3.0", @"-10.4",@"24.0",@"0.1", @"0.0", nil];

	for (int i = 0; i < hoursForward; i++) {
		NSLog(@"temp[%@]", [[arrayTemp objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
	}
	
	NSNumber *minTemp = [NSNumber numberWithFloat:999.0f];
	NSNumber *maxTemp = [NSNumber numberWithFloat:-999.0f];
	NSLog(@"MAX=[%@]",maxTemp);
	NSLog(@"MIN=[%@]",minTemp);

	
	////////////// get wfkor
	NSArray *arrayWFKorean = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"wfkor"]] componentsSeparatedByString:@"\n"];
	NSMutableArray *koreanDescription = [NSMutableArray arrayWithObjects:[arrayWFKorean objectAtIndex:0], nil];

	
	///////////// get probRain
	NSArray *arrayProbRain = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"probRain"]] componentsSeparatedByString:@"\n"];
	NSNumber *maxProbRain = [NSNumber numberWithInt:0];
	
	NSArray *arrayAmountRain = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"amountRain"]] componentsSeparatedByString:@"\n"];
	NSNumber *maxAmountRain = [NSNumber numberWithFloat:0.0f];
	
	NSArray *arrayHumidity = [[[chunk objectAtIndex:1] objectForKey:[weatherXML objectForKey:@"humidity"]] componentsSeparatedByString:@"\n"];
	NSNumber *avgHumidity = [NSNumber numberWithInt:0];
	
	for (int i = 0; i < hoursForward; i++) {
		if ([minTemp floatValue] > [[[arrayTemp objectAtIndex:i] 
												stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] 
												floatValue]) {
			minTemp = [NSNumber numberWithFloat:[[[arrayTemp objectAtIndex:i]
												stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
												floatValue]];
		}
		
		if ([maxTemp floatValue] < [[[arrayTemp objectAtIndex:i]
									 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
									floatValue]) {
			maxTemp = [NSNumber	numberWithFloat:[[[arrayTemp objectAtIndex:i]
												  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
												 floatValue]];
		}
		
		if ([[koreanDescription lastObject] isEqualToString:
			 [[arrayWFKorean objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == NO ) {
			[koreanDescription addObject:[[arrayWFKorean objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
		
		NSString *trimStr = [[arrayProbRain objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([maxProbRain intValue] < [trimStr intValue]) {
			maxProbRain = [NSNumber numberWithInt:[trimStr intValue]];
		}
		
		trimStr = [[arrayAmountRain objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([maxAmountRain floatValue] < [trimStr floatValue]) {
			maxAmountRain = [NSNumber numberWithFloat:[trimStr floatValue]];
		}
		
		trimStr = [[arrayHumidity objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		avgHumidity = [NSNumber numberWithInt:[avgHumidity intValue] + [trimStr intValue]];
	}
	avgHumidity = [NSNumber numberWithInt:[avgHumidity intValue] / hoursForward];
	NSLog(@"max[%@], min[%@]", maxTemp, minTemp);
	NSLog(@"maxProbRain=[%@]", maxProbRain);
	NSLog(@"humidity = [%@]", avgHumidity);
	
	for (NSString *str in koreanDescription) {
		NSLog(@"koreanDescription [%@]", str);
	}
	
	
	selectedImage = [weatherImage objectForKey:@"sunny"];
	NSMutableString *ret = [NSMutableString stringWithString: @"오늘의 날씨는 "];
	for (int i = 0; i < [koreanDescription count]; i++) {
		[ret appendString:[koreanDescription objectAtIndex:i]];

		if ([koreanDescription count] > 1 && (i+1) != [koreanDescription count]) {
			[ret appendString:@" 이후 "];
		}
	}
	[ret appendFormat:@"입니당.\n기온은 %@도에서 %@도 사이이고,\n습도는 %@%% 되겠습니다.\n",minTemp, maxTemp, avgHumidity];
	
	if ([maxProbRain intValue] > 0) {
		[ret appendFormat:@"강수확률은 최대 %@%%, 예상강수량은 %@ mm입니다.\n",maxProbRain, maxAmountRain];
	}
	
//	NSRange range;
//	range.location
	[ret appendFormat:@"%@년 %@월 %@일 %@시 기준입니다.", [reportTimeIs substringToIndex:4],
							([[reportTimeIs substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"0"] == YES) ? 
										[reportTimeIs substringWithRange:NSMakeRange(5, 1)] : 
										[reportTimeIs substringWithRange:NSMakeRange(4, 2)],
							([[reportTimeIs substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"0"] == YES) ?
										[reportTimeIs substringWithRange:NSMakeRange(7, 1)] :
										[reportTimeIs substringWithRange:NSMakeRange(6, 2)],
							([[reportTimeIs substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"0"] == YES) ?
										[reportTimeIs substringWithRange:NSMakeRange(9, 1)] :
										[reportTimeIs substringWithRange:NSMakeRange(8, 2)]];
	
	NSLog(@"%@",ret);

	// image setting
	for (NSString *str in koreanDescription) {
		if ([str rangeOfString:@"비"].location != NSNotFound) {
			selectedImage = [weatherImage objectForKey:@"rainy"];
			break;
		}
		if ([str rangeOfString:@"구름"].location != NSNotFound || [str rangeOfString:@"흐림"].location != NSNotFound) {
			selectedImage = [weatherImage objectForKey:@"cloudy"];
		}
	}
	NSLog(@"gimmeDescription image[%@]", selectedImage);
	
	return [NSString stringWithFormat:@"%@", ret];
}



- (NSDictionary *) parseXMLFileAtURL:(NSString *)URL
{
	@try {
	
	stories = [[NSMutableArray alloc] init];
	
	NSLog(@"1");
	
	// value, key 순서임. 헷갈리지 말것. 기상청 xml 문법이 바뀌면 여기서 value 를 바꾸면 됨.
	// 온도, 날씨(한글), 강수확률, 예상강수량, 습도
	weatherXML = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"tm", @"reportTime",
				  @"temp", @"temp", 
				  @"wfKor", @"wfkor",
				  @"pop", @"probRain",
				  @"r12", @"amountRain",
				  @"reh", @"humidity",
				  nil];
	weatherImage = [NSDictionary dictionaryWithObjectsAndKeys:@"sunny", @"sunny",
					@"cloudy", @"cloudy",
					@"rainy", @"rainy",
					@"notFound", @"notFound",
					nil];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
	NSLog(@"url = [%@]", URL);
	
	[rssParser parse];
	
	NSLog(@"2");
//	NSLog(@"stories[%@] count[%lu]", stories, [stories count]);
	}
	
	@catch (NSException *e) {
		NSLog(@"parseXML error [%@] [%@]", [e name], [e reason]);
	}
	
	selectedImage = [weatherImage objectForKey:@"notFound"];
	if ([stories count] < 1) {
		NSLog(@"return1");
		return [NSDictionary dictionaryWithObjectsAndKeys:selectedImage, @"weatherImage",
				[NSString stringWithString:@"인터넷 연결이 불안정하여 날씨 정보를 읽어올 수 없습니다.\n다시 시도하거나 오늘의 날씨는 하늘의 뜻에 맡기세욤ㅋㅋ 죄송ㅋ"], @"weatherDescription", nil];
	}
	else {
		NSLog(@"return2 image[%@]", selectedImage);
		NSString *description = [self gimmeDescription:stories];
		return [NSDictionary dictionaryWithObjectsAndKeys:selectedImage, @"weatherImage", 
				description, @"weatherDescription", nil];
	}
}





- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	NSLog(@"=========== found file and started parsing ===========");
	
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
//	[activityIndicator startAnimating];
//	[activityIndicator removeFromSuperview];
	
	NSLog(@"=========== all done! ===========");
	NSLog(@"stories array has %d items", [stories count]);
	
	for (NSString *str in stories) {
		NSLog(@"[%@]", str);
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
//	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[errorAlert show];
//	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
//    NSLog(@"----- didStartElement ::::: found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"description"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		temp = [[NSMutableString alloc] init];
		wfkor = [[NSMutableString alloc] init];
		probRain = [[NSMutableString alloc] init];
		amountRain = [[NSMutableString alloc] init];
		humidity = [[NSMutableString alloc] init];
		
		reportTime = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
//	NSLog(@"----- didEndElement :::: ended element: %@", elementName);
	if ([elementName isEqualToString:@"description"]) {
		// save values to an item, then store that item into the array...
		[item setObject:temp forKey:[weatherXML objectForKey:@"temp"]];
		[item setObject:wfkor forKey:[weatherXML objectForKey:@"wfkor"]];
		[item setObject:probRain forKey:[weatherXML objectForKey:@"probRain"]];
		[item setObject:amountRain forKey:[weatherXML objectForKey:@"amountRain"]];
		[item setObject:humidity forKey:[weatherXML objectForKey:@"humidity"]];
		
		[item setObject:reportTime forKey:[weatherXML objectForKey:@"reportTime"]];
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", elementName);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//	NSLog(@"found characters :::: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:[weatherXML objectForKey:@"temp"]]) {
		[temp appendString:string];
	} 
	else if ([currentElement isEqualToString:[weatherXML objectForKey:@"wfkor"]]) {
//		NSLog(@"  ********* =-=-=-=-=-=-= korean[%@]", string);
		[wfkor appendString:string];
	} 
	else if ([currentElement isEqualToString:[weatherXML objectForKey:@"probRain"]]) {
		[probRain appendString:string];
	} 
	else if ([currentElement isEqualToString:[weatherXML objectForKey:@"amountRain"]]) {
		[amountRain appendString:string];
	}
	else if ([currentElement isEqualToString:[weatherXML objectForKey:@"humidity"]]) {
		[humidity appendString:string];
	}
	else if ([currentElement isEqualToString:[weatherXML objectForKey:@"reportTime"]]) {
		[reportTime appendString:string];
	}
	
}


- (void)dealloc {
	
	[currentElement release];
	[rssParser release];
	[stories release];
	[item release];
	[temp release];
	[wfkor release];
	[probRain release];
	[amountRain release];
	[humidity release];
	[reportTime release];
	[weatherXML release];
	
	[super dealloc];
}


@end
