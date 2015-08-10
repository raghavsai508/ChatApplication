//
//  DataManager.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "DataManager.h"
#import "ParseRequestManager.h"
#import "ParseRequestDataManagerProtocol.h"
#import "Message.h"

@interface DataManager ()<ParseCommDataProtocol>

@property (nonatomic, strong) ParseRequestManager   *parseReqManager;
@property (nonatomic, strong) NSDate                *mostRecentDate;
@property (nonatomic, strong) MessageContainer      *messagerContainerObject;

@end

@implementation DataManager

/* A Singleton Data manager is created using this method. */
+ (instancetype)dataManager
{
    static DataManager *dataManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dataManager = [[self alloc] init];
        [dataManager startTimerForNewMessages];
    });
    return dataManager;
}

/* A getter for ParseRequestManager. */
- (ParseRequestManager *)parseReqManager
{
    if(!_parseReqManager)
        _parseReqManager = [ParseRequestManager parseRequestManager];
    return _parseReqManager;
}

/* This method is responsible for getting initial messages from the server. */
- (void)getInitialMessages
{
    self.parseReqManager.parseCommDataDelegate = self;
    [self.parseReqManager getInitialMessagesFromServer];
}

/* this method is responsible for getting the old messages which takes a date
 which is the old date present in the chat. It gets the old messages before
 this date. */
- (void)getTopMessages:(id)firstDate
{
    self.parseReqManager.parseCommDataDelegate = self;
    [self.parseReqManager getTopMessagesFromServer:firstDate];
}

/* This method is for getting the new messages from the server. */
- (void)getNewMessages
{
    self.parseReqManager.parseCommDataDelegate = self;
    if(!self.mostRecentDate)
        self.mostRecentDate = [NSDate date];
    [self.parseReqManager getNewMessagesFromServer:self.mostRecentDate];
}

/* This method is responsible for submitting the message wrapped in message
 container to ther server. */
- (void)sendDataToDataManager:(id)messageContainer
{
    MessageContainer *messageContainerObject = (MessageContainer *)messageContainer;
    self.mostRecentDate = [self getMostRecentDate:messageContainerObject];
    [self.parseReqManager sendDataToServer:messageContainerObject];
}

#pragma mark - ParseCommDataProtocol methods
- (void)initialMessagesRetreived:(MessageContainer *)messageContainer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataCommViewDelegate getInitialMessageContainer:messageContainer];
    });
    self.mostRecentDate = [self getMostRecentDate:messageContainer];
}

- (void)mostRecentMessagesRetreived:(MessageContainer *)messageConatiner
{
    if(![self.mostRecentDate isEqualToDate:[self getMostRecentDate:messageConatiner]])
    {
        self.mostRecentDate = [self getMostRecentDate:messageConatiner];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataCommViewDelegate getNewMessagesConstainer:messageConatiner];
        });
    }
}

- (void)topMessagesRetreived:(MessageContainer *)messageContainer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataCommViewDelegate getTopMessageContainer:messageContainer];
    });
}

#pragma mark - utilty methods
/* This method periodically calls the server for new data and it calls for 
 every 2 seconds. */
- (void)startTimerForNewMessages
{
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(getNewMessages)
                                   userInfo:nil
                                    repeats:YES];
}

/* This method gets the most recent date from the message container. */
- (NSDate *)getMostRecentDate:(MessageContainer *)messageContainer
{
    Message *message = [messageContainer.messageContainerArray firstObject];
    return [message.sortedDates lastObject];
}

@end
