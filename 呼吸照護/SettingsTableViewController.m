//
//  SettingsTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MainViewController.h"
#import "DatabaseUtility.h"
#import "WebAPI.h"

@interface SettingsTableViewController () <UITextFieldDelegate>

@end

@implementation SettingsTableViewController {
    MainViewController *mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainView = (MainViewController *)(self.parentViewController).parentViewController;
    
    self.textServer.text = mainView.serverPath;
    self.textServer.delegate = self;
    
//    [self.switchDemoMode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDemoMode:)]];
    [self.switchDemoMode addTarget:self action:@selector(toggleDemoMode:) forControlEvents:UIControlEventValueChanged];
    
    self.labelVersion.text = [NSString stringWithFormat:@"版本: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.textServer.text = mainView.serverPath;
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleDemoMode:(id)sender {
    [MainViewController SetDemoMode:((UISwitch *)sender).on];
}

- (void)saveServerPath:(UITextField *)textField {
    NSString *path = textField.text;
    
    if (path.length) {
        //開頭加上http://
        if (path.length < 7 || ![[path substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"http://"]) {
            path = [@"http://" stringByAppendingString:path];
        }
        //尾巴加上/
        if (![[path substringFromIndex:path.length - 1] isEqualToString:@"/"]) {
            path = [path stringByAppendingString:@"/"];
        }
        
    }
    self.textServer.text = path;
    [WebAPI setServerPath:path];
    DatabaseUtility *db = [[DatabaseUtility alloc] init];
    if ([db saveServerPath:path]) {
        mainView.serverPath = path;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textServer) {
        [self saveServerPath:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textServer) {
        [self saveServerPath:textField];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag != 100) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 2;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
