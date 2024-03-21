//
//  PexelsLoader.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/6.
//

#import <Foundation/Foundation.h>

typedef void(^PexelsLoaderFinishBlock)(BOOL success,NSArray *_Nullable urlArray,NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray);

typedef void(^PexelsLoaderFinishBlockWithVideo)(BOOL success, NSArray *_Nullable VideoPlayerURLArray, NSArray *_Nullable VideoPictureURLArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray);

NS_ASSUME_NONNULL_BEGIN

@interface PexelsLoader : NSObject

@property(nonatomic,strong,readwrite)NSString *next_page_url;

-(void)loadListDataWithFinishBlock:(NSString *) searchstring finishblock:(PexelsLoaderFinishBlock)finishblock;

-(void)loadListDataWithButtonClick:(PexelsLoaderFinishBlock)finishblock;

-(void)loadListDataWithNextPageURL:(PexelsLoaderFinishBlock)finishblock;

-(void)loadListDataWithVideoSearch:(NSString *)searchstring finishblock:(PexelsLoaderFinishBlockWithVideo)finishblock;

@end

NS_ASSUME_NONNULL_END
