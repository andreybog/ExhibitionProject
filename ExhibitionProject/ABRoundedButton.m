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

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawRoundRectangle];
}

- (void) drawRoundRectangle {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect insetRect = CGRectInset(self.bounds, CGRectGetWidth(self.bounds)*0.02, CGRectGetHeight(self.bounds)*0.02);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cornerRadius = CGRectGetHeight(insetRect)/2;
    
    CGPathAddRoundedRect(path, 0, insetRect, cornerRadius, cornerRadius);
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
    CGPathRelease(path);
}

@end

