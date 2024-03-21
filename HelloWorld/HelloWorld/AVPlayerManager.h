//
//  AVPlayerManager.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"
NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerManager : NSObject

@property (nonatomic, strong) NSMutableArray<AVPlayer *> *playerArray;  //用于存储AVPlayer的数组

+ (AVPlayerManager *)shareManager;

- (void)play:(AVPlayer *)player;

- (void)pause:(AVPlayer *)player;

- (void)pauseAll;

- (void)replay:(AVPlayer *)player;

- (void)removeAllPlayers;

@end

NS_ASSUME_NONNULL_END
