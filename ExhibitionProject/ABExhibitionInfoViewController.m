//
//  ABExhibitionInfoViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/1/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABExhibitionInfoViewController.h"
#import "ABMasterPieceCollectionViewCell.h"
#import "ABMasterPieceViewController.h"
#import "Gallery.h"
#import "NSDate+NSString.h"
#import "UIImageView+AFNetworking.h"

static CGFloat const kGalleryInfoViewHeight = 250.0;

@interface ABExhibitionInfoViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *exhibitionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitionAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitionPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitionAboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitionAuthorDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView    *galleryLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel        *galleryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryLinkLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryFacebookLabel;
@property (weak, nonatomic) IBOutlet UILabel        *galleryDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *galleryInfoView;

@property (weak, nonatomic) IBOutlet UIButton *showGalleryInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *masterPiecesCollectionViewHieghtConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *galleryInfoViewHeightConstraint;

@property (assign, nonatomic, getter=isGalleryInfoShown) BOOL galleryInfoShown;

@end

@implementation ABExhibitionInfoViewController

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( ! self.exhibition.masterPieces.count ) {
        self.masterPiecesCollectionViewHieghtConstraint.constant = 0;
    }
    
    self.galleryInfoShown = NO;
    [self galleryInfoShow:NO animation:NO]; 
    
    [self setupLabels];
}

#pragma mark - UI setup

- (void) setupLabels {
    Gallery *gallery = (Gallery *)self.exhibition.venue;
    Exhibition *exhibition = self.exhibition;
    
    self.exhibitionTitleLabel.text = exhibition.title;
    self.exhibitionAuthorLabel.text = exhibition.author;
 
    NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"About\n\n%@", exhibition.about]];
    [tempString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size: 14.0]}
                         range:[tempString.string rangeOfString:@"About"]];
    self.exhibitionAboutLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:tempString];
    
    tempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"The Artist\n\n%@",exhibition.authorDescription]];
    [tempString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size: 14.0]}
                        range:[tempString.string rangeOfString:@"The Artist"]];
    self.exhibitionAuthorDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:tempString];

    self.exhibitionPeriodLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                       [exhibition.dateStart stringWithFormat:@"dd.MM.yy"],
                                       [exhibition.dateEnd stringWithFormat:@"dd.MM.yy"]];
    
    self.galleryTitleLabel.text = gallery.title;
    self.galleryLinkLabel.text =  [gallery.linkUrl absoluteString];
    self.galleryAddressLabel.text = gallery.address;
    self.galleryFacebookLabel.text = gallery.facebook;
    self.galleryPhoneLabel.text = gallery.phone;
    
    if (gallery.logoUrl) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:gallery.logoUrl];
        
        __weak typeof(self) weakSelf = self;
        
        [self.galleryLogoImageView setImageWithURLRequest:request
                                         placeholderImage:nil
                                                  success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                      weakSelf.galleryLogoImageView.image = image;
                                                  } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                      
                                                  }];
        
    } else {
        self.galleryLogoImageView.image = nil;
    }
    
    self.galleryScheduleLabel.text = [gallery.schedule componentsJoinedByString:@"\n"];
    self.galleryDescriptionLabel.text = gallery.about;
}

- (void) galleryInfoShow:(BOOL) show animation:(BOOL)animation {
    self.galleryInfoViewHeightConstraint.constant = show ? kGalleryInfoViewHeight : 0;
    
    if (show) {
        self.galleryInfoView.hidden = NO;
    }
    
    if ( animation ) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (!show) {
                self.galleryInfoView.hidden = YES;
            }
        }];
    } else if ( !show ) {
        self.galleryInfoView.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)actionBackButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShowGalleryInfoButtonPressed:(UIButton *)sender {
    self.galleryInfoShown = !self.isGalleryInfoShown;
    
    [self galleryInfoShow:self.isGalleryInfoShown animation:YES];
    
    CGAffineTransform transform = self.isGalleryInfoShown ? CGAffineTransformMakeRotation(3.14) : CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.showGalleryInfoButton.transform = transform;
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.exhibition.masterPieces.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ABMasterPieceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABMasterPieceCollectionViewCellIdentifier forIndexPath:indexPath];
    MasterPiece *masterPiece = [self.exhibition.masterPieces objectAtIndex:indexPath.row];
    __weak typeof(cell) weakCell = cell;
    
    cell.imageView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:masterPiece.pictureUrl];
    
    [cell.imageView setImageWithURLRequest:request
      placeholderImage:nil
               success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                   weakCell.imageView.image = image;
                   [weakCell layoutSubviews];
               } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                   
               }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MasterPiece *masterPiece = [self.exhibition.masterPieces objectAtIndex:indexPath.row];
    ABMasterPieceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABMasterPieceViewController"];
    
    vc.masterPiece = masterPiece;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
