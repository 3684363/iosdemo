//
//  VideoPlayer.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import "VideoPlayer.h"
#import "AFHTTPSessionManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface VideoPlayer ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate,  AVAssetResourceLoaderDelegate>

@property (nonatomic ,strong) NSURL                *sourceURL;              //视频路径
@property (nonatomic ,strong) NSString             *sourceScheme;           //路径Scheme
@property (nonatomic ,strong) AVURLAsset           *urlAsset;               //视频资源


@property (nonatomic, strong) NSMutableData        *data;                   //视频缓冲数据
@property (nonatomic, copy) NSString               *mimeType;               //资源格式
@property (nonatomic, assign) long long            expectedContentLength;   //资源大小

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableArray       *pendingRequests;        //存储AVAssetResourceLoadingRequest的数组


@end

@implementation VideoPlayer

- (instancetype)initWithFrame:(CGRect)frame videoWithUrl:(NSString *)videoUrl width:(NSNumber *)width height:(NSNumber *)height {
    self = [super initWithFrame:frame];
    if (self) {
        //[self stopToPlay];
        
        /*NSURL *videoURL = [NSURL URLWithString:videoUrl];
        
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        
        _videoItem = [AVPlayerItem playerItemWithAsset:asset];
        [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //CMTime duration = _videoItem.duration;
        //CGFloat videoDuration = CMTimeGetSeconds(duration);
        
        _avPlayer = [AVPlayer playerWithPlayerItem:_videoItem];
        [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            NSLog(@"播放进度： %f",CMTimeGetSeconds(time));
            NSLog(@"url: %@",videoUrl);
        }];*/
        _pendingRequests = [NSMutableArray array];
        
        [self setPlayeWithUrl:videoUrl];
        
        [self addSubvlayerwidth:width height:height];
        
        //NSNotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)setPlayeWithUrl:(NSString *)videoUrl {
    //播放路径
    _sourceURL = [NSURL URLWithString:videoUrl];
    //获取路径schema
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.sourceURL resolvingAgainstBaseURL:NO];
    self.sourceScheme = components.scheme;
    //将视频的网络路径的scheme改为其他自定义的scheme类型，http、https这类预留的scheme类型不能使用
    components.scheme = @"streaming";
    _sourceURL = components.URL;
    
    //初始化AVURLAsset
    _urlAsset = [AVURLAsset URLAssetWithURL:_sourceURL options:nil];
    //设置AVAssetResourceLoaderDelegate代理
    [_urlAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    //初始化_videoItem
    _videoItem = [AVPlayerItem playerItemWithAsset:_urlAsset];
    [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //初始化Avplayer
    _avPlayer = [AVPlayer playerWithPlayerItem:_videoItem];
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放进度： %f",CMTimeGetSeconds(time));
        NSLog(@"url: %@",videoUrl);
    }];
    
    
}

- (void)addSubvlayerwidth:(NSNumber *)width height:(NSNumber *)height{
    
    // 获取屏幕宽度和高度
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // 计算视频的宽高比
    CGFloat videoWidth = [width floatValue]; // 假设视频宽度为16
    CGFloat videoHeight = [height floatValue]; // 假设视频高度为9
    CGFloat videoAspectRatio = videoWidth / videoHeight;
    
    // 根据视频宽高比和屏幕宽度计算视频应该显示的高度
    CGFloat videoHeightToShow = screenWidth / videoAspectRatio;
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame = CGRectMake(0, (screenHeight - videoHeightToShow) / 2, screenWidth, videoHeightToShow);
    [self.layer addSublayer:_playerLayer];
}

- (void)pause{
    [[AVPlayerManager shareManager] pause:_avPlayer];
}

- (void)play{
    
    [[AVPlayerManager shareManager] play:_avPlayer];
}

- (void)replay {
    [[AVPlayerManager shareManager] replay:_avPlayer];
}

- (void)handlePlayEnd{
    [self replay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"status"]){
        if (((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerItemStatusReadyToPlay) {
            [_playerLayer setHidden:NO];
            [self play];
            
        }else {
            NSLog(@" ");
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSLog(@"缓冲： %@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_playerLayer removeFromSuperlayer];
    
    [_videoItem removeObserver:self forKeyPath:@"status"];
    [_videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _videoItem = nil;
    
    _avPlayer = nil;
}

//开始视频资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground {
    if(_dataTask != nil) {
        [_dataTask cancel];
    }
    self.data = [NSMutableData data];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:operationQueue];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    _dataTask = [session dataTaskWithRequest:request];
    
    [_dataTask resume];
    
}

#pragma NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"didReceiveResponse");
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    self.mimeType = httpResponse.MIMEType;
    self.expectedContentLength = httpResponse.expectedContentLength;
    // 继续接收数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [self.data appendData:data];
    // 处理视频数据加载请求
    [self processPendingRequests];
}

#pragma AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"shouldWaitForLoadingOfRequestedResource");
    //创建用于下载视频源的NSURLSessionDataTask，当前方法会多次调用，所以需判断self.task == nil
    if(_dataTask == nil) {
        //将当前的请求路径的scheme换成https，进行普通的网络请求
        NSURL *originalURL = loadingRequest.request.URL;
        NSURLComponents *components = [NSURLComponents componentsWithURL:originalURL resolvingAgainstBaseURL:NO];
        components.scheme = _sourceScheme;
        NSURL *URL = components.URL;
        
        [self startDownloadTask:URL isBackground:YES];
    }
    //将视频加载请求依此存储到pendingRequests中，因为当前方法会多次调用，所以需用数组缓存
    [_pendingRequests addObject:loadingRequest];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //AVAssetResourceLoadingRequest请求被取消，移除视频加载请求
    [_pendingRequests removeObject:loadingRequest];
}


- (void)processPendingRequests {
    NSLog(@"processPendingRequests");
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    //获取所有已完成AVAssetResourceLoadingRequest
    [_pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * stop) {
        //判断AVAssetResourceLoadingRequest是否完成
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest];
        //结束AVAssetResourceLoadingRequest
        if (didRespondCompletely){
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }];
    //移除所有已完成AVAssetResourceLoadingRequest
    [self.pendingRequests removeObjectsInArray:requestsCompleted];
}


- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //设置AVAssetResourceLoadingRequest的类型、支持断点下载、内容大小
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(UTTagClassMIMEType, (__bridge CFStringRef)(_mimeType), NULL);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.contentLength = _expectedContentLength;
    
    //AVAssetResourceLoadingRequest请求偏移量
    long long startOffset = loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        startOffset = loadingRequest.dataRequest.currentOffset;
    }
    //判断当前缓存数据量是否大于请求偏移量
    if (_data.length < startOffset) {
        return NO;
    }
    //计算还未装载到缓存数据
    NSUInteger unreadBytes = _data.length - (NSUInteger)startOffset;
    //判断当前请求到的数据大小
    NSUInteger numberOfBytesToRespondWidth = MIN((NSUInteger)loadingRequest.dataRequest.requestedLength, unreadBytes);
    //将缓存数据的指定片段装载到视频加载请求中
    [loadingRequest.dataRequest respondWithData:[_data subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWidth)]];
    //计算装载完毕后的数据偏移量
    long long endOffset = startOffset + loadingRequest.dataRequest.requestedLength;
    //判断请求是否完成
    BOOL didRespondFully = _data.length >= endOffset;
    
    return didRespondFully;
}
@end
