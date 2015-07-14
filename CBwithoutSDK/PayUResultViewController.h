//
//  PayUResultViewController.h
//  CBwithoutSDK
//
//  Created by Shubham Singh on 12/07/15.
//  Copyright (c) 2015 PayU. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface PayUResultViewController : UIViewController
//
//@end
#import <UIKit/UIKit.h>
//@import JavaScriptCore;
//
//@protocol JSCallBackToObjC <JSExport>
//
//- (void) bankFound:(NSString *)BankName;
//- (void) convertToNative:(NSString *)paymentOption andOtherOption:(NSString *)otherPaymentOptipon;
//
//@end

@interface  PayUResultViewController: UIViewController //<JSCallBackToObjC>

@property (nonatomic,strong) NSURLRequest *request;
@property (assign, nonatomic) BOOL flag;
@property (assign, nonatomic) BOOL isBackOrDoneNeeded;



@end