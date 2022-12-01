//
//  ViewController.m
//  CrackDemo
//
//  Created by wanglei on 2017/07/6.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

@property (weak) IBOutlet NSTextField *tintLabel;

@property (weak) IBOutlet NSTextField *textField;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (IBAction)checkCode:(NSButton *)sender {
    if ([_textField.stringValue isEqualToString:@"1234"]) {
        _tintLabel.stringValue = @"验证通过";
    }else{
        _tintLabel.stringValue = @"验证失败";
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
