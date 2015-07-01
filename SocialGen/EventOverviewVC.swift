//
//  EventOverview.swift
//  SocialGen
//
//  Created by Nicole Yarroch on 6/24/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

import Foundation
import PNChart

class EventOverviewVC : UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Set the exposed width of the menu
        self.revealViewController().rearViewRevealWidth = 220
        
        // Does menu move as it opens and closes (0 means it doesn't move at all)
        self.revealViewController().rearViewRevealDisplacement = 0.0
        
        // Type of animation
        self.revealViewController().toggleAnimationType = SWRevealToggleAnimationType.Spring
        self.revealViewController().springDampingRatio = 1.0
        
        // Shadow
        self.revealViewController().frontViewShadowRadius = 10
        self.revealViewController().frontViewShadowOpacity = 0.8
        self.revealViewController().frontViewShadowOffset.height = 0.0
        self.revealViewController().frontViewShadowOffset.width = 2.5
        self.revealViewController().frontViewShadowColor = UIColor.blackColor()
        
        lineChart()
    }
    
    func lineChart() {
        
//        let lineChart : PNLineChart = PNLineChart();
//        lineChart.frame = CGRectMake(0, 135.0, UIScreen.mainScreen().bounds.width, 200.0);
//        lineChart.setXLabels(["SEP 1", "SEP 2", "SEP 3", "SEP 4", "SEP 5"], withWidth: 5.0)
        
        // Line chart no. 1
//        let data01Array : NSArray = [60.1, 160.1, 126.4, 262.2, 186.2];
//        let data01 : PNLineChartData = PNLineChartData()
//        data01.color = UIColor.greenColor();
//        data01.itemCount = UInt(lineChart.xLabels.count)
     
//        data01.getData = ^(index : NSInteger) {
//            let yValue : CGFloat = data01Array[index].floatValue
//            return PNLineChartDataItem(y: yValue)
//        };
        
        
        
        // Make the chart
//        lineChart.chartData = [data01]
//        lineChart.strokeChart()
        
        func applyMutliplication(value: Int, multFunction: Int -> Int) -> Int {
            return multFunction(value)
        }
        
    }
        
        
        
        //For Line Chart
//        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//        [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
//        
//        // Line Chart No.1
//        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
//        PNLineChartData *data01 = [PNLineChartData new];
//        data01.color = PNFreshGreen;
//        data01.itemCount = lineChart.xLabels.count;
//        data01.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data01Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        // Line Chart No.2
//        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
//        PNLineChartData *data02 = [PNLineChartData new];
//        data02.color = PNTwitterColor;
//        data02.itemCount = lineChart.xLabels.count;
//        data02.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data02Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        
//        lineChart.chartData = @[data01, data02];
//        [lineChart strokeChart];

}