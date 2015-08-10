//
//  TextParser.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "TextParser.h"
#import <UIKit/NSStringDrawing.h>
#import <UIKit/NSParagraphStyle.h>
#import <UIKit/UIFont.h>


#define LabelWidth  260
#define Padding     20

@implementation TextParser

+(CGRect)getTextWidthHeight:(NSString *)message
{
    CGSize messageSize = CGSizeMake(LabelWidth, CGFLOAT_MAX);
    CGRect messageRect = [message boundingRectWithSize:messageSize
                                               options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}
                                               context:nil];
    messageRect.size.width += Padding/2;
    return messageRect;
}


@end
