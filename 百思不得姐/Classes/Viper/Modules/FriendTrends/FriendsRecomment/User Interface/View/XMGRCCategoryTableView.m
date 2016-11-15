//
//  XMGRCCategoryTableView.m
//  百思不得姐
//
//  Created by 付星 on 2016/11/14.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XMGRCCategoryTableView.h"
#import "UIView+XFLego.h"
#import "XMGRecommendCategoryCell.h"
#import "SVProgressHUD.h"
#import "XMGFriendsRecommentEventHandlerPort.h"

#define EventHandler  XFConvertPresenterToType(id<XMGFriendsRecommentEventHandlerPort>)

@interface XMGRCCategoryTableView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation XMGRCCategoryTableView

static NSString * const Identifier = @"RCCategoryCell";

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:@"XMGRecommendCategoryCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:UIColorFromRGB(R_Color_Front)];
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(R_Color_GlobalBkg)];
    [SVProgressHUD show];
    
    XF_Define_Weak
    [RACObserve(self.eventHandler,expressData) subscribeNext:^(id renderList) {
        XF_Define_Strong
        if (renderList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self reloadData];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
                [self selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
            });
        }
    }];
}

#pragma mark - UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.eventHandler expressData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    XMGCategoryRenderItem *renderItem = self.eventHandler.expressData[indexPath.row];
    cell.renderItem = renderItem;
    return cell;
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [EventHandler actionDidSelectCategoryAtIndex:indexPath.row];
}

- (void)xfLego_viewWillPopOrDismiss
{
    [SVProgressHUD popActivity];
}
@end
