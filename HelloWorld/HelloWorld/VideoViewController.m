//
//  VideoViewController.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import "VideoViewController.h"
#import "VideoViewCell.h"

@interface VideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    //初始化self.urlarray
    self.videosURL = [NSMutableArray array];
    self.picturesURL = [NSMutableArray array];
    self.widthArray = [NSMutableArray array];
    self.heightArray = [NSMutableArray array];

    
    //pexelsLoader
    self.pexelsLoader=[[PexelsLoader alloc] init];
    [self.pexelsLoader loadListDataWithVideoSearch:@"popular" 
                                       finishblock:^(BOOL success, NSArray * _Nullable VideoPlayerURLArray, NSArray * _Nullable VideoPictureURLArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
        [self.videosURL setArray:VideoPlayerURLArray];
        [self.picturesURL setArray:VideoPictureURLArray];
        [self.widthArray setArray:WidthArray];
        [self.heightArray setArray:HeightArray];
        [self.collectionView reloadData];
    }];
    
    //uicollectionview
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing=0;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.headerReferenceSize=CGSizeZero;
    flowLayout.footerReferenceSize=CGSizeZero;
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[VideoViewCell class] forCellWithReuseIdentifier:@"VideoViewCell"];
    self.collectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.collectionView];
    
   
    //searchbar
    self.searchBar=[[SearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.searchBar.textField.delegate = self;
    [self.view addSubview:_searchBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videosURL.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
                                            sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height); // 设置单元格大小为一页的大小
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoViewCell" forIndexPath:indexPath];
    //占位图显示
    //[cell setupWithVideoCoverUrl:[self.videosURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
    //第一个cell播放
    if(indexPath.item==0){
        [cell setupWithVideoCoverUrl:[self.picturesURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
        [cell setupWithVideoUrl:[self.videosURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"willDisplayCell");
    self.willDisplayIndexPath = indexPath;
    if([cell isKindOfClass:[VideoViewCell class]]){
        VideoViewCell *videoViewcell = (VideoViewCell *)cell;
        //占位图显示
        [videoViewcell setupWithVideoCoverUrl:[self.picturesURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
    }
}

/*- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if([cell isKindOfClass:[VideoViewCell class]]){
            VideoViewCell *videoViewcell = (VideoViewCell *)cell;
            if ([indexPath isEqual:self.willDisplayIndexPath]) {
                [videoViewcell setupWithVideoUrl:[self.videosURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
                [videoViewcell hideCoverview];
            } else {
                // 当前屏幕上显示的 cell 播放视频
            }
        }
    }

}*/
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didEndDisplayingCell");
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if([cell isKindOfClass:[VideoViewCell class]]){
            VideoViewCell *videoViewcell = (VideoViewCell *)cell;
            if ([indexPath isEqual:self.willDisplayIndexPath]) {
                [videoViewcell setupWithVideoUrl:[self.videosURL objectAtIndex:indexPath.row] width:[self.widthArray objectAtIndex:indexPath.row] height:[self.heightArray objectAtIndex:indexPath.row]];
                //[videoViewcell hideCoverview];
            } else {
                // 当前屏幕上显示的 cell 播放视频
            }
        }
    }

}

//searchBar
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //获取用户输入的字符串
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //保存用户输入的字符串
    self.searchBar.userInputString=updateString;
    return YES;
}

//textFieldShouldReturn
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //在用户按下return时调用
    if (self.searchBar.userInputString.length > 0) {
        [self.pexelsLoader loadListDataWithVideoSearch:self.searchBar.userInputString
                                           finishblock:^(BOOL success, NSArray * _Nullable VideoPlayerURLArray, NSArray * _Nullable VideoPictureURLArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
                                                [self.videosURL setArray:VideoPlayerURLArray];
                                                [self.picturesURL setArray:VideoPictureURLArray];
                                                [self.widthArray setArray:WidthArray];
                                                [self.heightArray setArray:HeightArray];
                                                [self.collectionView reloadData];
                                                // indexPathToScroll 表示您要滚动到的单元格的位置，滚动到顶部
                                                NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:0 inSection:0];
                                                // 滚动到指定单元格的顶部
                                                [self.collectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                                                [self.collectionView reloadData];
        }];
    }
    return YES;
}

@end
