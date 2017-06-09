//
//  EventViewController.m
//  ShareMoney
//
//  Created by Daniel on 2017/2/20.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "EventViewController.h"


@interface EventViewController () <UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary * eventDic;
    DatabaseManager * databaseManager;
    
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = self.dateString;
    databaseManager = [DatabaseManager new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell" forIndexPath:indexPath];
    cell.textLabel.text = @"A";
    cell.detailTextLabel.text = @"125";
    return cell;
    
}

#pragma mark - <UITableViewDelegate>

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"成員";
            break;
        case 1:
            return @"支出列表";
            break;
            
        default:
            return @"";
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView* headerView = [UITableViewHeaderFooterView new];
    headerView.textLabel.textColor = [UIColor grayColor];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0f;
}

#pragma mark - Btn Action Mehtods

- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)saveBtnPressed:(id)sender {
    
    eventDic = [NSMutableDictionary new];
    [eventDic setObject:_eventTitleTextField.text forKey:EVENT_TITLE_KEY];
    [eventDic setObject:_dateString forKey:DATE_KEY];
    [eventDic setObject:@100 forKey:TOTALCOST_KEY];
    [databaseManager addEvent:eventDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATIONCENTER_RELOAD_TABLE_VIEW object:nil];
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (IBAction)addMemberBtnPressed:(id)sender {
    
}

- (IBAction)addCostBtnPressed:(id)sender {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
