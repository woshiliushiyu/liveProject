//
//  PlayerViewController.m
//  TestJava
//
//  Created by 流诗语 on 2018/5/4.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "PlayerViewController.h"
#import "ShortPlayerViewController.h"
#import "GKPhotoBrowser.h"
#import "CNCustomPlayerBrowser.h"
@interface PlayerViewController ()
{
    
}
@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    imageView.image = [UIImage imageNamed:@"ywjf.png"];
    imageView.userInteractionEnabled  =YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAction)];
    [imageView addGestureRecognizer:tap];
}
-(void)setAction
{

}
- (IBAction)playAction:(id)sender {
    
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
