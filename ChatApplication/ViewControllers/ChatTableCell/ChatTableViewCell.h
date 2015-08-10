//
//  ChatTableViewCell.h
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

/* This method is reposnsible cinfiguring the cell.*/
- (void)configureChatViewCell:(NSString *)message withDate:(NSDate *)createdAt user:(BOOL)currentUser;


@end
