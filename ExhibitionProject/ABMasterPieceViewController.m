//
//  ABMasterPieceViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/7/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABMasterPieceViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ABMasterPieceViewController()

@property (weak, nonatomic) IBOutlet UIImageView *masterPieceImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterPieceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation ABMasterPieceViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.authorLabel.text = self.masterPiece.author;
    self.masterPieceTitleLabel.text = self.masterPiece.title;
    self.yearLabel.text = self.masterPiece.year ? nil : [NSString stringWithFormat:@"%ld", self.masterPiece.year];
    self.typeLabel.text = self.masterPiece.type;
    self.sizeLabel.text = self.masterPiece.size;
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.masterPiece.pictureUrl];
    __weak typeof(self) weakSelf = self;
    
    [self.masterPieceImageView setImageWithURLRequest:request
         placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             weakSelf.masterPieceImageView.image = image;
         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             
         }];

}

#pragma mark - Actions

- (IBAction)actionBackButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
