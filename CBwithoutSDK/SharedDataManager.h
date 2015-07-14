//
//  SharedDataManager.h
//  CBwithoutSDK
//
//  Created by Shubham Singh on 12/07/15.
//  Copyright (c) 2015 PayU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PayUResultViewController.h"

@interface SharedDataManager : NSObject

//All payment options available on the SALT
@property(nonatomic,strong) NSDictionary *allPaymentOptionDict;

//All param provided by User.
@property(nonatomic,strong) NSDictionary *allInfoDict;

//All Stored Card for given user if any.
@property(nonatomic,strong) NSDictionary *storedCard;


//List of down internet banking option.
@property(nonatomic,strong) NSMutableArray *listOfDownInternetBanking;

//List of down credit/debit bins.
@property(nonatomic,strong) NSMutableArray *listOfDownCardBins;

//All the hash comes from server.
@property(nonatomic,strong) NSDictionary *hashDict;

//SBI Bins
@property(nonatomic,strong) NSMutableArray *allSbiBins;


- (BOOL) isSBIMaestro:(NSString *) cardNumber;
- (NSString *)checkCardDownTime:(NSString *) cardNumber;
- (void) makeVasApiCall;

//to create shared instance
+ (id)sharedDataManager;

@end
