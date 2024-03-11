//
//  PexelsLoader.h
//  HelloWorld
//
//  Created by huwenqiang on 2024/3/6.//多个空格？
//

#import <Foundation/Foundation.h>

typedef void(^PexelsLoaderFinishBlock)(BOOL success,NSArray *_Nullable urlArray);

NS_ASSUME_NONNULL_BEGIN

@interface PexelsLoader : NSObject

@property(nonatomic,copy,readwrite)NSString *next_page_url; //这里详细看下为什么？

- (void)loadListDataWithFinishBlock:(NSString *) searchstring finishblock:(PexelsLoaderFinishBlock)finishblock;

-(void)loadListDataWithButtonClick:(PexelsLoaderFinishBlock)finishblock;

-(void)loadListDataWithNextPageURL:(PexelsLoaderFinishBlock)finishblock;

@end

NS_ASSUME_NONNULL_END
