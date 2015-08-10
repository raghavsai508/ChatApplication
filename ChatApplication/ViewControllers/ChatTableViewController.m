//
//  ChatTableViewController.m
//  ChatApplication
//
//  Created by Raghav Sai Cheedalla on 8/8/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "ChatTableViewController.h"
#import "DataManager.h"
#import "ChatTableViewCell.h"
#import "MessageContainer.h"
#import "Message.h"
#import "TextParser.h"
#import "SystemLevelConstants.h"

#define Animation_Duration 0.25

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionDown = 1,
    ScrollDirectionUp = 0
};

@interface ChatTableViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  NSMutableArray               *messageArray;
@property (nonatomic, strong) DataManager                   *dataManager;
@property (nonatomic) NSInteger                             lastCount;
@property (nonatomic) NSInteger                             countToBeAdded;
@property (nonatomic, strong) UIView                        *footerView;
@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UITextField            *txtSendField;
@property (weak, nonatomic) IBOutlet UIButton               *btnSend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *footerConstraint;

@property (nonatomic) CGFloat                               footerViewHeight;

@end

@implementation ChatTableViewController

CGFloat yOffset = 0.0;

/* Getter for Data Manager. */
- (DataManager *)dataManager
{
    if(!_dataManager)
    {
        _dataManager = [DataManager dataManager];
    }
    return _dataManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.footerViewHeight = self.footerConstraint.constant;
    self.messageArray = [[NSMutableArray alloc] init];
    [self loadMessages];
    [self setNavigationBar];
    [self setUpDelegates];
    [self registerKeyboardNotifications];
}

/* This method loads the initial messages from the data manager where it communicates with the server. */
- (void)loadMessages
{
    self.dataManager.dataCommViewDelegate = self;
    [self.dataManager getInitialMessages];
}

/* A basic setup of the navigation bar. */
- (void)setNavigationBar
{
    if(UserID == 1234)
        self.navigationItem.title = @"757-692-6482";
    else
        self.navigationItem.title = @"408-679-1499";
}

/* Delegates for the table view and text fields are set in this method. */
- (void)setUpDelegates
{
    self.txtSendField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/* This method registers for KeyBoard Notifications. */
- (void)registerKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* In this all the necessary objects are deallocated. */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.messageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getMessageCountAtSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatTableViewCell class]) forIndexPath:indexPath];
    Message *message = self.messageArray[indexPath.section];
    id dateKey = message.sortedDates[indexPath.row];
    int currentUserID = [message.userID intValue];
    
    if(currentUserID == UserID)
        [cell configureChatViewCell:[message.messageDictionary objectForKey:dateKey] withDate:dateKey user:YES];
    else
        [cell configureChatViewCell:[message.messageDictionary objectForKey:dateKey] withDate:dateKey user:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = self.messageArray[indexPath.section];
    id dateKey = message.sortedDates[indexPath.row];
    CGRect rect = [TextParser getTextWidthHeight:[message.messageDictionary objectForKey:dateKey]];
    rect.size.height += 20*2;
    CGFloat height = rect.size.height < 65 ? 65 : rect.size.height;
    return height;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [self getVisibleIndexPath];
    [self getNewMessagesBasedOnScrollDirectionAtIndexPath:indexPath];
}

/* This method is responsible for getting the visible indexPath */
- (NSIndexPath *)getVisibleIndexPath
{
    NSArray *visibleIndexArrays = [self.tableView indexPathsForVisibleRows];
    return [visibleIndexArrays firstObject];
}


#pragma mark - DataCommViewProtocol methods
/* This is a protcol method where it gets the initial messages from the data manager. */
- (void)getInitialMessageContainer:(MessageContainer *)messageContainer
{
    NSArray *tempArray = messageContainer.messageContainerArray;
    self.messageArray = [tempArray mutableCopy];
    self.lastCount = [self.messageArray count];
    [self.tableView reloadData];
}

/* This is a protcol method where it gets the most recent messages from the data manager. */
- (void)getNewMessagesConstainer:(MessageContainer *)messageContainer
{
    NSArray *tempArray = [messageContainer.messageContainerArray copy];
    self.countToBeAdded = [tempArray count];
    [self.messageArray addObjectsFromArray:tempArray];
    [self addNewContentToTable];
    self.lastCount = [self.messageArray count];
}

/* This is a protcol method where it gets the top messages from the data manager when we go up the chat. */
- (void)getTopMessageContainer:(MessageContainer *)messageContainer
{
    NSArray *tempArray = [messageContainer.messageContainerArray copy];
    [self addObjectsToTopOfArray:tempArray];
}

#pragma mark - Action methods
/* This method submits the data to data manager and also updates the table view. */
- (IBAction)submitTextMessage:(id)sender
{
    if (self.txtSendField.text.length > 0)
    {
        Message *message = [[Message alloc] init];
        message.userID = [NSNumber numberWithInt:UserID];
        message.messageDictionary = [[NSMutableDictionary alloc] init];
        NSDate *date = [NSDate date];
        [message.messageDictionary setObject:self.txtSendField.text forKey:date];
        message.sortedDates = [[NSArray alloc] initWithObjects:date, nil];
        [self containTheMessage:message];
        self.txtSendField.text = @"";
    }
}

/* This is a helper method for submitTextMessage: method where it wraps the message 
 in a message container. */
- (void)containTheMessage:(Message *)message
{
    MessageContainer *messageContainer = [[MessageContainer alloc] init];
    messageContainer.messageContainerArray = [[NSArray alloc] initWithObjects:message, nil];
    [self addObjectToTableView:message];
    [self.dataManager sendDataToDataManager:messageContainer];
}

/* This is a helper method for submitTextMessage: method where it add the message 
 to the chat when submitted. */
- (void)addObjectToTableView:(Message *)message
{
    [self.messageArray addObject:message];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[self.messageArray count]-1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Utility methods
/* This method gets old or top messages when scrolled up. */
- (void)getNewMessagesBasedOnScrollDirectionAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollDirection direction = [self getScrollDirection];
    if ((direction == ScrollDirectionUp) && (indexPath.row == 0))
    {
        self.dataManager.dataCommViewDelegate = self;
        Message *message = [self.messageArray firstObject];
        id firstDate = [message.sortedDates firstObject];
        [self.dataManager getTopMessages:firstDate];
    }
}

/* This method gets the Scroll direction of the table view. */
- (ScrollDirection)getScrollDirection
{
    ScrollDirection returnValue;
    if (self.tableView.contentOffset.y < yOffset)
    {
        yOffset = self.tableView.contentOffset.y;
        returnValue = ScrollDirectionDown;
    }
    else
    {
        yOffset = self.tableView.contentOffset.y;
        returnValue = ScrollDirectionUp;
    }
    
    return returnValue;
}

/* This is a helper method for Tableview data source where it returns the number of rows 
 in each section. */
- (NSInteger)getMessageCountAtSection:(NSInteger)section
{
    Message *message = self.messageArray[section];
    return [message.messageDictionary count];
}

/* This method is a helper method for new content or most recent messages. */
- (void)addNewContentToTable
{
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[self.messageArray count]-1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/* This method is a helper for loading old messages. */
- (void)addObjectsToTopOfArray:(NSArray *)topArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:topArray];
    [tempArray addObjectsFromArray:[self.messageArray copy]];
    [self.messageArray removeAllObjects];
    [self.messageArray addObjectsFromArray:[tempArray copy]];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[self.messageArray count]-1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


/* When keyboard is shown this method is fired. */
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self animateFooterView:kbSize];
}

/* When the keyboard is shown it animates the textfield. */
- (void)animateFooterView:(CGSize)kbSize
{
    [UIView animateWithDuration:Animation_Duration
                     animations:^{
                         self.footerConstraint.constant = kbSize.height+self.footerViewHeight;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

@end
