//
//  ParseRequestManager.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseRequestDataManagerProtocol.h"

@interface ParseRequestManager : NSObject

/* A Singleton ParseRequestManager is created using this method. */
+ (instancetype)parseRequestManager;

/* This method is responsible for getting initial messages from Parse. */
- (void)getInitialMessagesFromServer;

/* This method is responsible for getting the old messages which takes a date
 which is the old date present in the chat. It gets the old messages before
 this date. */
- (void)getTopMessagesFromServer:(id)firstDate;

/* This method is for getting the new messages from Parse. */
- (void)getNewMessagesFromServer:(id)mostRecentDate;

/* This method is reponsible for sending the data to Parse. */
- (void)sendDataToServer:(id)messageContainer;

/* This is delegate property between Sever and Data amanager. */
@property (nonatomic, weak) id<ParseCommDataProtocol> parseCommDataDelegate;

@end
