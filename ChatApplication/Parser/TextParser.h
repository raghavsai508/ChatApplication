//
//  TextParser.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface TextParser : NSObject

/* This method returns the frame for the message that is to be displayed 
 on the chat. */
+ (CGRect)getTextWidthHeight:(NSString *)message;

@end
