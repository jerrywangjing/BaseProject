//
//  HMSearchBar.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2018/1/22.
//  Copyright © 2018年 华美医信. All rights reserved.
//

#import "HMBaseView.h"

@class HMSearchBar;

@protocol HMSearchBarDelegate <NSObject>
@optional

- (void)hmSearchBarShouldBeginSearching:(HMSearchBar *)searchBar;
- (void)hmSearchBarDidClickCancle:(HMSearchBar *)searchBar;

@end

@interface HMSearchBar : HMBaseView

@property (nonatomic,copy) NSString *searchText;
@property (nonatomic,assign,readonly) BOOL isSearching;
@property (nonatomic,weak) id<HMSearchBarDelegate> delegate;


- (void)startSearching;
- (void)cancleSearching;

@end
