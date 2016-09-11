//
//  ABMasterPieceViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/7/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABMasterPieceViewController.h"

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
    self.yearLabel.text = self.masterPiece.year ? nil : [NSString stringWithFormat:@"%d", self.masterPiece.year];
    self.typeLabel.text = self.masterPiece.type;
    self.sizeLabel.text = self.masterPiece.size;
    self.masterPieceImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.masterPiece.pictureUrl]];
}

#pragma mark - Actions

- (IBAction)actionBackButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
