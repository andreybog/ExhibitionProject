//
//  ABAuthorizationViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/30/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABAuthorizationViewController.h"
#import "ABExhibitionsViewController.h"

@interface ABAuthorizationViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginLaterButton;
@property (weak, nonatomic) IBOutlet UIPageControl *picturesPageControl;


@end

@implementation ABAuthorizationViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupButtons];
}

#pragma mark - UI setup

- (void) setupButtons {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.loginLaterButton.currentAttributedTitle];
    
    [attrString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attrString.length)];
    [self.loginLaterButton setAttributedTitle: attrString
                                     forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)actionLoginLaterButton:(UIButton *)sender {
    ABExhibitionsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABExhibitionsViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.picturesPageControl.currentPage = (int)(scrollView.contentOffset.x / CGRectGetWidth(self.view.bounds));
}



@end
