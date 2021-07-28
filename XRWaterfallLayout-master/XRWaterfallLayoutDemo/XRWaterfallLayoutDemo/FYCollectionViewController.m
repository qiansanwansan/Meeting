//
//  FYCollectionView.m
//  XRWaterfallLayoutDemo
//
//  Created by 冯宇 on 2021/7/25.
//  Copyright © 2021 XR. All rights reserved.
//

#import "FYCollectionViewController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "XRCollectionViewCell.h"
#import "XRWaterfallLayout.h"

@interface FYCollectionViewController ()<UICollectionViewDataSource,XRWaterfallLayoutDelegate>
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray<XRImage *> *images;
@end

@implementation FYCollectionViewController

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor redColor];
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        
    //设置各属性的值
    //    waterfall.rowSpacing = 10;
    //    waterfall.columnSpacing = 10;
    //    waterfall.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
    //或者一次性设置
    [waterfall setColumnSpacing:1 rowSpacing:1 sectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    //设置代理，实现代理方法
    waterfall.delegate = self;
    /*
     //或者设置block
     [waterfall setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
        //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
        XRImage *image = self.images[indexPath.item];
        return image.imageH / image.imageW * itemWidth;
    }];
     */
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kWidth, kHeight-20) collectionViewLayout:waterfall];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [self.collectionView reloadData];
//}
//- (void)setVc:(UIViewController *)vc{
//    _vc = vc;
//    self.collectionView.dataSource = _vc;
//}
//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    XRImage *image = self.images[indexPath.item];
    return (kHeight-20-2)/2;
    return image.imageH / image.imageW * itemWidth;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageURL = self.images[indexPath.item].imageURL;
    return cell;
}
- (void)setImages:(NSMutableArray *)images{
    _images = images;
    [_collectionView reloadData];
}
//- (NSMutableArray *)images {
//    //从plist文件中取出字典数组，并封装成对象模型，存入模型数组中
//    if (!_images) {
//        _images = [NSMutableArray array];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
//        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
//        for (NSDictionary *imageDic in imageDics) {
//            XRImage *image = [XRImage imageWithImageDic:imageDic];
//            [_images addObject:image];
//        }
//    }
//    return _images;
//}

@end
