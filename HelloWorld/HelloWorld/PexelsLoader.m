//
//  PexelsLoader.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/6.
//

#import "PexelsLoader.h"
#import <AFNetworking.h>
#import <SDWebImage.h>

@implementation PexelsLoader

-(void)loadListDataWithFinishBlock:(NSString *)searchstring finishblock:(PexelsLoaderFinishBlock)finishblock{
    // 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置 Pexels API 的 base URL
    NSString *baseURL = @"https://api.pexels.com/v1/search";
    //构建 Pexels API 的 完整 URL,拼接查询参数
    NSString *fullURL = [NSString stringWithFormat:@"%@?query=%@&page=1&per_page=20",baseURL,searchstring];
    // 设置 Pexels API 的授权 token
    NSString *apiKey = @"uXVOXxgzi0PgMsxMS6lKFjYs5qRAbXV8aAhjVZ1IrWDCTTXOoNMUNJ28";
    // 设置请求头部，包括授权 token
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", apiKey] forHTTPHeaderField:@"Authorization"];

    // 发起 GET 请求
    NSMutableArray *widths = [NSMutableArray array];
    NSMutableArray *heights = [NSMutableArray array];
    NSMutableArray *urls = [NSMutableArray array];
    [manager GET:fullURL
      parameters:nil
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *photos = responseObject[@"photos"]; // 响应中有一个名为 "photos" 的数组，包含图片信息
                _next_page_url = responseObject[@"next_page"];
                for (NSDictionary *photo in photos) {
                    NSString *photoURLString = photo[@"src"][@"original"]; // 图片信息中有一个名为 "url" 的字段，包含图片的 URL
                    NSNumber *width = photo[@"width"];
                    NSNumber *height = photo[@"height"];
                    //NSURL *photoURL = [NSURL URLWithString:photoURLString];
                    if(photoURLString){
                        [urls addObject:photoURLString];
                        [widths addObject:width];
                        [heights addObject:height];
                    }
                }
                //NSLog(@"count: %lu", urls.count)
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
            if(finishblock){
                finishblock(YES,urls.copy,widths.copy,heights.copy);
            }
            });
            //NSLog(@"Response: %@", responseObject);
        
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"Error: %@", error);
            if (finishblock){
                finishblock(error==nil,nil,nil,nil);
            }
        }];
}

-(void)loadListDataWithButtonClick:(PexelsLoaderFinishBlock)finishblock{
    // 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置 Pexels API 的 base URL
    NSString *baseURL = @"https://api.pexels.com/v1/curated?page=1&per_page=60";
    // 设置 Pexels API 的授权 token
    NSString *apiKey = @"uXVOXxgzi0PgMsxMS6lKFjYs5qRAbXV8aAhjVZ1IrWDCTTXOoNMUNJ28";
    // 设置请求头部，包括授权 token
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", apiKey] forHTTPHeaderField:@"Authorization"];

    // 发起 GET 请求
    NSMutableArray *widths = [NSMutableArray array];
    NSMutableArray *heights = [NSMutableArray array];
    NSMutableArray *urls = [NSMutableArray array];
    [manager GET:baseURL
      parameters:nil
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *photos = responseObject[@"photos"]; // 响应中有一个名为 "photos" 的数组，包含图片信息
                _next_page_url = responseObject[@"next_page"];
                for (NSDictionary *photo in photos) {
                    NSString *photoURLString = photo[@"src"][@"original"]; // 图片信息中有一个名为 "url" 的字段，包含图片的 URL
                    NSNumber *width = photo[@"width"];
                    NSNumber *height = photo[@"height"];
                    if (photoURLString) {
                        [urls addObject:photoURLString];
                        [widths addObject:width];
                        [heights addObject:height];
                    }
                }
                //NSLog(@"count: %lu", urls.count)
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finishblock) {
                    finishblock(YES,urls.copy,widths.copy,heights.copy);
                }
            });
        
            //NSLog(@"Response: %@", responseObject);
        
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"Error: %@", error);
            if  (finishblock)   {
                finishblock(error==nil,nil,nil,nil);
            }
        }];
}

-(void)loadListDataWithNextPageURL:(PexelsLoaderFinishBlock)finishblock {
    // 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置 Pexels API 的 base URL
    NSString *baseURL = _next_page_url;
    // 设置 Pexels API 的授权 token
    NSString *apiKey = @"uXVOXxgzi0PgMsxMS6lKFjYs5qRAbXV8aAhjVZ1IrWDCTTXOoNMUNJ28";
    // 设置请求头部，包括授权 token
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", apiKey] forHTTPHeaderField:@"Authorization"];
    
    // 发起 GET 请求
    NSMutableArray *widths = [NSMutableArray array];
    NSMutableArray *heights = [NSMutableArray array];
    NSMutableArray *urls = [NSMutableArray array];
    [manager GET:baseURL
      parameters:nil
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *photos = responseObject[@"photos"]; // 响应中有一个名为 "photos" 的数组，包含图片信息
                _next_page_url = responseObject[@"next_page"];
                for (NSDictionary *photo in photos) {
                    NSString *photoURLString = photo[@"src"][@"original"]; // 图片信息中有一个名为 "url" 的字段，包含图片的 URL
                    NSNumber *width = photo[@"width"];
                    NSNumber *height = photo[@"height"];
                    if (photoURLString) {
                        [urls addObject:photoURLString];
                        [widths addObject:width];
                        [heights addObject:height];
                    }
                }
                //NSLog(@"count: %lu", urls.count)
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finishblock) {
                    finishblock(YES,urls.copy,widths.copy,heights.copy);
                }
            });
            //NSLog(@"Response: %@", responseObject);
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"Error: %@", error);
            if (finishblock) {
                finishblock(error==nil,nil,nil,nil);
            }
        }];
}

-(void)loadListDataWithVideoSearch:(NSString *)searchstring finishblock:(PexelsLoaderFinishBlockWithVideo)finishblock{
    // 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置 Pexels API 的 base URL
    NSString *baseURL = @"https://api.pexels.com/videos/search";
    //构建 Pexels API 的 完整 URL,拼接查询参数
    NSString *fullURL = [NSString stringWithFormat:@"%@?query=%@&page=1&per_page=20",baseURL,searchstring];
    // 设置 Pexels API 的授权 token
    NSString *apiKey = @"uXVOXxgzi0PgMsxMS6lKFjYs5qRAbXV8aAhjVZ1IrWDCTTXOoNMUNJ28";
    // 设置请求头部，包括授权 token
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", apiKey] forHTTPHeaderField:@"Authorization"];
    
    // 发起 GET 请求
    NSMutableArray *videourls = [NSMutableArray array];
    NSMutableArray *pictureurls = [NSMutableArray array];
    NSMutableArray *widths = [NSMutableArray array];
    NSMutableArray *heights = [NSMutableArray array];
    [manager GET:fullURL
      parameters:nil
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *videos = responseObject[@"videos"]; // 响应中有一个名为 "photos" 的数组，包含videos信息
                _next_page_url = responseObject[@"next_page"];
                for (NSDictionary *video in videos) {
                    //提取videoURL
                    NSArray *videoFiles = video[@"video_files"];
                    
                    NSDictionary *selectedVideoFiles = videoFiles[0];
                    NSString *videourl = selectedVideoFiles[@"link"];
                    NSNumber *width = selectedVideoFiles[@"width"];
                    NSNumber *height = selectedVideoFiles[@"height"];
                    
                    for(NSDictionary *videoFile in videoFiles){
                        NSComparisonResult result = [width compare:videoFile[@"width"]];
                        NSLog(@"result: %ld",result);
                        if(result == NSOrderedDescending){
                            width = videoFile[@"width"];
                            height = videoFile[@"height"];
                            videourl = videoFile[@"link"];
                            NSLog(@"%@, %@, %@ ", width, height, videourl);
                        }
                    }
                    
                    if (videourl) {
                        [videourls addObject:videourl];
                        [widths addObject:width];
                        [heights addObject:height];
                    }
                    //提取pictureURL
                    NSArray *videoPictures = video[@"video_pictures"];
                    NSDictionary *selectedVideoPictures = videoPictures[0];
                    NSString *pictureurl = selectedVideoPictures[@"picture"];
                    if (pictureurl) {
                        [pictureurls addObject:pictureurl];
                    }
                }
            }
            //NSLog(@"count: %lu", urls.count)
            dispatch_async(dispatch_get_main_queue(), ^{
            if(finishblock){
                finishblock(YES,videourls.copy,pictureurls.copy,widths.copy,heights.copy);
            }
            });
            //NSLog(@"Response: %@", responseObject);
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"Error: %@", error);
            if (finishblock){
                finishblock(error==nil,nil,nil,nil,nil);
            }
        }];
}

@end
