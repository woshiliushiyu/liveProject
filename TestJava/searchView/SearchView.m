
//
//  SearchView.m
//  TestJava
//
//  Created by 流诗语 on 2018/4/18.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "SearchView.h"
#import "UIView+ViewController.h"
@implementation SearchView

- (void)searchAction:(id)sender {
    // 1. Create an Array of popular search
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[ResultSearchViewController alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history
    
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleCell;
    
    searchViewController.showSearchResultWhenSearchBarRefocused = YES;
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    // 4. Set delegate
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    // 5. Present a navigation controller
    RootSearchViewController *nav = [[RootSearchViewController alloc] initWithRootViewController:searchViewController];
    UIViewController * vc =[self jk_viewController];
    [self.jk_viewController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - PYSearchViewControllerDelegate

- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        [self.dataArray addObjectsFromArray:@[@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?",@"这是标题吗?"]];
        [searchViewController.searchSuggestionView reloadData];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
        //            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
        //                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
        //                [searchSuggestionsM addObject:searchSuggestion];
        //            }
        //            // Refresh and display the search suggustions
        //            searchViewController.searchSuggestions = searchSuggestionsM;
        //        });
    }
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [searchSuggestionView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"icon_test.jpg"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    //    cell.descLabel.text = @"这是副标题吗? 这就是";
    return cell;
}
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    return 1;
}
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
