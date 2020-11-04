//
//  KJNavigationBarVC.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "KJNavigationBarVC.h"

@interface KJNavigationBarVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *temps;
@property(nonatomic, assign) CGFloat lastOffsetY;
@end

@implementation KJNavigationBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_setRightBtnWithImgName:@"light_icon" clickedBlock:^(UIButton * _Nonnull btn) {
        NSLog(@"点击了最右侧的Button");
    }];
    [self.zx_navLeftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.zx_navLeftBtn kj_addAction:^(UIButton * _Nonnull kButton) {
        self.zx_showSystemNavBar = YES;
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZXNavBarHeight, kScreenW, kScreenH-ZXNavBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,dic[@"Title"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW-80, 0, 80, 40)];
    sw.tag = 520 + indexPath.row;
    [sw addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventValueChanged)];
    sw.centerY = cell.contentView.height/2;
    [cell.contentView addSubview:sw];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - offsetY;
    CGFloat distance = offsetY - self.lastOffsetY;
    self.lastOffsetY = offsetY;
    //向上滚动，导航栏折叠
    if (distance > 0 && offsetY > 0) {
        if(!self.zx_navIsFolded){
            [self setNavFold:YES];
        }
    }
    //向下滚动
    if (distance < 0 && distanceFromBottom+ZXNavBarHeight > scrollView.zx_height) {
        if(self.zx_navIsFolded) {
            [self setNavFold:NO];
        }
    }
}
/// 折叠处理
- (void)setNavFold:(BOOL)shouldFold{
    __weak typeof(self) weakSelf = self;
    [self zx_setNavFolded:shouldFold speed:3 foldingOffsetBlock:^(CGFloat offset) {
        //tableView的y值跟随导航栏变化(导航栏高度减小，tableView的y值减小)
        weakSelf.tableView.zx_y += offset;
        //tableView的高度值跟随这导航栏变化(导航栏高度减小，tableView高度增加)
        weakSelf.tableView.zx_height -= offset;
    } foldCompletionBlock:nil];
}

#pragma mark - lazy
- (NSMutableArray *)temps{
    if (!_temps) {
        _temps = [NSMutableArray array];
        [_temps addObject:@{@"Title":@"设置背景色"}];
        [_temps addObject:@{@"Title":@"设置背景图片"}];
        [_temps addObject:@{@"Title":@"设置TintColor"}];
        [_temps addObject:@{@"Title":@"设置大小标题效果"}];
        [_temps addObject:@{@"Title":@"设置StatusBar白色"}];
        [_temps addObject:@{@"Title":@"设置两边Item大小为30"}];
        [_temps addObject:@{@"Title":@"设置两边Item边距为0"}];
        [_temps addObject:@{@"Title":@"设置渐变背景"}];
        [_temps addObject:@{@"Title":@"右侧显示两个Item"}];
    }
    return _temps;
}

#pragma mark - Actions
- (void)switchAction:(UISwitch*)sender{
    if (sender.tag == 520) {
        if(sender.on){
            self.zx_navBarBackgroundColor = [UIColor cyanColor];
        }else{
            self.zx_navBarBackgroundColor = [UIColor whiteColor];
        }
    }else if (sender.tag == 521) {
        if(sender.on){
            self.zx_navBarBackgroundImage = [UIImage imageNamed:@"nav_bac"];
        }else{
            self.zx_navBarBackgroundImage = nil;
        }
    }else if (sender.tag == 522) {
        if(sender.on){
            self.zx_navTintColor = [UIColor greenColor];
        }else{
            self.zx_navTintColor = [UIColor blackColor];
        }
    }else if (sender.tag == 523) {
        if(sender.on){
            [self zx_setMultiTitle:@"NavigationBar" subTitle:@"subTitle"];
        }else{
            self.title = @"NavigationBar";
        }
    }else if (sender.tag == 524) {
        if(sender.on){
            self.zx_navStatusBarStyle = ZXNavStatusBarStyleLight;
        }else{
            self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
        }
    }else if (sender.tag == 525) {
        if(sender.on){
            self.zx_navItemSize = 30;
        }else{
            self.zx_navItemSize = ZXNavDefalutItemSize;
        }
    }else if (sender.tag == 526) {
        if(sender.on){
            self.zx_navItemMargin = 0;
        }else{
            self.zx_navItemMargin = ZXNavDefalutItemMargin;
        }
    }else if (sender.tag == 527) {
        if(sender.on){
            [self zx_setNavGradientBacFrom:[UIColor magentaColor] to:[UIColor cyanColor]];
        }else{
            [self zx_removeNavGradientBac];
        }
    }else if (sender.tag == 528) {
        if(sender.on){
            [self zx_setSubRightBtnWithImgName:@"light_icon" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                NSLog(@"点击了右侧第二个Button");
            }];
        }else{
            [self.zx_navSubRightBtn setImage:nil forState:UIControlStateNormal];
        }
    }
}

@end
