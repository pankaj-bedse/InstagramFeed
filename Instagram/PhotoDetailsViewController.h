//
//  PhotoDetailsViewController.h
//  Instagram
//
//  Created by Pankaj Bedse on 9/14/15.
//  Copyright (c) 2015 Pankaj Bedse. All rights reserved.
//

#import "ViewController.h"

@interface PhotoDetailsViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)setData:(NSDictionary *)data;
@end
