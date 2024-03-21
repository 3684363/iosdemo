//
//  VideoViewCell.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import <UIKit/UIKit.h>
#import "VideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) NSString *videoCoverUrl;

@property (nonatomic, strong, readwrite) NSString *videoUrl;

@property (nonatomic, strong, readwrite) VideoPlayer *videoPlayer;

@property (nonatomic, strong, readwrite) UIImageView *imageView;


- (void)setupWithVideoUrl:(NSString *)videoUrl width:(NSNumber *)width height:(NSNumber *)height;

- (void)setupWithVideoCoverUrl:videoCoverUrl width:(NSNumber *)width height:(NSNumber *)height;

- (void)hideCoverview;

- (void)play;

- (void)pause;

- (void)replay;

@end

NS_ASSUME_NONNULL_END
