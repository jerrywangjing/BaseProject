//
//  HMSearchBar.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2018/1/22.
//  Copyright © 2018年 华美医信. All rights reserved.
//

#import "HMSearchBar.h"

#define kSearchPlaceholder @"搜索"

@interface HMSearchBar ()

@property (nonatomic,weak) UIButton *searchFieldBtn;
@property (nonatomic,weak) UIButton *cancleBtn;

@property (nonatomic,assign) BOOL isSearching;

@end

@implementation HMSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initSubviews];
     
    }
    return self;
}

- (void)initSubviews{
    
    // cancle btn
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn  = cancleBtn;
    _cancleBtn.hidden = YES;
    [_cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancleBtn];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(40);
    }];
    
    // search field
    
    UIButton *searchField = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchFieldBtn = searchField;
    _searchFieldBtn.backgroundColor = [UIColor whiteColor];
    _searchFieldBtn.layer.cornerRadius = 8;
    _searchFieldBtn.layer.masksToBounds = YES;
    _searchFieldBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_searchFieldBtn setTitle:kSearchPlaceholder forState:0];
    [_searchFieldBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _searchFieldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_searchFieldBtn addTarget:self action:@selector(searchFieldDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchFieldBtn setImage:[UIImage imageNamed:@"icon_search_small"] forState:UIControlStateNormal];
    
    [self addSubview:_searchFieldBtn];
    
    [_searchFieldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.mas_equalTo(10);
        make.bottomMargin.mas_equalTo(-10);
        make.leftMargin.mas_equalTo(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self layoutIfNeeded];  // 布局立即生效
}

#pragma setter/getter

- (void)setSearchText:(NSString *)searchText{
    [self.searchFieldBtn setTitle:searchText forState:UIControlStateNormal];
}

- (NSString *)searchText{
    if ([self.searchFieldBtn.titleLabel.text isEqualToString:kSearchPlaceholder]) {
        return @"";
    }
    return self.searchFieldBtn.titleLabel.text;
}

#pragma mark - actions

// searchField did click

- (void)searchFieldDidClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(hmSearchBarShouldBeginSearching:)]) {
        [self.delegate hmSearchBarShouldBeginSearching:self];
    }
}

// cancle btn did click

- (void)cancleBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(hmSearchBarDidClickCancle:)]) {
        [self.delegate hmSearchBarDidClickCancle:self];
        [self cancleSearching];
    }
}

#pragma mark - public

- (void)startSearching{
    
    if (self.isSearching) return;
    
    self.cancleBtn.hidden = NO;
    self.isSearching = YES;
    
    [self.searchFieldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:1 animations:^{
        [self.searchFieldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-self.cancleBtn.width-10);
        }];
    }];
    
    [self layoutIfNeeded];
}

- (void)cancleSearching{
    
    if (!self.isSearching) return;
    
    self.cancleBtn.hidden = YES;
    self.isSearching = NO;
    
    [self.searchFieldBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.searchFieldBtn setTitle:kSearchPlaceholder forState:UIControlStateNormal];
    
    [UIView animateWithDuration:1 animations:^{
        [self.searchFieldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
        }];
    }];
    [self layoutIfNeeded];
}

@end
