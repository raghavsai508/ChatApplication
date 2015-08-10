//
//  MessageContainer.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageContainer : NSObject

/* Each Message object is stored in the MessageConatiner using this array. */
@property (nonatomic, strong) NSArray *messageContainerArray;

@end
