//
//  PictureViewController.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/5.
//

#import <UIKit/UIKit.h>
#import "PexelsLoader.h"
#import "SearchBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface PictureViewController : UIViewController

@property (nonatomic,strong,readwrite) PexelsLoader *pexelsLoader;

@property (nonatomic,strong,readwrite) NSMutableArray *urlArray;

@property (nonatomic,strong,readwrite) NSMutableArray *widthArray;

@property (nonatomic,strong,readwrite) NSMutableArray *heightArray;

@property (nonatomic,strong,readwrite) NSMutableArray *itemHeightArray;

@property (nonatomic,strong,readwrite) SearchBar *searchBar;

@property (nonatomic,strong,readwrite) UICollectionView *collectionView;

@property (nonatomic,strong,readwrite) UIButton *button;

@end

NS_ASSUME_NONNULL_END
