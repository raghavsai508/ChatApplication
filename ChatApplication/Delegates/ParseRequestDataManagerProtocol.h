//
//  ParseRequestDataManagerProtocol.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageContainer.h"

@protocol ParseCommDataProtocol <NSObject>

/* This method is a delegate between the server and the data manager. Once
 initial messages retreived this delegate is fired. */
- (void)initialMessagesRetreived:(MessageContainer *)messageContainer;

/* This method is a delegate between the server and the data manager. Once 
 most updated or recent messages are retreived this delegate is fired.*/
- (void)mostRecentMessagesRetreived:(MessageContainer *)messageConatiner;

/* This method is a delegate between the server and the data manager. Once
 old or top messages are retreived this delegate is fired.*/
- (void)topMessagesRetreived:(MessageContainer *)messageContainer;

@end

@interface ParseRequestDataManagerProtocol : NSObject

@end
