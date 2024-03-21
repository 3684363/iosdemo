//
//  AVPlayerManager.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/13.
//

#import "AVPlayerManager.h"

@implementation AVPlayerManager

+ (AVPlayerManager *)shareManager {
    static dispatch_once_t once;
    static AVPlayerManager *manager;
    dispatch_once(&once, ^{
        manager = [AVPlayerManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _playerArray = [NSMutableArray array];
    }
    return self;
}

/*遍历 _playerArray 中的每个 AVPlayer 对象，暂停它们的播放。
如果 _playerArray 中不包含传入的 player 对象，则将其添加到数组中。
开始播放传入的 player 对象。*/

- (void)play:(AVPlayer *)player {
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer *obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if(![_playerArray containsObject:player]) {
        [_playerArray addObject:player];
    }
    [player play];
}

//如果 _playerArray 中包含传入的 player 对象，则暂停该对象的播放
- (void)pause:(AVPlayer *)player {
    if([_playerArray containsObject:player]) {
        [player pause];
    }
}

//遍历 _playerArray 中的每个 AVPlayer 对象，暂停它们的播放
- (void)pauseAll {
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
}

/*遍历 _playerArray 中的每个 AVPlayer 对象，暂停它们的播放。
 如果 _playerArray 中包含传入的 player 对象：将该 player 对象的播放位置设置为开始处。调用 play: 方法开始播放该 player 对象。
 如果 _playerArray 中不包含传入的 player 对象：将传入的 player 对象添加到数组中。调用 play: 方法开始播放该 player 对象*/
- (void)replay:(AVPlayer *)player {
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if([_playerArray containsObject:player]) {
        [player seekToTime:kCMTimeZero];
        [self play:player];
    }else {
        [_playerArray addObject:player];
        [self play:player];
    }
}

//移除 _playerArray 中的所有 AVPlayer 对象。
- (void)removeAllPlayers {
    [_playerArray removeAllObjects];
}


@end
