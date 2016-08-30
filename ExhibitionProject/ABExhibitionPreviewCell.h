//
//  ABExhibitionPreviewCell.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/30/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ABExhibitionPreviewCellIdentifier = @"ABExhibitionPreviewCell";

@interface ABExhibitionPreviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *galleryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@end
