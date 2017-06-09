//
//  ViewController.m
//  ShareMoney
//
//  Created by Daniel on 2017/2/14.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "ViewController.h"



@interface ViewController () <UIGestureRecognizerDelegate,FSCalendarDataSource,FSCalendarDelegate,UITableViewDataSource,UITableViewDelegate> {
    void * _KVOContext;
    NSString * dateString;
    NSDictionary * eventDic;
    NSMutableArray * eventArray;
    NSArray * eventDateArray;
    DatabaseManager * databaseManager;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.tableView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:1];
//    self.tableView.separatorColor = [UIColor redColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:NSNOTIFICATIONCENTER_RELOAD_TABLE_VIEW object:nil];
    eventArray = [NSMutableArray new];
    databaseManager = [DatabaseManager new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

    
    // set calendar
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _calendar.appearance.headerMinimumDissolvedAlpha = 0;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    
    // set dateFormatter
    NSLocale *chinese = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = chinese;
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // select today
    [self.calendar selectDate:[NSDate date] scrollToDate:NO];
    dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    eventArray = [databaseManager getValueFromEventTableWithDate:dateString];
    
    // add button on calendar
    [self addPreAndNextBtnOnCalendar];
    
    //    // add Gesture
    //
    //    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_calendar action:@selector(handlePan:)];
    //    [_calendar addGestureRecognizer:scopeGesture];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    cell.textLabel.text = eventArray[indexPath.row][EVENT_TITLE_KEY];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",eventArray[indexPath.row][TOTALCOST_KEY]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [databaseManager deleteEventWithID:[eventArray[indexPath.row][EVENT_ID_KEY] intValue]];
        [eventArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self getAllEventDate];
        [self.calendar reloadData];
    }
}

#pragma mark - <UITableViewDelegate>

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
            tableView.backgroundColor = [UIColor clearColor];
            return dateString;
            break;
        default:
            return @"";
            break;
    }
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    
//    UITableViewHeaderFooterView* headerView = [UITableViewHeaderFooterView new];
//    headerView.textLabel.textColor = [UIColor grayColor];
//    headerView.backgroundColor = [UIColor redColor];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0f;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *tempTableView = [self.tableView headerViewForSection:0];
//    tempTableView.backgroundColor = [UIColor redColor];
//    return tempTableView;
//}
#pragma  mark - Btn Pressed
- (IBAction)todayBtnPressed:(id)sender {
    
    // select today
    [self.calendar selectDate:[NSDate date] scrollToDate:NO];
    // go to today page
    [_calendar setCurrentPage:[NSDate date] animated:NO];
    dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    [self reloadTableView];
}
- (IBAction)addEventBtnPressed:(id)sender {
    
    EventViewController * eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
    eventViewController.dateString = dateString;
    [self presentViewController:eventViewController animated:true completion:nil];
}

#pragma mark - Btn Action Mehtods
- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
    
}
//- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
//    
//}
- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return [self.gregorian isDateInToday:date] ? @"今天" : nil;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    dateString = [self.dateFormatter stringFromDate:date];
    NSLog(@"did select date %@",dateString);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    [self reloadTableView];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    eventDateArray = [databaseManager getValueFromEventTableWithDate:nil];
    if ([eventDateArray containsObject:[self.dateFormatter stringFromDate:date]]) { 
        return 1;
    }
    return 0;
}
#pragma MARK - method
- (void)reloadTableView {
    
    eventArray = [databaseManager getValueFromEventTableWithDate:dateString];
    [self.tableView reloadData];
}

- (void)getAllEventDate {
    // date type nil means get all event date
    eventDateArray = [databaseManager getValueFromEventTableWithDate:nil];
    
}
- (void)addPreAndNextBtnOnCalendar {
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 64+5, 95, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95, 64+5, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
}
@end
