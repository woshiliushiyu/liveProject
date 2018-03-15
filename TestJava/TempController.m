//
//  TempController.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "TempController.h"
#import "ReqController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface TempController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UILabel *showLabel;



@property (strong, nonatomic) IBOutlet UISlider *rSlide;
@property (strong, nonatomic) IBOutlet UISlider *gSlide;
@property (strong, nonatomic) IBOutlet UISlider *bSlide;
@property (strong, nonatomic) IBOutlet UITextField *rText;
@property (strong, nonatomic) IBOutlet UITextField *gText;
@property (strong, nonatomic) IBOutlet UITextField *bText;
@property (strong, nonatomic) IBOutlet UIView *colorView;

@end

@implementation TempController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.username.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
        self.showLabel.text = x;
    }];
    
    
    RACSignal * signal = [[RACSignal combineLatest:@[self.username.rac_textSignal,self.password.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length]>0 && [value[1] length]>5 && [value[1] length]<13);
    }];
    
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
    
    _rText.text=_gText.text=_bText.text = @"0.5";
    RACSignal * radSignal = [self blinSlide:_rSlide TextField:_rText];
    RACSignal * blueSignal =  [self blinSlide:_gSlide TextField:_gText];
    RACSignal *  greenSignal = [self blinSlide:_bSlide TextField:_bText];
    RACSignal * changeColorSignal =  [[RACSignal combineLatest:@[radSignal,blueSignal,greenSignal]] map:^id _Nullable(RACTuple *  _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[2] floatValue] blue:[value[1] floatValue] alpha:1];
    }];
    RAC(self.colorView,backgroundColor) = changeColorSignal;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳 转" style:UIBarButtonItemStylePlain target:self action:@selector(didNavBtnClick)];
}
- (void)didNavBtnClick {
    
//    [self presentViewController:[[ReqController alloc] init] animated:YES completion:^{
//        
//    }];
    [self.navigationController pushViewController:[[ReqController alloc] init] animated:YES];
}
//双向绑定
- (RACSignal *)blinSlide:(UISlider *)slider TextField:(UITextField *)textField
{
    RACSignal * textSignal = [[textField rac_textSignal] take:1];
    RACChannelTerminal * slideChannel = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal * textChannel = [textField rac_newTextChannel];
    [[slideChannel map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }] subscribe:textChannel];
    [textChannel subscribe:slideChannel];
    
    return [[slideChannel merge:textChannel] merge:textSignal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
