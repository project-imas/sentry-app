//
//  APViewController.m
//  APComplexPassEncryt
//
//  Created by ct on 4/4/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#define DEBUG 1

#import "APViewController.h"
#import "iMASMainViewController.h"
#import <SecurityCheck/SecurityCheck.h>
#import "iMASAppDelegate.h"

@interface APViewController ()

//** key to retain these objects (pass and questions) b/c ARC will deallocate when view this view controller is backgrounded
@property (nonatomic, retain) APPass    *pass;
@property (nonatomic, retain) APPass    *question;

@property (nonatomic) NSInteger  numberOfQuestion;
@property (nonatomic) PASS_CTL   passControl;

@property (nonatomic,strong) IBOutlet UIButton *askForPassword;
@property (nonatomic,strong) IBOutlet UIImage  *background;
@property (nonatomic,strong) IBOutlet UIButton *logoutButton;
@property (nonatomic,strong) IBOutlet UIButton *resetButton;

//@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (nonatomic,strong) IBOutlet UIButton *forgotButton;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end


//***
@interface NSURLRequest(Private)

+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;

@end


//NSURLConnection stuff
NSMutableData *receivedData;
NSURLConnection *conneciton;
NSStringEncoding encoding;
//***



@implementation APViewController
typedef void (^cbBlock) (void);

-(NSString*)checkUDID {
    NSString *name = [[UIDevice currentDevice] name];
    
    
    NSURL *url = [NSURL URLWithString:@"https://whitealice.org:8080/sentrycheckin"];
    
#if DEBUG
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://whitealice.org:8080/sentrycheckin"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"Post"];
    [request setHTTPBody:[name dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    // Send request, get response and convert to NSString
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *result = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    
    
    // Store returned UDID with secure foundation's keychain
    
    return result; //for testing, return UDID
    
}

//-(void) sendProblem:(NSString*)UDID{
-(void) sendProblem:(NSString*)UDID withProblem:(NSString*)problemType{

    
    //DEBUG
    //NSString *problemType = @"jailbreak";
    
    NSURL *url = [NSURL URLWithString:@"https://whitealice.org:8080/problem"];
    
#if DEBUG
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://whitealice.org:8080/problem"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"Post"];
    
    //NSString *postdata = [NSString stringWithFormat:@"UDID=%s&type=%s", UDID, problemType];
    NSString *postdata = [[[@"UDID=" stringByAppendingString:UDID] stringByAppendingString:@"&type="] stringByAppendingString:problemType];
    
    [request setHTTPBody:[postdata dataUsingEncoding:NSUTF8StringEncoding]];
    //[request setHTTPBody:[UDID dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSLog(@"IN PROBLEMS WITH UDID:");
    NSLog(UDID);
    //NSLog([requestError localizedDescription]);
    
    
    NSLog([[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding]);
    //return [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    
}

-(void) sendLocation:(NSString*)UDID withX:(float)x andY:(float)y{
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://whitealice.org:8080/geolocation"];
    
#if DEBUG
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://whitealice.org:8080/geolocation"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"Post"];
    
    //NSString *postdata = [NSString stringWithFormat:@"UDID=%s&type=%s", UDID, problemType];
    NSString *postdata = [@"UDID=" stringByAppendingString:UDID];
    postdata =[[postdata stringByAppendingString:@"&x="] stringByAppendingString:[NSString stringWithFormat:@"%f", x]];
    postdata =[[postdata stringByAppendingString:@"&y="] stringByAppendingString:[NSString stringWithFormat:@"%f", y]];
                          
    
    
    [request setHTTPBody:[postdata dataUsingEncoding:NSUTF8StringEncoding]];
    //[request setHTTPBody:[UDID dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSLog(@"IN SENDLOCATION WITH UDID:");
    NSLog(UDID);
    //NSLog([requestError localizedDescription]);
    

}

void problem() {
    exit(0);  //temporary testing exit program - replace with bad pointer segfault to obfuscate flow
    //int *foo = (int*)-1; // make a bad pointer
    //printf("%d\n", *foo);
}



-(void)detectPolling{
    
    @autoreleasepool {

        //-----------------------------------
        // call back to weHaveAProblem
        //-----------------------------------
        cbBlock chkCallback  = ^{
            
            
            __weak id weakSelf = self;
            
            if (weakSelf) {
                UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:@"iMAS_SSO" create:YES];
                appPasteBoard.persistent = NO;
                [appPasteBoard setString:@""];
                
                // phoneHome
                //NSURL* url = [NSURL URLWithString:@"https://HOST:8080/problem"];
             
                //NSURLRequest* request = [NSURLRequest requestWithURL:url];
                
                //    if(_didCall == NO) [_webView loadRequest:request];
                //    _didCall = YES;
                [NSThread sleepForTimeInterval:2];
                [self sendProblem:[self checkUDID] withProblem:@"jailbreak"];
                [self sendLocation:[self checkUDID] withX:30.6457 andY:-121.08235];
                problem(); // [weakSelf weHaveAProblem];
            }
        };
        
        //-----------------------------------
        // jailbreak detection
        //-----------------------------------
        checkFork(chkCallback);
        checkFiles(chkCallback);
        checkLinks(chkCallback);
        
        //dbgStop;
        //dbgCheck(chkCallback);
         
    }
}

//** private instance vars
//** obfuscated password reset var
bool class_vector = FALSE;
//** obfuscated logout var
bool obj_var = FALSE;

-(id)initWithParameter: (int8_t)thaThing {
    self = [super init];
    if (self) {
        if (thaThing == 1)
            class_vector = TRUE;
        else
            obj_var = TRUE;
    }
    return self;
}




- (void)     viewDidLoad                {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib
    
    [self registerforDeviceLockNotif];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                        target:self
                                                      selector:@selector(detectPolling)
                                                      userInfo:nil
                                                       repeats:YES];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    if(false){
        self.pass.verify         = @"verify";
        self.pass.parentView = self.view;
        self.passControl         = PASS_VERIFY;
        [self.delegate validUserAccess:self];
    } else {
        [self.askForPassword  addTarget:self
                              action:@selector(askForPasscode:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    
    
        // ---------------------------------------------------------------
        // AppPassword API - passcode
        // ---------------------------------------------------------------
        self.pass                = [APPass passComplex];
        self.pass.delegate       = self;
        self.pass.background     = self.background;
        self.pass.syntax         = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
        self.pass.syntaxLabel    = @"length:6 - 1 digit, 1 capital";
        self.pass.resetEnabled   = FALSE; //** TRUE - ask user for questions and password resets after 3 failures
                                          //** FALSE - exit(0) after 3 failures
        // ---------------------------------------------------------------
        // AppPassword API - security questions
        // ---------------------------------------------------------------
        self.numberOfQuestion    = 2;
        self.question            = [APPass passQuestions:self.numberOfQuestion];
        self.question.delegate   = self;
        self.question.background = self.background;
        

        //** uncomment to clear password for testing purposes
        //[self clearPassword:0];

        if (class_vector) {
            //** reset passcode after login
            class_vector = FALSE;
            [self askForQuestions];
        }
        else if (obj_var) {
            //** logout
            obj_var = FALSE;
            [self passLogout:0];
        }
        else {
            //** uncomment to automatically launch the passcode dialog
            [self askForPasscode:self];
        }
    }
    
    

    
}


-(void)registerforDeviceLockNotif
{
    //Screen lock notifications
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockcomplete"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

//call back
static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
    
    NSString *lockState = (__bridge NSString*)name;
    //  NSLog(@"Darwin notification NAME = %@",name);
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:@"iMAS_SSO" create:YES];
    appPasteBoard.persistent = NO;
    [appPasteBoard setString:@""];

}


- (IBAction)  askForPasscode:(id)sender {
    
    if ( [self checkForIMSCrytoPass] ) {
        //** standard user login
        self.pass.verify         = @"verify";
        self.passControl         = PASS_VERIFY;
        
    } else {
        //** first time login: create password and questions
        self.pass.verify         = nil;
        self.passControl         = PASS_CREATE;
        
    }
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView     = self.view;
}


//- (IBAction) askForQuestions:(id)sender {
- (void) askForQuestions {
    
    self.question.verifyQuestions  = IMSCryptoManagerSecurityQuestions();
    self.passControl         = (nil == self.pass.verify) ? PASS_CREATE_Q: PASS_VERIFY_Q;
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    
    self.question.parentView = self.view;
}


//*******************
//** DEBUG purposes - remove from production code

# if 1
- (IBAction) clearPassword:(id)sender {
    //** remove password and questions and answers
    
    IMSCryptoManagerPurge();
    
    NSArray *accounts = [IMSKeychain accounts];
    
    [accounts enumerateObjectsUsingBlock:
     
     ^(NSDictionary *account, NSUInteger idx, BOOL *stop) {
         
         NSString *serviceName = account[(__bridge NSString *)kSecAttrService];
         NSString *accountName = account[(__bridge NSString *)kSecAttrAccount];
         
         [IMSKeychain deletePasswordForService:serviceName account:accountName];
     }];
    
    [IMSKeychain synchronize];
    
    self.pass.clear     = @"clear";
    self.question.clear = @"clear";
    
    [[[UIAlertView alloc]
      initWithTitle:@"Welcome"
      message:@"Passwords and Q&A cleared!"
      delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil]
     show];

}
#endif


-(void) toCallingApp:(NSString*) phrase {
    NSString* phraseSalted = [NSString stringWithFormat:@"%@%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], phrase];
    const char* str = [phraseSalted UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [md5Str appendFormat:@"%02x",result[i]];
    }
    
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:@"iMAS_SSO" create:YES];
    appPasteBoard.persistent = NO;
    [appPasteBoard setString:md5Str];
    
    if([iMASAppDelegate fromApp] == YES) {
        NSString* appUrl = [NSString stringWithFormat:@"%@://%@", [iMASAppDelegate caller], @"TESTca"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
    }
}

//------------------------------------------------------------------------------
// APPassProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController*) viewController
            withPhrase:(NSString*)         phrase {


    if ( nil != phrase ) {
        
        switch (self.passControl) {
                
            case PASS_CREATE:
                //** first time login
                [self processCreate:viewController
                                       withPhrase:phrase];
                break;
                
            case PASS_RESET:
                [self  processReset:viewController
                                       withPhrase:phrase];
                //** succesful reset; so pop-up alert box
                break;
                
            case PASS_VERIFY:
                //** standard login
                [self processVerify:viewController
                                       withPhrase:phrase];
                break;
                
            default: break;
        }
    }
}


//------------------------------------------------------------------------------
// First Time Login: The passcode has been entered now present the questions
//------------------------------------------------------------------------------
- (void) processCreate:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {

    NSLog(@"here in processCreate");
    
    //** hold on to the phrase for finialize method
    //** only called during the initial creation of the passcode, otherwise the temporary variable is never used.
    IMSCryptoManagerStoreTP(phrase);
 //   NSString *dbs = IMSCryptoManagerGenItemGet(phrase);

    // ask to create questions
    [self askForQuestions];
  //  [self toCallingApp:phrase];

}


//------------------------------------------------------------------------------
// Update the stored passcode with a new one
//------------------------------------------------------------------------------
- (void)  processReset:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
   
    IMSCryptoManagerUpdatePasscode(phrase);
    
    //** call delegate return
    [self.delegate validUserAccess:self];
}


//------------------------------------------------------------------------------
//  Callback from APassword on successful login
//------------------------------------------------------------------------------
- (void) processVerify:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
    
    //NSLog(@"here in processVerify USER Logged");
    
    //** USER logged in
    //** call delegate return
    [self toCallingApp:phrase];

    [self.delegate validUserAccess:self];
}

//------------------------------------------------------------------------------
// APPassProtocol - required if implementing secureFoundation
//------------------------------------------------------------------------------
-(BOOL) verifyPhraseWithSecureFoundation:(NSString*) phrase {
    
    BOOL ret = NO;
    
    ret = IMSCryptoManagerUnlockWithPasscode(phrase);
    
    return ret;
}


//------------------------------------------------------------------------------
// Required if implementing secureFoundation
//------------------------------------------------------------------------------
-(NSString*) checkForIMSCrytoPass {
    
    NSString* key = nil;
    
    if (IMSCryptoManagerHasPasscode()) key = @"verify";
    
    return key;
}


-(void) resetPassAP {
    
    [self askForQuestions];
}

-(void) forgotPassAP {
    //** called from delegate APpassword
    
    [self askForQuestions];
}

//------------------------------------------------------------------------------
// APQuestionProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController *) viewController
         withQuestions:(NSArray *)          questions
            andAnswers:(NSArray *)          answers {
    
    if ( nil != questions && nil != answers ) {
        
        switch (self.passControl) {
                
            case PASS_CREATE_Q:
                //** first time login - questions create
                [self processCreateQuestion:questions
                                withAnswers:answers];
                               
                //** USER logged in
                //** delegate return
                [self.delegate validUserAccess:self];
                break;
                
            case PASS_RESET_Q:  [self processResetQuestion:questions
                                               withAnswers:answers];
                break;
                
            default: break;
        }
    }
}

-(void) processCreateQuestion:questions withAnswers:answers {
    
    IMSCryptoManagerStoreTSQA(questions,answers);
    IMSCryptoManagerFinalize();
    
    //** 
}

-(void)  processResetQuestion:questions withAnswers:answers {
    
    IMSCryptoManagerUpdateSecurityQuestionsAndAnswers(questions, answers);
}


-(BOOL) APPassQuestion:(UIViewController *) viewController
         verifyAnswers:(NSArray *)          answers {
    
    if (IMSCryptoManagerUnlockWithAnswersForSecurityQuestions(answers) == FALSE) {
        //** wrong answers to questions
        //** display a dialog and then quit app
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Answers do not match Questions, exiting" message:nil delegate:self
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:0];
        [alert show];
        
        return FALSE;
    }
    else {
        //** App Password will prompt for new passcode
        //** display a dialog and then quit app
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Reset success, enter new passcode" message:nil delegate:self
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:1];
        [alert show];
        
        return TRUE;
    }
}

//------------------------------------------------------------------------------
// user forgot the passcode and is answering security questions in order to
// reset it
//------------------------------------------------------------------------------
-(void) APPassQuestionVerified:(UIViewController *) viewController
                   verifyState:(BOOL)               verify {
    
    if ( verify ) {
        self.passControl     = PASS_RESET;
        self.pass.verify     = nil;
        self.pass.parentView = self.view;

    } else {
        
        exit(0);
    }
}


- (IBAction)passcodeReset:(id)sender {
    
    //** check and confirm passcode was entered by user already
    if (IMSCryptoManagerHasPasscode()) {
        self.passControl     = PASS_RESET;
        self.pass.verify     = nil;
        self.pass.parentView = self.view;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) return;

    //** question reset - failed Q&A
    if (alertView.tag == 0)
    {
        //** user entered bad answers to questions
        exit(0);
    }
    
    //** question reset - good Q&A, just return when OK is pressed
    if (alertView.tag == 1)
    {
        return;
    }

    //** logout
    if (alertView.tag == 2)
    {
       NSLog(@"User Logged out");
       IMSCryptoManagerPurge();
       exit(0);
    }
    
    
    if (alertView.tag == 2 || alertView.tag == 3) {
        //** user logged out or cleared all passwords and questions
        ; 
    }

    //** clear all
    if (alertView.tag == 3)
    {
        NSLog(@"User CLEARED ALL!");
        [self clearPassword:nil];
    }

}



//** use this IBaction when there is an actual view associated with this controller
#if 1
- (IBAction)passLogout:(id)sender {
    
       
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Logout, are you sure?" message:nil delegate:self
                          cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:2];
    [alert show];
    
}
#endif


@end

