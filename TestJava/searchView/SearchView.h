//
//  SearchView.h
//  TestJava
//
//  Created by 流诗语 on 2018/4/18.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYSearch.h"
#import "RootSearchViewController.h"
#import "ResultSearchViewController.h"
@interface SearchView : UIView<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>
@property (strong, nonatomic) NSMutableArray * dataArray;
- (void)searchAction:(id)sender;
@end
