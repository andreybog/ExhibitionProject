//
//  ABExhibitionsViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/30/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABExhibitionsViewController.h"
#import "EventsManager.h"
#import "Exhibition.h"
#import "ABExhibitionPreviewCell.h"

@interface ABExhibitionsViewController()

@end

@implementation ABExhibitionsViewController

- (void) viewDidLoad {
    [super viewDidLoad];

//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(-50.0, 0, 0, 0);
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
    cell.previewImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:masterPiece.pictureUrl]];
}

#pragma mark - UITableViewDelegate

@end
