//
//  VideoViewController.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/11.
//

#import <UIKit/UIKit.h>
#import "PexelsLoader.h"
#import "SearchBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : UIViewController

@property (nonatomic,strong,readwrite) PexelsLoader *pexelsLoader;

@property (nonatomic,strong,readwrite) UICollectionView *collectionView;

@property (nonatomic,strong,readwrite) NSMutableArray *videosURL;

@property (nonatomic,strong,readwrite) NSMutableArray *picturesURL;

@property (nonatomic,strong,readwrite) NSMutableArray *widthArray;

@property (nonatomic,strong,readwrite) NSMutableArray *heightArray;

@property (nonatomic,strong,readwrite) SearchBar *searchBar;

@property (nonatomic,assign) NSInteger  *curIndex;

@property (nonatomic, strong, readwrite) NSIndexPath *willDisplayIndexPath;

@end

NS_ASSUME_NONNULL_END
