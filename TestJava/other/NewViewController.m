//
//  NewViewController.m
//  TestJava
//
//  Created by 流诗语 on 2018/4/15.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "NewViewController.h"
#import "NewTagModel.h"
@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray * localArray = @[@[
                                     [[NewTagModel alloc] initWithUid:@"100" Title:@"推荐"],
                                     [[NewTagModel alloc] initWithUid:@"101" Title:@"练武"],
                                   [[NewTagModel alloc] initWithUid:@"101" Title:@"搞笑"]],
                             
                                  @[[[NewTagModel alloc] initWithUid:@"102" Title:@"动漫"],
                                    [[NewTagModel alloc] initWithUid:@"103" Title:@"文艺"],
                                    [[NewTagModel alloc] initWithUid:@"104" Title:@"战争"]]];
    
    NSArray * newArray = @[
                           [[NewTagModel alloc] initWithUid:@"100" Title:@"推荐"],
//                           [[NewTagModel alloc] initWithUid:@"101" Title:@"练武"],
//                           [[NewTagModel alloc] initWithUid:@"101" Title:@"搞笑"],
//                           [[NewTagModel alloc] initWithUid:@"102" Title:@"动漫"],
                           [[NewTagModel alloc] initWithUid:@"105" Title:@"历史"],
//                           [[NewTagModel alloc] initWithUid:@"103" Title:@"文艺"],
                           [[NewTagModel alloc] initWithUid:@"104" Title:@"战争"]
                           ];
    
    //===========测试后台返回的是新添加的时候.==================
    NSMutableArray * array1 = [[NSMutableArray alloc] init];
    [array1 addObjectsFromArray:localArray.firstObject];
    [array1 addObjectsFromArray:localArray.lastObject];
    
    NSMutableArray * tempArray0 = [[NSMutableArray alloc] init];
    [array1 enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray0 addObject:obj.title];
    }];
    
    NSMutableArray * tempArray1 = [[NSMutableArray alloc] init];
    [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray1 addObject:obj.title];
    }];

    NSMutableSet *new_set = [[NSMutableSet alloc] initWithArray:tempArray1];
    NSMutableSet *old_set = [[NSMutableSet alloc] initWithArray:tempArray0];
    
    if ([new_set isEqualToSet:old_set]) {
        NSLog(@"========>这两个相同===========");
    }else if ([old_set isSubsetOfSet:new_set]) {//new_set是不是包含old_set
        NSMutableArray * array2 = [[NSMutableArray alloc] init];
        NSLog(@"========>new_set包含old_set============");
        [old_set unionSet:new_set];
        NSArray * nameArray = [old_set allObjects];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString * nameString in nameArray) {
                if ([obj.title isEqualToString:nameString]) {
                    [array2 addObject:obj.title];
                }
            }
        }];
        NSLog(@"老的数据里面包含了新的数据内容========>%@",array2);
        NSMutableArray * array3 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NewTagModel * tagModel in localArray.firstObject) {
                if ([obj.title isEqualToString:tagModel.title]) {
                    [array3 addObject:obj];
                }
            }
        }];

        //下面的显示
        NSMutableArray * array6 = [[NSMutableArray alloc] init];
        [localArray.firstObject enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array6 addObject:obj.title];
        }];
        NSMutableSet * bottemSet = [[NSMutableSet alloc] initWithArray:array6];
        NSMutableSet * allSet = [[NSMutableSet alloc] initWithArray:array2];
        [allSet minusSet:bottemSet];
        
        NSMutableArray * array7 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString * name in allSet) {
                if ([name isEqualToString:obj.title]) {
                    [array7 addObject:obj];
                }
            }
        }];
        NSLog(@"更换完了最新的数据之后,上面的数据显示----------->%@\n下面的数据显示=========%@",array3,array7);
        
    }else if ([new_set isSubsetOfSet:old_set]) {//old_set是不是包含new_set
        NSLog(@"========>old_set包含new_set==================");
        NSMutableArray * array3 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NewTagModel * tagModel in localArray.firstObject) {
                if ([obj.title isEqualToString:tagModel.title]) {
                    [array3 addObject:obj];
                }
            }
        }];
        
        //下面的显示
        NSMutableArray * array4 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NewTagModel * tagModel in localArray.lastObject) {
                if ([obj.title isEqualToString:tagModel.title]) {
                    [array4 addObject:obj];
                }
            }
        }];
        NSLog(@"更换完了最新的数据之后,上面的数据显示----------->%@\n下面的数据显示============%@",array3,array4);
        
    }else if ([new_set intersectsSet:old_set]) {
        NSLog(@"========>新数据和老数据之间有交集==================");
        [old_set minusSet:new_set];
        NSMutableArray * tempArray5 = [[NSMutableArray alloc] init];
        [localArray.firstObject enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray5 addObject:obj.title];
        }];
        NSMutableSet * topSet = [[NSMutableSet alloc] initWithArray:tempArray5];//获取了上半部分的名字集合
        [topSet minusSet:old_set];
        
        NSMutableArray * tempArray6 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray6 addObject:obj.title];
        }];
        NSMutableSet * bottemSet = [[NSMutableSet alloc] initWithArray:tempArray6];//获取了下半部分的名字集合
        [bottemSet minusSet:old_set];
        [bottemSet minusSet:topSet];
        
        
        NSMutableArray * array8 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString * name in topSet) {
                if ([name isEqualToString:obj.title]) {
                    [array8 addObject:obj];
                }
            }
        }];
        
        NSMutableArray * array9 = [[NSMutableArray alloc] init];
        [newArray enumerateObjectsUsingBlock:^(NewTagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString * name in bottemSet) {
                if ([name isEqualToString:obj.title]) {
                    [array9 addObject:obj];
                }
            }
        }];
        
        NSLog(@"获取到的上面的数据集合======>%@,\n获取到的下面的数据集合是=======>%@",array8,array9);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
