//
//  PictureViewCell.h
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/5.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PictureViewCell : UICollectionViewCell

@property (nonatomic,strong,readwrite) UIImageView *imageView;

-(void)layoutPictureViewCell:(NSString *)urlString width:(NSNumber *)width height:(NSNumber *)height;

@end



NS_ASSUME_NONNULL_END
