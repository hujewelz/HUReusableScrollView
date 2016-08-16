//
//  ViewController.m
//  HUReusableScrollView
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "ViewController.h"
#import "HUReusableScrollView.h"
#import "HUViewController.h"

@interface ViewController () <HUReusableScrollViewDataSource, HUReusableScrollViewDelegate>

@property (nonatomic, strong) HUReusableScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _scrollView = [[HUReusableScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.dataSource = self;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfRowsInReusableScrollView:(HUReusableScrollView *)reusableScrollView {
    return 10;
}

- (id<HUReusableContainer>)reusableScrollView:(HUReusableScrollView *)reusableScrollView reusableContainerForItemAtPage:(NSInteger)page {
    
    HUViewController *vc = (HUViewController *)[reusableScrollView dequeueReusableContainerAtPate:page];
    
    if (vc == nil) {
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HUViewController"];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    
    vc.view.backgroundColor = [self backgroundColorWithPage:page];
    vc.label.text = [NSString stringWithFormat:@"vc %zd", page];
    return vc;

}

- (void)reusableScrollView:(HUReusableScrollView *)reusableScrollView didScrollWithOffsetX:(CGFloat)offsetX {
    NSLog(@"x: %.2f", offsetX);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"--------------------------");
}

- (UIColor *)backgroundColorWithPage:(NSInteger)page {
    UIColor *color = page%2 ==0 ? [UIColor redColor] : [UIColor blueColor];

    return color;
}

@end
