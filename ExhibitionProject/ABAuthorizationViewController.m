//
//  ABAuthorizationViewController.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/30/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABAuthorizationViewController.h"
#import "ABExhibitionsViewController.h"

@implementation ABAuthorizationViewController

#pragma mark - Actions


- (IBAction)actionLoginLaterButton:(UIButton *)sender {
    ABExhibitionsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABExhibitionsViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
