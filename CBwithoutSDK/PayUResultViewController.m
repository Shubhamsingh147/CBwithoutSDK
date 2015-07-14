//
//  PayUResultViewController.m
//  CBwithoutSDK
//
//  Created by Shubham Singh on 12/07/15.
//  Copyright (c) 2015 PayU. All rights reserved.
//

#import "PayUResultViewController.h"
#import "Header.h"
//#import "WebViewJavascriptBridge.h"
#import "SharedDataManager.h"
//#import "Reachability.h"
//#import "ReachabilityManager.h"
//#import "CBApproveView.h"
//#import "CustomActivityIndicator.h"

// ------------------- CB Import ----------------
//#import "PayU_CB_SDK.h"
#define DETECT_BANK_KEY @"detectBank"
#define INIT  @"init"

@interface PayUResultViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *processingLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *resultWebView;

@property (strong,nonatomic) UIView *transparentView;
@property (nonatomic,strong) NSArray *pgUrlList;
//@property (nonatomic,strong) CBConnectionHandler *handler;
@property (nonatomic,strong) NSString *loadingUrl;

//@property (nonatomic,strong) CustomActivityIndicator *customIndicator;

@property (nonatomic,assign) float y;

@property (nonatomic,assign) BOOL isBankFound;
@property (nonatomic,assign) BOOL isWebViewLoadFirstTime;


@end

@implementation PayUResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isBankFound = NO;
    if(_isBackOrDoneNeeded){
        
        if(64 != _y){
            
            
        }
        else{
            //Dissable back button
            //[self.navigationItem setHidesBackButton:YES animated:YES];
            
        }
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if(_flag){
        
        _y = 64;
        NSLog(@"UI SHould be according to 3_5 inch");
        [self.view removeConstraints:self.view.constraints];
        [_resultWebView removeConstraints:_resultWebView.constraints];
        _resultWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _resultWebView.translatesAutoresizingMaskIntoConstraints = YES;
        
        [_processingLbl removeConstraints:_processingLbl.constraints];
        _processingLbl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _processingLbl.translatesAutoresizingMaskIntoConstraints = YES;
        
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.origin.y = _y;
        frame.size.height = frame.size.height - _y;
        _resultWebView.frame = frame;
        
        /*frame = _activityIndicator.frame;
         frame.origin.x = self.view.frame.size.width/2  - frame.size.width+10;
         frame.origin.y = self.view.frame.size.height/2 - frame.size.height-100;
         _activityIndicator.frame = frame;*/
        
        frame = _processingLbl.frame;
        frame.origin.x = self.view.frame.size.width/2  - frame.size.width + 60;
        frame.origin.y = self.view.frame.size.height/2 - frame.size.height - 80;
        _processingLbl.frame = frame;
        
    }
    //    [_activityIndicator removeConstraints:_activityIndicator.constraints];
    //    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    //    _activityIndicator.translatesAutoresizingMaskIntoConstraints = YES;
    //    //_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    _activityIndicator.center=self.view.center;
    //    _activityIndicator.hidden = NO;
    //
    //    _activityIndicator.center=self.view.center;
    //
    CGRect frame = [[ UIScreen mainScreen] bounds];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        NSLog(@"iOS :8");
        //initializeJSStr = [initializeJSStr stringByReplacingOccurrencesOfString:@"[name=frmAcsOption]" withString:@""];
        //        _customIndicator = [[CustomActivityIndicator alloc] initWithFrame:CGRectMake((frame.size.width-250)/2,(frame.size.height-200)/2, 250, 200)];
        //
        _transparentView = [[UIView alloc] initWithFrame:frame];
        _transparentView.backgroundColor = [UIColor grayColor];
        _transparentView.alpha = 0.5f;
        _transparentView.opaque = NO;
        [self.view addSubview:_transparentView];
        
        //        [self.view addSubview:_customIndicator];
        //        [self.view bringSubviewToFront:_customIndicator];
    }
    
    
    //[self startStopIndicator:YES];
    //[self loadJavascript];
    _resultWebView.scalesPageToFit = NO;
    //    _resultWebView.layer.borderWidth = 1;
    //    _resultWebView.layer.borderColor = [UIColor redColor].CGColor;
    
    _resultWebView.opaque = NO;
    _resultWebView.backgroundColor = [UIColor clearColor];
    
    //to display contant in webview from top.
    [[_resultWebView scrollView] setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    
}

- (void)dealloc {
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"");
    _y = 0.0;
    if ([self isBeingPresented]) {
        // being presented
        _y = 20;
        
    } else if ([self isMovingToParentViewController]) {
        // being pushed
        _y = 64;
    }
    _isWebViewLoadFirstTime = NO;
    //[self startStopIndicator:YES];
    
    // Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoingInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    _resultWebView.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        NSHTTPURLResponse *response;
//        NSError *error;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:_request
//                                                     returningResponse:&response
//                                                                 error:&error];
//        NSLog(@"StatusCode: %ld",(long)[response statusCode]);
//        [_resultWebView loadData:responseData MIMEType:[response MIMEType]
//                textEncodingName:[response textEncodingName]
//                         baseURL:[response URL]];
        
         [_resultWebView loadRequest:_request];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"");
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    
}

- (void)viewDidLayoutSubviews{
    
}

-(void) appGoingInBackground:(NSNotification *)notification{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) matchUrl:(NSString *)urlStr{
    BOOL isUrlMatchFound = NO;
    for(NSString *pgUrl in _pgUrlList){
        if([urlStr isEqualToString:pgUrl] || [urlStr rangeOfString:pgUrl options:NSCaseInsensitiveSearch].location != NSNotFound){
            isUrlMatchFound = YES;
        }
    }
    
    if(!isUrlMatchFound && _pgUrlList && !_resultWebView.loading){
        NSLog(@"URL Match Found not Found");
        //       [_customIndicator removeFromSuperview];
        [_transparentView removeFromSuperview];
    }
}

#pragma mark - WebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    NSLog(@"");
        _resultWebView.scalesPageToFit = NO;
    //  [self startStopIndicator:NO];
    
    [self matchUrl:_loadingUrl];
    //   [self removeCBOnRetryPage:_loadingUrl];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;{
    NSLog(@"");
    // [self startStopIndicator:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    NSLog(@"finallyCalled = %@",url);
    
    //[self matchUrl:url.absoluteString];
    _loadingUrl = url.absoluteString;
    
   // if ([[url scheme] isEqualToString:@"ios"]) {
        // [self startStopIndicator:NO];
        
        NSString *responseStr = [url  absoluteString];
        NSString *search = @"success";
        
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DICT_RESPONSE];
            //   [[NSNotificationCenter defaultCenter] postNotificationName:PAYMENT_SUCCESS_NOTIFICATION object:InfoDict];
            NSLog(@"success block with infoDict = %@",InfoDict);
            
        }
        
        search = @"failure";
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DIC T_RESPONSE];;
            
            NSLog(@"failure block with infoDict = %@",InfoDict);
            
        }
        search = @"cancel";
        
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DICT_RESPONSE];;
            
            NSLog(@"cancel block with infoDict = %@",InfoDict);
            
        }
   // }
    return YES;
}

-(void)navigateToRootViewController{
    NSLog(@"");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end




