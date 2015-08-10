//
//  MessageParser.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageParser : NSObject

/* This method parses the objects recieved from the parse server and constructs
 a Message object. This method clubs all the messages of a particle user which
 are in sequence and constructs a single Message Object. */
- (NSArray *)parseObjects:(NSArray *)dataObjects;

@end
