//
//  ChatTableViewCell.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "TextParser.h"

#define Padding 20

@interface  ChatTableViewCell ()

@property (nonatomic, strong) UIImageView       *messageImageView;
@property (nonatomic, strong) UITextView        *txtMessageView;

@end


@implementation ChatTableViewCell

/* Initial setup for the cell is done here. */
- (void)awakeFromNib
{
    [self setupMessageView];
    [self setupImageView];
    
}

/* This method is responsible for setting up the setup message view. */
- (void)setupMessageView
{
    self.txtMessageView = [[UITextView alloc] init];
    self.txtMessageView.backgroundColor = [UIColor clearColor];
    self.txtMessageView.editable = NO;
    self.txtMessageView.scrollEnabled = NO;
    [self.txtMessageView setContentOffset: CGPointMake(0,0) animated:NO];
    [self.txtMessageView sizeToFit];
    [self.contentView addSubview:self.txtMessageView];
}

/* This method is responsible for setting up the Image view. */
- (void)setupImageView
{
    self.messageImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.messageImageView];
}

/* This method is responsible for configuring the message and placing the message based on user */
- (void)configureChatViewCell:(NSString *)message withDate:(NSDate *)createdAt user:(BOOL)currentUser
{
    self.txtMessageView.text = message;
    CGRect messageRect = [TextParser getTextWidthHeight:message];
    [self setupMessageViewFrame:messageRect user:currentUser];
    [self setupImageViewFrame:messageRect];
    if(currentUser)
        self.messageImageView.image = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    else
        self.messageImageView.image = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    [self.contentView bringSubviewToFront:self.txtMessageView];
}

/* This method setups the TextView based on the user whether to be aligned left or right. */
- (void)setupMessageViewFrame:(CGRect)rect user:(BOOL)currentUser
{
    CGFloat originX, originY;
    if(currentUser)
    {
        originX = self.contentView.bounds.size.width - rect.size.width - Padding;
        originY = Padding;
        self.txtMessageView.frame = CGRectMake(originX, originY, rect.size.width, rect.size.height+Padding);
    }
    else
    {
        originX = Padding;
        originY = Padding;
        self.txtMessageView.frame = CGRectMake(originX, originX, rect.size.width, rect.size.height+Padding);
    }
}

/* This method setups the imageview for the message. The bubbles you can see on the screen. */
- (void)setupImageViewFrame:(CGRect)rect
{
    CGFloat originX, originY;
    originX = self.txtMessageView.frame.origin.x - Padding/2;
    originY = self.txtMessageView.frame.origin.y;
    self.messageImageView.frame = CGRectMake(originX, originY, rect.size.width+Padding, rect.size.height+Padding);
}

/* In prepare for reuse, a new cell is prepared again. */
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.messageImageView removeFromSuperview];
    [self.txtMessageView removeFromSuperview];
    [self setupMessageView];
    [self setupImageView];
}

@end
