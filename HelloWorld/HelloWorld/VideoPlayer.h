//
//  VideoPlayer.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"
#import "UIKit/UIKit.h"
#import "AVPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayer : UIView

@property(nonatomic, strong, readwrite) AVPlayerItem *videoItem;

@property(nonatomic, strong, readwrite) AVPlayer *avPlayer;

@property(nonatomic, strong, readwrite) AVPlayerLayer *playerLayer;

- (instancetype)initWithFrame:(CGRect)frame videoWithUrl:(NSString *)videoUrl width:(NSNumber *)width height:(NSNumber *)height;

- (void)addSubvlayerwidth:(NSNumber *)width height:(NSNumber *)height;

- (void)setPlayeWithUrl:(NSString *)videoUrl;

- (void)pause;

- (void)play;

- (void)replay;

@end

NS_ASSUME_NONNULL_END
