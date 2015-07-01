//
//  EventChartVC.m
//  SocialGen
//
//  Created by Nicole Yarroch on 6/24/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

#import "EventChartVC.h"
#import "SWRevealViewController.h"

@interface EventChartVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation EventChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.revealViewController != nil) {
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
//    
//    if self.revealViewController() != nil {
//        menuButton.target = self.revealViewController()
//        menuButton.action = "revealToggle:"
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//    }

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
