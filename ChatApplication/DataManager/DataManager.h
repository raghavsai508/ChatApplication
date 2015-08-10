//
//  DataManager.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManagerViewControlProtocol.h"

@interface DataManager : NSObject

/* A Singleton Data manager is created using this method. */
+ (instancetype)dataManager;

/* This method is responsible for getting initial messages from the server. */
- (void)getInitialMessages;

/* this method is responsible for getting the old messages which takes a date 
 which is the old date present in the chat. It gets the old messages before 
 this date. */
- (void)getTopMessages:(NSDate *)firstDate;

/* This method is responsible for submitting the message wrapped in message 
 container to ther server. */
- (void)sendDataToDataManager:(id)messageContainer;

/* This property is a delegate property for Data manager and View Controller. */
@property (nonatomic, weak) id<DataCommViewProtocol> dataCommViewDelegate;

@end
