//
//  PictureViewCell.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/5.
//

#import "PictureViewCell.h"
#import <SDWebImage.h>

@implementation PictureViewCell


-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
    }
     
    /*self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]
            ]];*/
    
    return self;
}

-(void)layoutPictureViewCell:(NSString *)urlString width:(NSNumber *)width height:(NSNumber *)height {
    if(!_imageView){
        
        // 计算图片的宽高比
        CGFloat videoWidth = [width floatValue];
        CGFloat videoHeight = [height floatValue];
        CGFloat videoAspectRatio = videoWidth / videoHeight;
        
        // 根据视频宽高比和屏幕宽度计算视频应该显示的高度
        CGFloat videoHeightToShow = self.frame.size.width / videoAspectRatio;
        if( videoHeightToShow<self.frame.size.height ) {
            videoHeightToShow = self.frame.size.height;
        }
        
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - videoHeightToShow) / 2, self.frame.size.width, videoHeightToShow)];
        //self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                                 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        _imageView.layer.cornerRadius = 15;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView removeFromSuperview];
    _imageView = nil;
    NSLog(@"prepareForReuse");
}

@end
