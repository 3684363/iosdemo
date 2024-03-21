//
//  VideoViewCell.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import "VideoViewCell.h"
#import "AVFoundation/AVFoundation.h"
#import <SDWebImage.h>

@implementation VideoViewCell

- (void)setupWithVideoUrl:(NSString *)videoUrl width:(NSNumber *)width height:(NSNumber *)height {
    _videoUrl = videoUrl;
    if (_videoPlayer) {
        [_videoPlayer removeFromSuperview];
        _videoPlayer = nil;
    }
    _videoPlayer = [[VideoPlayer alloc] initWithFrame:self.bounds videoWithUrl:videoUrl width:width height:height];
    //self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.videoPlayer];
    
}

- (void)setupWithVideoCoverUrl:videoCoverUrl width:(NSNumber *)width height:(NSNumber *)height{
    if(!_imageView){
        // 获取屏幕宽度和高度
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        // 计算视频的宽高比
        CGFloat videoWidth = [width floatValue];
        CGFloat videoHeight = [height floatValue];
        CGFloat videoAspectRatio = videoWidth / videoHeight;
        
        // 根据视频宽高比和屏幕宽度计算视频应该显示的高度
        CGFloat videoHeightToShow = screenWidth / videoAspectRatio;
        
        _videoCoverUrl = videoCoverUrl;
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, (screenHeight - videoHeightToShow) / 2, screenWidth, videoHeightToShow)];
        [self addSubview:self.imageView];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoCoverUrl]
                                 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        NSLog(@"self.imageView : %@",NSStringFromCGRect(self.imageView.frame));
        NSLog(@"videoCoverUrl: %@",videoCoverUrl);
    }
    //self.imageView.backgroundColor=[UIColor redColor];
    
}

- (void)hideCoverview{
    [_imageView setHidden:YES];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_videoPlayer pause];
    [_videoPlayer.playerLayer setHidden:YES];
    [self.imageView removeFromSuperview];
    _imageView = nil;
    NSLog(@"prepareForReuse");
}

- (void)play {
    [_videoPlayer play];
}

- (void)pause {
    [_videoPlayer pause];
}

- (void)replay {
    [_videoPlayer replay];
}

@end
