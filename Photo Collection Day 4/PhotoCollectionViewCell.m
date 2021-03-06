//
//  PhotoCollectionViewCell.m
//  Photo Collection Day 4
//
//  Created by 123 on 17/06/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoControler.h"





@implementation PhotoCollectionViewCell

-(instancetype) initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    if (self) {
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
    
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit; 
    self.imageView.frame=self.contentView.bounds;
    
}

-(void)setPhoto:(NSDictionary *)photo
{

    _photo=photo;
    
    [PhotoControler imageForPhoto:self.photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image =image;
    }];
    
    
}



@end
