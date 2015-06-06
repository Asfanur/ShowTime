//
//  BlurredBackgroundView.m
//  ShowTime
//
//  Created by Asfanur Arafin on 6/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "BlurredBackgroundView.h"
@interface BlurredBackgroundView()
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation BlurredBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
        [self addSubview:_imageView];
        [self addSubview:_blurView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initWithFrame:CGRectZero];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.blurView.frame = self.bounds;
}

 
@end
