//
//  PhotoDetailsViewController.m
//  Instagram
//
//  Created by Pankaj Bedse on 9/14/15.
//  Copyright (c) 2015 Pankaj Bedse. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "MyDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property NSDictionary *data;
@property NSIndexPath *selectedIndex;
@end


@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"I am here");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.table.detail.cell" forIndexPath:indexPath];
    
    NSString *url = self.data[@"low_resolution"][@"url"];
    [cell.myDetailImage setImageWithURL:[NSURL URLWithString:url]];
    //[cell.myDetailImage setImageWithURL:[NSURL URLWithString:url]];
    return cell;
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
