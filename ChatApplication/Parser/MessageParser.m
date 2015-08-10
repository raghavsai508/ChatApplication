//
//  MessageParser.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Parse/PFObject.h>
#import "MessageParser.h"
#import "Message.h"

@interface MessageParser ()

@property (nonatomic, strong) NSMutableArray *messagesArray;

@end

@implementation MessageParser

/* This method parses the objects recieved from the parse server and constructs 
 a Message object. This method clubs all the messages of a particle user which 
 are in sequence and constructs a single Message Object. */
- (NSArray *)parseObjects:(NSArray *)dataObjects
{
    NSNumber *previousID;
    self.messagesArray = [[NSMutableArray alloc] init];
    for(PFObject *pfMessageObject in dataObjects)
    {
        Message *message;
        if([self.messagesArray count]>0)
        {
            message = [self.messagesArray lastObject];
            previousID = message.userID;
        }
        
        if(previousID == (NSNumber *)(NSNumber *)pfMessageObject[@"UserID"])
        {
            [message.messageDictionary setObject:pfMessageObject[@"MessageString"] forKey:pfMessageObject[@"messageDate"]];
        }
        else
        {
            message = [[Message alloc] init];
            message.userID = (NSNumber *)pfMessageObject[@"UserID"];
            message.messageDictionary = [[NSMutableDictionary alloc] init];
            [message.messageDictionary setObject:pfMessageObject[@"MessageString"] forKey:pfMessageObject[@"messageDate"]];
            [self.messagesArray addObject:message];
        }
    }
    
    [self sortDatesForMessages];
    
    return self.messagesArray;
}

/* Helper method for parseObjects where it orders the dates in ascending order. */
- (void)sortDatesForMessages
{
    for(Message *message in self.messagesArray)
    {
        NSArray *keys = [message.messageDictionary allKeys];
        message.sortedDates = [keys sortedArrayUsingComparator: ^NSComparisonResult(id a, id b)
        {
            NSDate *d1 = (NSDate*)a;
            NSDate *d2 = (NSDate*)b;
            
            return [d1 compare:d2];
        }];        
    }
}


@end
