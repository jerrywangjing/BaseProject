//
//  LDRefreshFooterView.h
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat LDRefreshFooterHeight;

@interface LDRefreshFooterView : UIView
@property (nonatomic, assign) BOOL autoLoadMore;        //default NO
@property (nonatomic, assign) BOOL loadMoreEnabled;     //default YES

@property (nonatomic, assign) CGFloat dragHeight;

- (void)endRefresh;

@end
