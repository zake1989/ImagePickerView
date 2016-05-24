//
//  ImagePickerCell.m
//  ImagePickerView
//
//  Created by Stephen on 7/22/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

#import "ImagePickerCell.h"

@implementation ImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.image.layer.cornerRadius = 4;
    self.image.layer.masksToBounds = YES;
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 8, 23, 23)];
    self.numberLabel.font = [UIFont systemFontOfSize:16];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.image];
    [self addSubview:self.numberLabel];
    
    self.image.backgroundColor = [UIColor clearColor];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    return self;
}

@end
