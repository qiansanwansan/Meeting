//
//  ViewController.m
//
//  Created by 肖睿 on 16/3/29.
//  Copyright © 2016年 XR. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "FYCollectionViewController.h"
#import "XRImage.h"
@interface ViewController ()<UISceneDelegate,UIScrollViewDelegate>
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<XRImage *> *images;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) NSMutableArray<FYCollectionViewController *> *vcArr;
@end

@implementation ViewController
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kWidth *(self.images.count / 8 + 2), kHeight);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        
    }
    return _scrollView;
}
- (NSMutableArray *)images {
    //从plist文件中取出字典数组，并封装成对象模型，存入模型数组中
    if (!_images) {
        _images = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *imageDic in imageDics) {
            XRImage *image = [XRImage imageWithImageDic:imageDic];
            [_images addObject:image];
        }
    }
    return _images;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kHeight - 30, kWidth, 30)];
        _pageControl.numberOfPages = self.images.count / 8 + 2;;
        _pageControl.currentPage = 0;
        _pageControl.defersCurrentPageDisplay = YES;
        [_pageControl updateCurrentPageDisplay];
        [_pageControl addTarget:self action:@selector(clickPageController:event:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
- (void)changePage:(id)sener {
    
    NSUInteger page = self.pageControl.currentPage;
    NSLog(@"%ld",page);
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = self.scrollView.frame.origin.y;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}
- (void)clickPageController:(UIPageControl *)pageController event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches] anyObject];
    CGPoint p = [touch locationInView:_pageControl];
    CGFloat centerX = pageController.center.x;
    NSUInteger page = self.pageControl.currentPage;
    CGFloat left = centerX-15.0*4/2;
    [_pageControl setCurrentPage:(int ) (p.x-left)/15];
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage*kWidth, 0)];

    NSLog(@"%f",(p.x-left)/15);
}

/*
 显示第几页就reload 第几页
 在线人数 / 8 = 要创建的页数
 对数据分组，每八个人一组，不足按一组
 新增或人数减少都要数据都要重新排序，但是不一定刷新页面，只主线程刷新底部页数指示器及当前页面
 最后一组数据超过八个，就要新开一个collectionView
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.view addSubview: self.pageControl];
    NSMutableArray<FYCollectionViewController *> *vcArr = [NSMutableArray new];
//    _pageControl.hidden = YES;
    NSInteger pages = self.images.count / 8 + 1 + 1;
    NSLog(@"%ld",(long)pages);
    for (NSUInteger i=0; i<pages; ++i) {
        if (i == 0) {
            UIView *firstView = [[UIView alloc]initWithFrame:self.view.bounds];
            firstView.backgroundColor = [UIColor blueColor];
            [self.scrollView addSubview:firstView];
            continue;;
        }
        FYCollectionViewController *collectionVC = [FYCollectionViewController new];
//        collectionVC.vc = self;
//        for (XRImage *imageModel in _images) {
//            [collectionVC.images addObject:<#(nonnull XRImage *)#>]
//        }
        collectionVC.images = [NSMutableArray new];
        for (NSUInteger j=(i-1)*8; j<self.images.count && j < (i-1)*8+8 ; ++j) {
            [collectionVC.images addObject:self.images[j]];
        }
        [vcArr addObject:collectionVC];
        
        UIView *view = collectionVC.view;
        view.frame = CGRectMake(kWidth * i, 0, kWidth, kHeight);
        
        [self.scrollView addSubview: collectionVC.view];
    }
    _vcArr = vcArr;// 这里加上持有才不会单元格消失
//    [vcArr.firstObject.view becomeFirstResponder];
//    FYCollectionViewController *collectionVC = [FYCollectionViewController new];
//    self.showView = collectionVC.view;
//    [self.scrollView addSubview: self.showView];
//    [collectionVC viewWillAppear: YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"1111%@", self.scrollView.subviews);
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
//    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
//    self.pageControl.currentPage = page;
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
//    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
//    self.pageControl.currentPage = page;
//    // 页面只要切换到其它页面就要刷新页面
//    [_vcArr[page].collectionView reloadData];
//    
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    self.pageControl.currentPage = page;
    // 页面只要切换到其它页面就要刷新页面
//    [_vcArr[page].collectionView reloadData];
//    _vcArr[page].images = @[];
}


@end
