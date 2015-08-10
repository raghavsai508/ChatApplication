//
//  Message.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

/* Message Object: user id of the user. */
@property (nonatomic) NSNumber                      *userID;

/* Message Objec: This dictionary holds all the messages of a user 
 which are in sequence. Date is used as a key and message as value. */
@property (nonatomic, strong) NSMutableDictionary   *messageDictionary;

/* This array holds the keys(dates) of the above dictionary in 
 ascending order. */
@property (nonatomic, strong) NSArray               *sortedDates;

@end
