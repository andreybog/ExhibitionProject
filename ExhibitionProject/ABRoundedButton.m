//
//  ABButton.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/1/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABRoundedButton.h"

@implementation ABRoundedButton


#pragma mark - Properties

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drawRectangleBorders];
}

- (void) drawRectangleBorders {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2.0;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void) setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat strikeWidth = textSize.width;
    CGRect rect = self.superview.bounds;
    rect.size.width = strikeWidth + 70;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 42);
    
    [self.superview setBounds:rect];
    [self setNeedsDisplay];
    
}

@end

