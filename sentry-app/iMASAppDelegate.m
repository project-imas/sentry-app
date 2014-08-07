//
//  iMASAppDelegate.m
//  APSampleApp
//
//  Created by Ganley, Gregg on 8/22/13.
//  Copyright (c) 2013 MITRE Corp. All rights reserved.
//

#import "iMASAppDelegate.h"
#import "APViewController.h"
//#import "iMASMainViewController.h"
#import "iMASMainTableViewController.h"
#import "constants.h"
#import "iMASSecurityCheckTableViewController.h"
#import <Filter.h>
#import "iMASSysMonitorTableViewController.h"


@implementation iMASAppDelegate

//@synthesize window = _window;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//@synthesize navigationController=_navigationController;

CLLocationManager *locationManager;
CLCircularRegion *region;

BOOL fromApp = NO;
NSString* callerURI = @"";
NSString* pbName;

+ (NSString*) caller {
    return callerURI;
}

+ (NSString*) pasteboardName {
    return pbName;
}

+ (BOOL) fromApp {
    BOOL tmp = fromApp;
    fromApp = NO;
    return tmp;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {    
    pbName = [url host];
    callerURI = [[url path] substringFromIndex:1];
    fromApp = YES;
    
    return YES;
}

- (void)performLaunchSteps {

    APViewController *apc = [[APViewController alloc] init];
    apc.delegate = self;
    
    self.window.rootViewController = apc; //navController;
    [self.window makeKeyAndVisible];
#if 0
    [[[UIAlertView alloc]
      initWithTitle:@"Welcome"
      message:@"Before you start using App, you must set a passcode."
      delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil]
     show];
#endif
}

- (void)validUserAccess:(APViewController *)controller {
    NSLog(@"validUserAccess - Delegate");

    UINavigationController *loginController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTableViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //iMASMainViewController *controller = (iMASMainViewController *)self.window.rootViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    
    // redirect NSLog to file (for displaying in app)
    [self redirectConsoleLogToDocumentFolder];
    
    //Passcode Check
    [self checkPasscode];
    
    // store/load settings for sentry app (in keychain?)
    [self loadSettings];
    
    //Geolocation
    locationManager = [[CLLocationManager alloc]init];
    CLLocationCoordinate2D coordinates = { .latitude = 37.33, .longitude = -122.02 };
    region = [[CLCircularRegion alloc] initWithCenter:coordinates radius:10. identifier:@"Fence"];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringForRegion:region];
    
    
    [self performLaunchSteps];
    
    return YES;
}

- (void)loadSettings {
    /* Security Check settings */
    
    // default to off (for testing with Xcode debugger attached)
    if (![IMSKeychain passwordForService:serviceName account:@"dbgCheck"])
        [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"dbgCheck"];
    if (![IMSKeychain passwordForService:serviceName account:@"jailbreakCheck"])
        [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"jailbreakCheck"];
    
    /* System Monitor settings */
    
    // demo filter
    Filter *filter1 = [[Filter alloc] initWithOptions:@"Social Media" info:@"ConnectionInfo" type:@"blacklist" field:@"foreign address" list:[NSArray arrayWithObjects:@"facebook",@"twitter",nil]];
    self.filters = [[NSMutableArray alloc] initWithObjects:filter1, nil];
//    [self.filters addObject:filterDict];
    
    /*
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"filters.plist"];
    NSLog(@"loadData write path: %@", path);
     */
    
//    NSArray *filtersTest = [NSArray arrayWithArray:self.filters];
//    NSLog(@"loadSettings filters array not from file: %@",filtersTest);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"filters.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:path error:&error];
//        error = nil;
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"filters" ofType:@"plist"];
        NSError *error;
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    if (![self.filters writeToFile:path atomically:YES]) { // TODO: LOAD FROM FILE FIRST INSTEAD OF JUST OVERWRITING
        NSLog(@"failed to save filter settings to file");
    }
    
    // test
//    self.filters = [NSArray arrayWithContentsOfFile:path];
//    NSLog(@"loadSettings filters array from file: %@",self.filters);
}

-(void)checkPasscode
{
    
    if([iMAS_PasscodeCheck isPasscodeSet]){
        NSLog(@"isPasscodeSet TRUE");
    }
    else{
        NSLog(@"isPasscodeSet FALSE");
        // TODO: React to insecure device here
        // Limit functionality, kill app, and/or phone home
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"did enter background");
    //** blank out root window
    self.window.rootViewController = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*if (!self.passcodeViewController.view.window) {
        [self.window.rootViewController presentModalViewController:self.passcodeViewController animated:NO];
    }*/

    //ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    NSLog(@"did become active");
    [self performLaunchSteps];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"APSampleApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"APSampleApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//Geolocation functions
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //UIAlertView *errorAlert = [[UIAlertView alloc]
    //                           initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"Update: %@", locations.lastObject);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered fence");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited fence");
    //React to device leaving fence
}

- (void) redirectConsoleLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    // TODO: APPEND OR SOMETHIG TO FILE?
    NSError *error = nil;
    [@"" writeToFile:logPath atomically:NO encoding:NSUTF8StringEncoding error:&error]; // wipe file before writing to it??
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

@end
