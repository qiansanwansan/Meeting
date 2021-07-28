//
//  FYCollectionView.h
//  XRWaterfallLayoutDemo
//
//  Created by 冯宇 on 2021/7/25.
//  Copyright © 2021 XR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYCollectionViewController : UIViewController
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<XRImage *> *images;
@end

NS_ASSUME_NONNULL_END
