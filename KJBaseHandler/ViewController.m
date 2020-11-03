//
//  ViewController.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/25.
//

#import "ViewController.h"
#import "KJBaseViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *sectionTemps;
@property(nonatomic, strong) NSMutableArray *temps;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTemps = @[@"基类",@"控件类",@"工具类"];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    for (NSArray *array in self.temps) {
        for (NSDictionary *dic in array) {
            _weakself;
            NSString *str = [dic[@"URL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [KJRouter kj_routerRegisterWithURL:[NSURL URLWithString:str] Block:^UIViewController * _Nonnull(NSURL * _Nonnull URL, UIViewController * _Nonnull sourcevc) {
                NSDictionary *parm = [URL kj_analysisParameterGetQuery];
                NSString *name = parm[@"className"];
                KJBaseViewController *vc;
                if ([name isEqualToString:@"KJShareInstanceVC"]) {
                    vc = [NSClassFromString(name) kj_shareInstance];
                }else{
                    vc = [NSClassFromString(name) new];
                }
                vc.title = parm[@"title"];
                [weakself.navigationController pushViewController:vc animated:YES];
                return vc;
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTemps.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    NSString *str = [dic[@"URL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *parm = [[NSURL URLWithString:str] kj_analysisParameterGetQuery];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,parm[@"className"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = parm[@"title"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTemps[section];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.textColor = UIColor.orangeColor;
//    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    NSString *string = [dic[@"URL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [KJRouter kj_routerTransferWithURL:[NSURL URLWithString:string] SourceViewController:self];
}

#pragma mark - lazy
- (NSMutableArray *)temps{
    if (!_temps) {
        _temps = [NSMutableArray array];
        NSMutableArray *temp0 = [NSMutableArray array];
        [temp0 addObject:@{@"URL":@"https://www.test.com/test?className=KJShareInstanceVC&title=单例模式测试"}];
        [temp0 addObject:@{@"URL":@"https://www.test.com/test?className=KJNavigationBarVC&title=Navigation相关操作"}];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"URL":@"https://www.test.com/test?className=KJBadgeViewVC&title=小红点视图控件"}];
        [temp1 addObject:@{@"URL":@"https://www.test.com/test?className=KJBaseButtonVC&title=按钮控件加工"}];
        [temp1 addObject:@{@"URL":@"https://www.test.com/test?className=KJSegmentViewVC&title=选择菜单控件"}];
        [temp1 addObject:@{@"URL":@"https://www.test.com/test?className=KJProgressViewVC&title=环形进度条控件"}];
        
        NSMutableArray *temp2 = [NSMutableArray array];
        [temp2 addObject:@{@"URL":@"https://www.test.com/test?className=KJVideoEncodeVC&title=转码处理"}];
        
        [_temps addObject:temp0];
        [_temps addObject:temp1];
        [_temps addObject:temp2];
    }
    return _temps;
}

@end
