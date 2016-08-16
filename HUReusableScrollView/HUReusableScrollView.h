//
//  HUReusableScrollView.h
//  HUReusableScrollView
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HUReusableScrollViewDataSource, HUReusableScrollViewDelegate, HUReusableContainer;
@interface HUReusableScrollView : UIView

@property (nonatomic, weak) id<HUReusableScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<HUReusableScrollViewDelegate> delegate;

- (id<HUReusableContainer>)dequeueReusableContainerAtPate:(NSInteger)page;

- (void)loadPage:(NSInteger)page;

@end


@protocol HUReusableContainer <NSObject>

@property (nonatomic, strong) NSNumber *page;

@end

@protocol HUReusableScrollView;
@protocol HUReusableScrollViewDelegate <UIScrollViewDelegate>

@optional
- (void)reusableScrollView:(HUReusableScrollView *)reusableScrollView didScrollWithOffsetX:(CGFloat)offsetX;

- (void)reusableScrollView:(HUReusableScrollView *)reusableScrollView didScrollToPage:(NSInteger)page;

@end

@protocol HUReusableScrollViewDataSource <NSObject>

- (NSInteger)numberOfRowsInReusableScrollView:(HUReusableScrollView *)reusableScrollView ;

- (id<HUReusableContainer>)reusableScrollView:(HUReusableScrollView *)reusableScrollView reusableContainerForItemAtPage:(NSInteger)page;

@end
