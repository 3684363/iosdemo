//
//  PictureViewController.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/5.
//

#import "PictureViewController.h"
#import "PictureViewCell.h"
#import "MJRefresh.h"
#import "LMHWaterFallLayout.h"

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,LMHWaterFallLayoutDeleaget>

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    
    //初始化self.urlarray
    self.urlArray = [NSMutableArray array];
    self.widthArray = [NSMutableArray array];
    self.heightArray = [NSMutableArray array];
    
    
    //pexelsLoader
    self.pexelsLoader=[[PexelsLoader alloc] init];
    [self.pexelsLoader loadListDataWithFinishBlock:@"food" finishblock:^(BOOL success, NSArray * _Nullable urlArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
        [self.urlArray setArray:urlArray];
        [self.widthArray setArray:WidthArray];
        [self.heightArray setArray:HeightArray];
        [self.collectionView reloadData];
    }];
   
    
    //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;[self.view addSubview:self.collectionView];
    
    
    //searchBar
    self.searchBar=[[SearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 100)];
    self.searchBar.textField.delegate = self;
    [self.view addSubview:_searchBar];
    
    
    //UIButton
    [self.view addSubview:({
        self.button=[[UIButton alloc] initWithFrame:CGRectMake(10, 50, 50, 20)];
        [self.button setTitle:@"pop" forState:UIControlStateNormal];
        [self.button setTitle:@"搜索" forState:UIControlStateHighlighted];
        [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        self.button.backgroundColor=[UIColor blueColor];
        self.button;
    })];
    
    
    //mjrefresh
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UICollectionView *)collectionView{
    if(!_collectionView){
        
//        CustomCollectionViewFlowLayout *flowLayout = [[CustomCollectionViewFlowLayout alloc] init];
//        [flowLayout flowLayoutWithItemWidth:(self.view.frame.size.width-10)/2 itemWidthArray:_widthArray itemHeightArray:_heightArray];
//        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumInteritemSpacing = 10; // 设置每个 cell 之间的水平间距
//        flowLayout.minimumLineSpacing = 10; // 设置每个 cell 之间的垂直间距
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.headerReferenceSize = CGSizeZero;
//        flowLayout.footerReferenceSize = CGSizeZero;
        
        LMHWaterFallLayout *flowLayout = [[LMHWaterFallLayout alloc] init];
        flowLayout.delegate = self;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = CGRectGetWidth(screenBounds);
        CGFloat screenHeight = CGRectGetHeight(screenBounds);
        CGFloat collectionViewHeight = screenHeight * 0.9;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, screenHeight - collectionViewHeight,screenWidth,collectionViewHeight)                                                collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[PictureViewCell class] forCellWithReuseIdentifier:@"PictureViewCell"];
        //_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}


#pragma mark    - *** <UICollectionViewDataSource,UICollectionViewDelegat> ***

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.urlArray.count != 0) {
        return self.urlArray.count;
    } else {
        return 0;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureViewCell" forIndexPath:indexPath];
    //NSLog(@"self.urlArray: %@", self.urlArray);
    [cell layoutPictureViewCell:[self.urlArray objectAtIndex:indexPath.row]
                          width:[_widthArray objectAtIndex:indexPath.row]
                         height:[_heightArray objectAtIndex:indexPath.row]
    ];
    //cell.backgroundColor= [UIColor redColor];
    return cell;
}



#pragma mark     - *** <LMHWaterFallLayoutDeleaget> ***

- (CGFloat)waterFallLayout:(LMHWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    // 计算图片的宽高比
    CGFloat videoWidth = [[self.widthArray objectAtIndex:indexPath]  floatValue];
    CGFloat videoHeight = [[self.heightArray objectAtIndex:indexPath] floatValue];
    CGFloat videoAspectRatio = videoWidth / videoHeight;

    // 根据视频宽高比和屏幕宽度计算视频应该显示的高度
    CGFloat videoHeightToShow = (self.view.frame.size.width-10)/2 / videoAspectRatio;
//    NSLog(@"itemWidth :%f",itemWidth);
    return  videoHeightToShow;
}

#pragma mark    - *** <UICollectionViewDelegateFlowLayout> ***

//cell sizeForItemAtIndexPath
/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 计算图片的宽高比
    CGFloat videoWidth = [[self.widthArray objectAtIndex:indexPath.row]  floatValue];
    CGFloat videoHeight = [[self.heightArray objectAtIndex:indexPath.row] floatValue];
    CGFloat videoAspectRatio = videoWidth / videoHeight;

    // 根据视频宽高比和屏幕宽度计算视频应该显示的高度
    CGFloat videoHeightToShow = (self.view.frame.size.width-10)/2 / videoAspectRatio;
    if(indexPath.row == 6){
        NSLog(@"(self.view.frame.size.width-10)/2: %f",(self.view.frame.size.width-10)/2);
        NSLog(@"videoHeightToShow: %f",videoHeightToShow);
    }
    return CGSizeMake((self.view.frame.size.width-10)/2, videoHeightToShow);
}*/



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
        [self.pexelsLoader loadListDataWithFinishBlock:self.searchBar.userInputString 
                                           finishblock:^(BOOL success, NSArray * _Nullable urlArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray){
                                                [self.urlArray setArray:urlArray];
                                                [self.widthArray setArray:WidthArray];
                                                [self.heightArray setArray:HeightArray];
                                                // indexPathToScroll 表示您要滚动到的单元格的位置，滚动到顶部
                                                NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:0 inSection:0];
                                                // 滚动到指定单元格的顶部
                                                [self.collectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                                                [self.collectionView reloadData];
                                            }];
    }
    return YES;
}

//button点击
-(void)buttonClick{
    [self.pexelsLoader loadListDataWithButtonClick:^(BOOL success, NSArray * _Nullable urlArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
        [self.urlArray setArray:urlArray];
        [self.widthArray setArray:WidthArray];
        [self.heightArray setArray:HeightArray];
        // indexPathToScroll 表示您要滚动到的单元格的位置，滚动到顶部
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:0 inSection:0];
        // 滚动到指定单元格的顶部
        [self.collectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        [self.collectionView reloadData];
    }];
}

//refreshdata
-(void)refreshData {
    [self.pexelsLoader loadListDataWithNextPageURL:^(BOOL success, NSArray * _Nullable urlArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
        [self.urlArray setArray:urlArray];
        [self.widthArray setArray:WidthArray];
        [self.heightArray setArray:HeightArray];
        [self.collectionView reloadData];
        
    }];
    [_collectionView.mj_header endRefreshing];
}

//下滑加载，分页请求
-(void)loadMoreData {
    [self.pexelsLoader loadListDataWithNextPageURL:^(BOOL success, NSArray * _Nullable urlArray, NSArray *_Nullable WidthArray, NSArray *_Nullable HeightArray) {
        [self.urlArray addObjectsFromArray:urlArray];
        [self.widthArray addObjectsFromArray:WidthArray];
        [self.heightArray addObjectsFromArray:HeightArray];
        [self.collectionView reloadData];
    }];
    [_collectionView.mj_footer endRefreshing];
}

@end
