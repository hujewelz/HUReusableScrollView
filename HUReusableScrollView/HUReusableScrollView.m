//
//  HUReusableScrollView.m
//  HUReusableScrollView
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUReusableScrollView.h"


@interface HUReusableScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSNumber *currentPage;

@property (nonatomic, strong) NSMutableArray *reusableContainers;
@property (nonatomic, strong) NSMutableArray *visibleContainers;



@end

@implementation HUReusableScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
    }
    return self;
}

- (void)setupView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
   
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)setDataSource:(id<HUReusableScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    NSInteger page = [self.dataSource numberOfRowsInReusableScrollView:self];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * page, 0);
    
    [self loadPage:0];
}

- (void)loadPage:(NSInteger)page {
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }
    
    self.currentPage = @(page);
    NSMutableArray *pageToLoad = [@[@(page-1), @(page), @(page+1)] mutableCopy];
    NSMutableArray *queue = [NSMutableArray array];
    for (id<HUReusableContainer> container in self.visibleContainers) {
        if (![container page] || ![pageToLoad containsObject:[container page]]) {
            [queue addObject:container];
        }
        else if ([container page]) {
            [pageToLoad removeObject:[container page]];
        }
    }
    
    for (id<HUReusableContainer> container in queue) {
        
        if ([container isKindOfClass:[UIView class]]) {
            UIView * view = (UIView *)container;
            [view removeFromSuperview];
        }
        else if ([container isKindOfClass:[UIViewController class]]) {
            UIViewController * vc = (UIViewController *)container;
            [vc.view removeFromSuperview];
        }
        
        [self.visibleContainers removeObject:container];
        [self enqueueReusableContainer:container];
    }
    
    for (NSNumber *page in pageToLoad) {
        [self addContainerForPage:[page integerValue]];
    }
}

- (void)enqueueReusableContainer:(id<HUReusableContainer>)container {
    [self.reusableContainers addObject:container];
}

- (id<HUReusableContainer>)dequeueReusableContainerAtPate:(NSInteger)page {
 
    if (self.reusableContainers.count >= page+1) {
        id<HUReusableContainer> container = [self.reusableContainers objectAtIndex:page];
        [self.reusableContainers removeObject:container];
        return container;
    }
    return nil;
}

- (void)addContainerForPage:(NSInteger)page {
    if (page <0 || page > [self.dataSource numberOfRowsInReusableScrollView:self]) {
        return;
    }
    
    id<HUReusableContainer> container = [self.dataSource reusableScrollView:self reusableContainerForItemAtPage:page];
    container.page = @(page);
    
    UIView *view = nil;
    if ([container isKindOfClass:[UIView class]]) {
        view = (UIView *)container;
        
    }
    else if ([container isKindOfClass:[UIViewController class]]) {
        UIViewController * vc = (UIViewController *)container;
        view = vc.view;
    }
    view.frame  = CGRectMake(self.scrollView.frame.size.width * page, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:view];
    [self.visibleContainers addObject:container];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    NSInteger page = roundf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    page = MAX(page, 0);
    page = MIN(page, [self.dataSource numberOfRowsInReusableScrollView:self] - 1);
    [self loadPage:page];
    
    NSLog(@"visibleContainers:%@, reusableContainers:%@", self.visibleContainers, self.reusableContainers);
}

- (NSMutableArray *)reusableContainers {
    if (!_reusableContainers) {
        _reusableContainers  =[NSMutableArray array];
    }
    return _reusableContainers;
}

- (NSMutableArray *)visibleContainers {
    if (!_visibleContainers) {
        _visibleContainers = [NSMutableArray array];
    }
    return _visibleContainers;
}



@end

