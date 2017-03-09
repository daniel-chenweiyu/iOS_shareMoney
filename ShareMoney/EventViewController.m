//
//  EventViewController.m
//  ShareMoney
//
//  Created by Daniel on 2017/2/20.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = self.dateString;
    
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
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    return cell;
    
}

#pragma mark - Btn Action Mehtods

- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)saveBtnPressed:(id)sender {
    
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
