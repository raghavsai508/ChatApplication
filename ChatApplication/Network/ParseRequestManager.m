//
//  ParseRequestManager.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseRequestManager.h"
#import "MessageParser.h"
#import "MessageContainer.h"
#import "Message.h"

@interface ParseRequestManager ()



@end

@implementation ParseRequestManager

+ (instancetype)parseRequestManager
{
    static ParseRequestManager *networkManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        networkManager = [[self alloc] init];
    });
    return networkManager;
}

- (void)getInitialMessagesFromServer
{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    query.limit = 5;
    [query orderByDescending:@"messageDate"];
    ParseRequestManager* __block weakParse = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        MessageContainer *messsageContainer = [[MessageContainer alloc] init];
        if(!error)
        {
            messsageContainer.messageContainerArray = [[[MessageParser alloc] init] parseObjects:objects];
            messsageContainer.messageContainerArray = [[messsageContainer.messageContainerArray reverseObjectEnumerator] allObjects];

            if([objects count]>0)
                [weakParse.parseCommDataDelegate initialMessagesRetreived:messsageContainer];
            weakParse = nil;
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];

}

- (void)getTopMessagesFromServer:(id)firstDate
{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"messageDate" lessThan:firstDate];
    [query orderByAscending:@"messageDate"];
    query.limit = 10;
    ParseRequestManager* __block weakParse = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        MessageContainer *messsageContainer = [[MessageContainer alloc] init];
        if(!error)
        {
            messsageContainer.messageContainerArray = [[[MessageParser alloc] init] parseObjects:objects];
            if([objects count]>0)
                [weakParse.parseCommDataDelegate topMessagesRetreived:messsageContainer];
            weakParse = nil;
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (void)getNewMessagesFromServer:(id)mostRecentDate
{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"messageDate" greaterThan:mostRecentDate];
    ParseRequestManager* __block weakParse = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        MessageContainer *messsageContainer = [[MessageContainer alloc] init];
        if(!error)
        {
            messsageContainer.messageContainerArray = [[[MessageParser alloc] init] parseObjects:objects];
            if([objects count]>0)
                [weakParse.parseCommDataDelegate mostRecentMessagesRetreived:messsageContainer];
            weakParse = nil;
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (void)sendDataToServer:(id)messageContainer
{
    MessageContainer *messageContainerObject = (MessageContainer*)messageContainer;
    Message *message = [messageContainerObject.messageContainerArray lastObject];
    PFObject *testObject = [PFObject objectWithClassName:@"Messages"];
    testObject[@"UserID"] = message.userID;
    NSArray *keys = [message.messageDictionary allKeys];
    for (id date in keys)
    {
        testObject[@"MessageString"] = [message.messageDictionary objectForKey:date];
        testObject[@"messageDate"] = date;
    }
    [testObject saveInBackgroundWithBlock:^(BOOL success,NSError *error){
        
    }];
}

@end
