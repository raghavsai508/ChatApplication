//
//  DataManagerViewControlProtocol.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageContainer.h"

@protocol DataCommViewProtocol <NSObject>

/* This method is a delegate between the data manager and the view controller. 
 Once the initial messages are retreived from server this delegate is fired.*/
- (void)getInitialMessageContainer:(MessageContainer *)messageContainer;

/* This method is a delegate between the data manager and the view controller.
 Once the recent messages are retreived from server this delegate is fired.*/
- (void)getNewMessagesConstainer:(MessageContainer *)messageContainer;

/* This method is a delegate between the data manager and the view controller.
 Once the old or top messages are retreived from server this delegate is fired.*/
- (void)getTopMessageContainer:(MessageContainer *)messageContainer;

@end

@interface DataManagerViewControlProtocol : NSObject

@end
