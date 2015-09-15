//
//  PhotosViewController.m
//  
//
//  Created by Pankaj Bedse on 9/14/15.
//
//

#import "PhotosViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MyTableViewCell.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController ()
@property (nonatomic, strong) NSDictionary *responseDictionary;
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation PhotosViewController


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.title = @"Instagram";
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 320;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=d637fa1aea1642f8bcf5f2a70869d68e"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        self.responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.myArray = self.responseDictionary[@"data"];
        [self.tableView reloadData];
        
        NSLog(@"response: %@", self.responseDictionary[@"data"]);
    }];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //UITableView *tableView = [[UITableView alloc] init];
    
}

- (void)onRefresh {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=d637fa1aea1642f8bcf5f2a70869d68e"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", (long)indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.table.cell" forIndexPath:indexPath];
    
    NSString *url = self.responseDictionary[@"data"][indexPath.section][@"images"][@"low_resolution"][@"url"];
    
    [cell.myImageView setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"I am here");
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PhotoDetailsViewController *photoDetailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [photoDetailsViewController setData:self.responseDictionary[@"data"][indexPath.section][@"images"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.responseDictionary[@"data"] count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    UITextView *userName = [[UITextView alloc]initWithFrame:CGRectMake(40, 10, 150, 30)];
    userName.text = self.responseDictionary[@"data"][section][@"user"][@"username"];
    NSString *url = self.responseDictionary[@"data"][section][@"user"][@"profile_picture"];
    // Use the section number to get the right URL
    [profileView setImageWithURL:[NSURL URLWithString:url]];
    
    
    [headerView addSubview:profileView];
    [headerView addSubview:userName];
    // Add a UILabel for the username here
    
    return headerView;
}
@end
