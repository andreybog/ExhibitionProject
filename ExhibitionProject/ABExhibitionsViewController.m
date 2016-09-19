//
//  ABExhibitionsViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/30/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABExhibitionsViewController.h"
#import "ABExhibitionInfoViewController.h"
#import "EventsManager.h"
#import "Exhibition.h"
#import "ABExhibitionPreviewCell.h"
#import "ABRoundedButton.h"
#import "UIImageView+AFNetworking.h"

@interface ABExhibitionsViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ABRoundedButton *filterButton;
@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
@property (strong, nonatomic) UIImage *navigationBarShadowImage;
@property (assign, nonatomic, getter=isEventsLoading) BOOL eventsLoading;

@end

@implementation ABExhibitionsViewController

#pragma mark - ViewController life cycle

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // transparent navigation bar
    self.navigationBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    self.navigationBarShadowImage = [self.navigationController.navigationBar shadowImage];
   
    [self.filterButton setTitle:@"Near me" forState:UIControlStateNormal];
    [self loadEvents];
}

- (void) loadEvents {
    self.eventsLoading = YES;
    
    [[EventsManager sharedEventsManager] loadEventsWithOption:ABEventsOptionFilterAll
        onSuccess:^(NSArray *array) {
            int eventsArrayCount = (int)[EventsManager sharedEventsManager].events.count;
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:array.count];
            
            for ( int i = eventsArrayCount - (int)array.count; i < eventsArrayCount; i++ ) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            self.eventsLoading = NO;
            
            NSLog(@"updateTable");
        } onFailure:^(NSError *error) {
            NSLog(@"func: loadEvents ERROR: %@", [error localizedDescription]);
            self.eventsLoading = NO;
        }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setupNavigationBarTransperancy:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBarTransperancy:YES];
}

- (void) setupNavigationBarTransperancy:(BOOL)transperant {
    if ( transperant ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = self.navigationBarShadowImage;
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [EventsManager sharedEventsManager].events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Exhibition *exhibition = (Exhibition *)[[EventsManager sharedEventsManager].events objectAtIndex:indexPath.row];
    ABExhibitionPreviewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ABExhibitionPreviewCellIdentifier];
    
    [self configureCell:cell withExhibition:exhibition];
    
    return cell;
}

- (void) configureCell:(ABExhibitionPreviewCell *)cell withExhibition:(Exhibition *)exhibition {
    cell.galleryTitleLabel.text = exhibition.venue.title;
    cell.exhibitionTitleLabel.text = exhibition.title;
    cell.authorLabel.text = exhibition.author;
    cell.distanceLabel.text = @"1 km";
    
    MasterPiece *masterPiece = [exhibition.masterPieces firstObject];

    cell.previewImage.image = nil;
    
    __weak typeof(cell) weakCell = cell;
    NSURLRequest *request = [NSURLRequest requestWithURL:masterPiece.pictureUrl];
    [cell.previewImage setImageWithURLRequest:request
                             placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                 weakCell.previewImage.image = image;
                                 [weakCell layoutSubviews];
                             } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 
                             }];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Exhibition *exhibition = (Exhibition *)[[EventsManager sharedEventsManager].events objectAtIndex:indexPath.row];
    ABExhibitionInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABExhibitionInfoViewController"];
    
    vc.exhibition = exhibition;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (IBAction)actionFilterButtonTouched:(UIButton *)sender {
    NSString *title = @"Near me";
    
    if ( [sender.currentTitle isEqualToString:@"Near me"] ) {
        title = @"Some long long title";
    }
    [sender setTitle:title forState:UIControlStateNormal];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds) == scrollView.contentSize.height &&
        !self.isEventsLoading ) {
        [self loadEvents];
    }
}
@end
