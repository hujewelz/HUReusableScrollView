//
//  HUViewController.h
//  HUReusableScrollView
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUReusableScrollView.h"

@interface HUViewController : UIViewController <HUReusableContainer>

@property (nonatomic, strong) NSNumber *page;


@property (weak, nonatomic) IBOutlet UILabel *label;

@end
