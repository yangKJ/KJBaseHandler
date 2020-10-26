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
    self.sectionTemps = @[@"基类",@"工具类"];
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
                KJBaseViewController *vc = [[NSClassFromString(parm[@"className"]) alloc]init];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.height / 17.;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    NSString *str = [dic[@"URL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *parm = [[NSURL URLWithString:str] kj_analysisParameterGetQuery];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,parm[@"className"]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = parm[@"title"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTemps[section];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = UIColor.redColor;
    header.textLabel.font = [UIFont boldSystemFontOfSize:14];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    NSString *str = [dic[@"URL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [KJRouter kj_routerTransferWithURL:[NSURL URLWithString:str] Source:self];
}

#pragma mark - lazy
- (NSMutableArray *)temps{
    if (!_temps) {
        _temps = [NSMutableArray array];
        NSMutableArray *temp0 = [NSMutableArray array];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"URL":@"https://www.test.com/test?className=KJVideoEncodeVC&title=转码处理"}];
        
        [_temps addObject:temp0];
        [_temps addObject:temp1];
    }
    return _temps;
}

@end
