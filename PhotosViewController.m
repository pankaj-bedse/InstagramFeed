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
    return [self.responseDictionary[@"data"] count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", (long)indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.table.cell" forIndexPath:indexPath];
    
    NSString *url = self.responseDictionary[@"data"][indexPath.row][@"images"][@"low_resolution"][@"url"];
    
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
    [photoDetailsViewController setData:self.responseDictionary[@"data"][indexPath.row][@"images"]];
}

@end
