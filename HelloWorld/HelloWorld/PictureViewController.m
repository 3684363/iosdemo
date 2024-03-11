//
//  PictureViewController.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/5.
//

#import "PictureViewController.h"
#import "PictureViewCell.h"
#import "MJRefresh.h"

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    // self.pexelsLoader self.collectionView self.searchBar 建议用懒加载
    //多余空格都删除
    //初始化self.urlarray
    self.urlsArray = [NSMutableArray array];
    
    
    //pexelsLoader
    self.pexelsLoader=[[PexelsLoader alloc] init];
    [self.pexelsLoader loadListDataWithFinishBlock:@"food" finishblock:^(BOOL success, NSArray * _Nullable urlArray) {
        [self.urlArray setArray:urlArray];
        [self.collectionView reloadData];
    }];
    
    
    //collectionview
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.itemSize=CGSizeMake((self.view.frame.size.width-10)/2, 300);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenBounds);
    CGFloat screenHeight = CGRectGetHeight(screenBounds);
    CGFloat collectionViewHeight = screenHeight * 0.9;

    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, screenHeight - collectionViewHeight, screenWidth,collectionViewHeight)                                                collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[PictureViewCell class] forCellWithReuseIdentifier:@"PictureViewCell"];//PictureViewCell 建议用静态常量表示
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    
    
    //searchBar
    self.searchBar=[[SearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
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
//无用方法删除
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.urlArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureViewCell" forIndexPath:indexPath];
    //cell.backgroundColor=[UIColor redColor];
    //NSLog(@"self.urlArray: %@", self.urlArray);
    [cell layoutPictureViewCell:[self.urlArray objectAtIndex:indexPath.row]];
    return cell;
}

//cell sizeForItemAtIndexPath
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
                                            sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item%3==0) {
        return CGSizeMake((self.view.frame.size.width-10)/2, 250);
    } else {
        return CGSizeMake((self.view.frame.size.width-10)/2, 300);
    }
}

//searchBar
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //多余空格
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
                                           finishblock:^(BOOL success, NSArray * _Nullable urlArray){
                                                [self.urlArray setArray:urlArray];
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
    [self.pexelsLoader loadListDataWithButtonClick:^(BOOL success, NSArray * _Nullable urlArray) {
        [self.urlArray setArray:urlArray];
        // indexPathToScroll 表示您要滚动到的单元格的位置，滚动到顶部
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:0 inSection:0];
        // 滚动到指定单元格的顶部
        [self.collectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        [self.collectionView reloadData];
    }];
}

//refreshdata
-(void)refreshData {
    [self.pexelsLoader loadListDataWithNextPageURL:^(BOOL success, NSArray * _Nullable urlArray) {
        [self.urlArray setArray:urlArray];
        [self.collectionView reloadData];
        
    }];
    [_collectionView.mj_header endRefreshing];
}

//下滑加载，分页请求
-(void)loadMoreData {
    [self.pexelsLoader loadListDataWithNextPageURL:^(BOOL success, NSArray * _Nullable urlArray) {
        [self.urlArray addObjectsFromArray:urlArray];
        [self.collectionView reloadData];
    }];
    [_collectionView.mj_footer endRefreshing];
}

@end
