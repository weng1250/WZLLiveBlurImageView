//
//  MainTableVC.m
//  WZLLiveBlurImageView
//
//  Created by zilin_weng on 15/3/23.
//  Copyright (c) 2015年 Weng-Zilin. All rights reserved.
//

#import "MainTableVC.h"
#import "WZLLiveBlurImageView.h"

#define LBIDEBUG(x)                NSLog(@"%s:%@", __func__, @(x))

static NSString *kWZLLiveBlurImageViewContext;

@interface MainTableVC ()
{
    NSMutableArray *_items;
    WZLLiveBlurImageView *_blurImgView;
}

@end

@implementation MainTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark - private apis
- (void)setup
{
    //generate item content for tableView
    _items = [self items];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    _blurImgView = [[WZLLiveBlurImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    _blurImgView.frame = self.tableView.frame;
    self.tableView.backgroundView = _blurImgView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.tableView.bounds) - 100, 0, 0, 0);
    //setup kvo on tableview`s contentoffset
    [self.tableView addObserver:self forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        context:(__bridge void *)(kWZLLiveBlurImageViewContext)];
}

- (NSMutableArray *)items
{
    NSMutableArray *items = [NSMutableArray new];
    for (NSInteger i = 0; i < 30; i++) {
        [items addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    return items;
}

#pragma mark - datasource of table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _items[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - KVO configuration
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)(kWZLLiveBlurImageViewContext)) {
        CGFloat blurLevel = (self.tableView.contentInset.top + self.tableView.contentOffset.y) / CGRectGetHeight(self.tableView.bounds);
        [_blurImgView setBlurLevel:blurLevel];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"
                           context:(__bridge void *)kWZLLiveBlurImageViewContext];
}

@end
