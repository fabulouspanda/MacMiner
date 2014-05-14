//
//  overviewViewController.m
//  MacMiner
//
//  Created by Administrator on 30/07/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "overviewViewController.h"
#import "asicMiner.h"

@interface overviewViewController ()

@end

@implementation overviewViewController



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
//[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getTableData) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

- (void)getTableData {

    
}

- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
    if (data.length <=3) {
        return @"string too short";
    }
    
    else if ([leftData isNotEqualTo:nil]) {
        NSInteger left, right;
        
        NSScanner *scanner=[NSScanner scannerWithString:data];
        [scanner scanUpToString:leftData intoString: nil];
        left = [scanner scanLocation];
        [scanner setScanLocation:left + leftPos];
        [scanner scanUpToString:rightData intoString: nil];
        right = [scanner scanLocation];
        left += leftPos;
        NSString *foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];
        
        return foundData;
        
        foundData = nil;
        scanner = nil;
        leftData = nil;
        rightData = nil;
    }
    else return @"left string is nil";
}

- (IBAction)apiOutputToggle:(id)sender {
    
    if ([self.apiWindow isVisible]) {
        [self.apiWindow orderOut:sender];
    }
    else
    {
        [self.apiWindow orderFront:sender];
    }
}


@end
