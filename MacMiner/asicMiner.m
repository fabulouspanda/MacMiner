//
//  asicminerViewController.m
//  MacMiner
//
//  Created by John O'Mara on 01/05/2013.
//  Copyright (c) 2013 John O'Mara. All rights reserved.


#import "asicMiner.h"
#import "AppDelegate.h"

#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdint.h>
#include <sys/types.h>

#include "compat.h"

#ifndef WIN32
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define SOCKETTYPE int
#define SOCKETFAIL(a) ((a) < 0)
#define INVSOCK -1
#define CLOSESOCKET close

#define SOCKETINIT do{}while(0)

#define SOCKERRMSG strerror(errno)
#else
#include <winsock2.h>

#define SOCKETTYPE SOCKET
#define SOCKETFAIL(a) ((a) == SOCKET_ERROR)
#define INVSOCK INVALID_SOCKET
#define CLOSESOCKET closesocket

static char WSAbuf[1024];

struct WSAERRORS {
    int id;
    char *code;
} WSAErrors[] = {
    { 0,			"No error" },
    { WSAEINTR,		"Interrupted system call" },
    { WSAEBADF,		"Bad file number" },
    { WSAEACCES,		"Permission denied" },
    { WSAEFAULT,		"Bad address" },
    { WSAEINVAL,		"Invalid argument" },
    { WSAEMFILE,		"Too many open sockets" },
    { WSAEWOULDBLOCK,	"Operation would block" },
    { WSAEINPROGRESS,	"Operation now in progress" },
    { WSAEALREADY,		"Operation already in progress" },
    { WSAENOTSOCK,		"Socket operation on non-socket" },
    { WSAEDESTADDRREQ,	"Destination address required" },
    { WSAEMSGSIZE,		"Message too long" },
    { WSAEPROTOTYPE,	"Protocol wrong type for socket" },
    { WSAENOPROTOOPT,	"Bad protocol option" },
    { WSAEPROTONOSUPPORT,	"Protocol not supported" },
    { WSAESOCKTNOSUPPORT,	"Socket type not supported" },
    { WSAEOPNOTSUPP,	"Operation not supported on socket" },
    { WSAEPFNOSUPPORT,	"Protocol family not supported" },
    { WSAEAFNOSUPPORT,	"Address family not supported" },
    { WSAEADDRINUSE,	"Address already in use" },
    { WSAEADDRNOTAVAIL,	"Can't assign requested address" },
    { WSAENETDOWN,		"Network is down" },
    { WSAENETUNREACH,	"Network is unreachable" },
    { WSAENETRESET,		"Net connection reset" },
    { WSAECONNABORTED,	"Software caused connection abort" },
    { WSAECONNRESET,	"Connection reset by peer" },
    { WSAENOBUFS,		"No buffer space available" },
    { WSAEISCONN,		"Socket is already connected" },
    { WSAENOTCONN,		"Socket is not connected" },
    { WSAESHUTDOWN,		"Can't send after socket shutdown" },
    { WSAETOOMANYREFS,	"Too many references, can't splice" },
    { WSAETIMEDOUT,		"Connection timed out" },
    { WSAECONNREFUSED,	"Connection refused" },
    { WSAELOOP,		"Too many levels of symbolic links" },
    { WSAENAMETOOLONG,	"File name too long" },
    { WSAEHOSTDOWN,		"Host is down" },
    { WSAEHOSTUNREACH,	"No route to host" },
    { WSAENOTEMPTY,		"Directory not empty" },
    { WSAEPROCLIM,		"Too many processes" },
    { WSAEUSERS,		"Too many users" },
    { WSAEDQUOT,		"Disc quota exceeded" },
    { WSAESTALE,		"Stale NFS file handle" },
    { WSAEREMOTE,		"Too many levels of remote in path" },
    { WSASYSNOTREADY,	"Network system is unavailable" },
    { WSAVERNOTSUPPORTED,	"Winsock version out of range" },
    { WSANOTINITIALISED,	"WSAStartup not yet called" },
    { WSAEDISCON,		"Graceful shutdown in progress" },
    { WSAHOST_NOT_FOUND,	"Host not found" },
    { WSANO_DATA,		"No host data of that type was found" },
    { -1,			"Unknown error code" }
};

static char *WSAErrorMsg()
{
    int i;
    int id = WSAGetLastError();
    
    /* Assume none of them are actually -1 */
    for (i = 0; WSAErrors[i].id != -1; i++)
        if (WSAErrors[i].id == id)
            break;
    
    sprintf(WSAbuf, "Socket Error: (%d) %s", id, WSAErrors[i].code);
    
    return &(WSAbuf[0]);
}

#define SOCKERRMSG WSAErrorMsg()

static WSADATA WSA_Data;

#define SOCKETINIT	do {  \
int wsa; \
if ( (wsa = WSAStartup(0x0202, &WSA_Data)) ) { \
printf("Socket startup failed: %d\n", wsa); \
return 1; \
}  \
} while (0)

#ifndef SHUT_RDWR
#define SHUT_RDWR SD_BOTH
#endif
#endif

#define RECVSIZE 65500

static const char SEPARATOR = '|';
static const char COMMA = ',';
static const char EQ = '=';
static int ONLY;
//endAPIStuff

@implementation asicMiner



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];


        
        self.asicAPIOutput.delegate = self;
        
        
        self.acceptLabel.tag = 1;
        
        self.apiDataArray = [[NSMutableArray alloc] init];

        [self startToggling];
        
            toggleTimer = [NSTimer scheduledTimerWithTimeInterval:250. target:self selector:@selector(startToggling) userInfo:nil repeats:YES];
        
        self.prefs = [NSUserDefaults standardUserDefaults];
        
        [self.prefs synchronize];
        
        self.minerAddressesArray = [[NSMutableArray alloc] init];
//        self.minerAddressesArray = [self.prefs objectForKey:@"ipAddress"];

 
    }
    
    
    
    return self;
}



-(void)stopAsicMiner
{
    // change the button's title back for the next search
    [self.asicStartButton setTitle:@"Start"];
//    [self stopToggling];
    // This stops the task and calls our callback (-processFinished)
    [asicTask stopTask];
    findRunning=NO;
    
    // Release the memory for this wrapper object
    
    asicTask=nil;
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.asicReadBack setHidden:YES];
    [appDelegate.asicReading setHidden:YES];
    [[NSApp dockTile] display];
    appDelegate = nil;
    
    return;
}

- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [self.asicStartButton setTitle:@"Start"];
        self.asicStartButton.tag = 1;
//        [self stopToggling];
        // This stops the task and calls our callback (-processFinished)
        [asicTask stopTask];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        asicTask=nil;
        
self.megaHashLabel.stringValue = @"0";
        self.megaHashLabel.tag = 0;
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

        [appDelegate.asicReadBack setHidden:YES];
        [appDelegate.asicReading setHidden:YES];
        [[NSApp dockTile] display];
        appDelegate = nil;

        return;
    }
    else
    {
        [self.asicStartButton setTitle:@"Stop"];
                self.asicStartButton.tag = 0;

    //            self.asicAPIOutput.string = @"";
        [self.asicAPIOutput delete:nil];


        
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }


        

        
        [self.prefs synchronize];
        

        self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
        self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
        self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
        self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
        NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];

        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"R:0/0", nil];
        if ([self.bonusOptions isNotEqualTo:@""]) {
            NSArray *deviceItems = [self.bonusOptions componentsSeparatedByString:@" "];

            [launchArray addObjectsFromArray:deviceItems];
        }
        

        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        if (self.bigpicEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bigpic:all"];
        }
        if (self.antminerEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"antminer:all"];
        }
        if (self.bflEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bfl:all"];
        }
        if (self.bitfuryEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bifury:all"];
        }
        if (self.erupterEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"erupter:all"];
        }

                NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];
            if ([saveLogFile isNotEqualTo:nil]) {
            [launchArray addObject:@"--debuglog"];
            [launchArray addObject:@"-L"];
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
            
            NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
            
            NSString *btcConfig = @"";
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            if ([fileManager fileExistsAtPath:userpath] == YES) {
                btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            }
            
            NSString *acceptString = @"";
            
            if (btcConfig.length >= 20) {
                acceptString = [self getDataBetweenFromString:btcConfig
                                                   leftString:@"user" rightString:@"," leftOffset:9];
            }
            
            NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;
            
            
            NSString *logFile = [userpath stringByAppendingString:[@"/" stringByAppendingString:[bfgUserValue stringByAppendingString:[dateString stringByAppendingString:@".txt"]]]];

            [launchArray addObject:logFile];
        }
        
        if ([self.noGPU isNotEqualTo:nil]) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        
            cpuThreads = nil;
        

        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        


        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];

        [self.asicOutputView setString:@""];

       asicTask =[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                        arguments:launchArray
                                      environment:nil
                                         delegate:self];
        // kick off the process asynchronously

        [asicTask startTask];

        
    }
    
}

- (void)toggleLoopTimerFired:(NSTimer*)timer
{
//    NSLog(@"Loop1");
    

    NSString *apiOutputString = @"";
    if (self.asicAPIOutput.string != nil) {
    apiOutputString = self.asicAPIOutput.string;
    }
    
       AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    if(apiOutputString.length >= 10) {
        
    [self.prefs synchronize];
    
    NSRange range = NSMakeRange(0, [[self.apiTableViewController arrangedObjects] count]);
    [self.apiTableViewController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];

    if ([apiOutputString rangeOfString:@"GPU0"].location != NSNotFound || [apiOutputString rangeOfString:@"PGA0"].location != NSNotFound || [apiOutputString rangeOfString:@"ASC0"].location != NSNotFound) {

        NSMutableArray *locationMapArray = [[NSMutableArray alloc] init];
        
        if (appDelegate.asicReadBack.isHidden == NO) {
            [locationMapArray addObject:@"This Machine"];
        }
        else if (appDelegate.cgReadBack.isHidden == NO) {
            [locationMapArray addObject:@"This Machine"];
        }
        else if (appDelegate.bfgReadBack.isHidden == NO) {
            [locationMapArray addObject:@"This Machine"];
        }
        
        if (self.minerAddressesArray.count >= 1) {
            [locationMapArray addObjectsFromArray:self.minerAddressesArray];
        }
        
//        NSString *logIt = [locationMapArray componentsJoinedByString:@", "];
//        NSLog(logIt);

        
        NSArray *minerOutputArray = [apiOutputString componentsSeparatedByString:@"[Data for"];

        int k = minerOutputArray.count;
        
        for (int j = 0; j < k; j++) {
            
            if (j > minerOutputArray.count || j > locationMapArray.count) {
                break;
            }

            NSString *currentOutputString = [minerOutputArray objectAtIndex:j];
        

    if ([currentOutputString rangeOfString:@"GPU0"].location != NSNotFound) {
        


        for (int i = 0; i >= 0; i++) {


            
            NSString *pgaCount = [NSString stringWithFormat:@"GPU%d", i];
            
            if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {

                    i = 0;
                    pgaCount = [NSString stringWithFormat:@"GPU%d", i];
                                if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {
                                    break; break;
                                }

                }
            
            

            
            
                        if ([currentOutputString rangeOfString:pgaCount].location != NSNotFound) {
            
            NSString *pgaAPIData = [self getDataBetweenFromString:currentOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
            NSString *mhs5S = @"";
                            if ([currentOutputString rangeOfString:@"20s"].location != NSNotFound) {
            mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"20s] =>" rightString:@"[" leftOffset:8];
                                                    }
                            else {
            mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
                            }
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
            NSString *apiIntensity = [self getDataBetweenFromString:pgaAPIData leftString:@"sity] =>" rightString:@"[" leftOffset:8];

            NSString *apiName = pgaCount;
            
            [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",@" ",@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",apiIntensity,@"intensity", @" ", @"location", nil]];
            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            NSString *apiPoolString = @"unknown";
            
            NSString *coinChoiceString = @"unknown";
            
            NSString *algorithmString = @"unknown";
            
            if ([self.prefs objectForKey:@"gpuAlgoChoice"] != nil) {
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
coinChoiceString = @"Scrypt";
algorithmString = @"Scrypt";
                    if ([self.prefs stringForKey:@"defaultLTCPoolValue"] != nil) {
                    apiPoolString = [self.prefs stringForKey:@"defaultLTCPoolValue"];
                    }
                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
                    coinChoiceString = @"ScryptN";
                    algorithmString = @"ScryptN";
                    if ([self.prefs stringForKey:@"defaultVTCPoolValue"] != nil) {
                        apiPoolString = [self.prefs stringForKey:@"defaultVTCPoolValue"];
                    }
                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
                    coinChoiceString = @"Bitcoin";
                    algorithmString = @"SHA256d";
                    if ([self.prefs stringForKey:@"defaultPoolValue"] != nil) {
                      apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                    }

                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
                    coinChoiceString = @"MaxCoin";
                    algorithmString = @"Keccak";
                    if ([self.prefs stringForKey:@"defaultMAXPoolValue"] != nil) {
                        apiPoolString = [self.prefs stringForKey:@"defaultMAXPoolValue"];
                    }
                }
            }
            
            
            apiPoolString = nil;
            apiName = nil;
        
                    currentOutputString = [currentOutputString stringByReplacingOccurrencesOfString:pgaAPIData withString:@""];
            
        }
                        else {
                            break;
                        }
        }
        
    }
    
    if ([currentOutputString rangeOfString:@"PGA0"].location != NSNotFound) {
        
        
        for (int i = 0; i >= 0; i++) {
            

            
            NSString *pgaCount = [NSString stringWithFormat:@"PGA%d", i];
            
            if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {

                i = 0;
                                        pgaCount = [NSString stringWithFormat:@"PGA%d", i];
                            if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {
                                break; break;
                            }
            }
            
            
            
            if ([currentOutputString rangeOfString:pgaCount].location != NSNotFound) {
            
            NSString *pgaAPIData = [self getDataBetweenFromString:currentOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            //                                NSLog(pgaCount);
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
                NSString *mhs5S = @"";
                if ([currentOutputString rangeOfString:@"20s"].location != NSNotFound) {
                    mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"20s] =>" rightString:@"[" leftOffset:8];
                }
                else {
                    mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
                }
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
            NSString *apiNameOrigin = [self getDataBetweenFromString:pgaAPIData leftString:@"[Name] =>" rightString:@"[" leftOffset:10];
                int r = arc4random_uniform(74);
                NSString *apiName = [NSString stringWithFormat:apiNameOrigin, "%d", r];
            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:apiName,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity", @" ", @"location", nil]];
                
                
                NSString *apiPoolString = @"unknown";
                if ([self.prefs stringForKey:@"defaultPoolValue"] != nil) {
                apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                }
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                
            }
            else {
                NSString *apiTemp = @"0";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:apiName,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity", @" ", @"location", nil]];
                
                
                NSString *apiPoolString = @"unknown";
                if ([self.prefs stringForKey:@"defaultPoolValue"] != nil) {
                    apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                }
                
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                
            }
            
                                         currentOutputString = [currentOutputString stringByReplacingOccurrencesOfString:pgaAPIData withString:@""];
            
            pgaCount = nil;
            pgaAPIData = nil;
            apiStatus = nil;
            mhsAv = nil;
            mhs5S = nil;
            apiAccepted = nil;
            apiRejected = nil;
            apiHWError = nil;
            apiUtility = nil;
            apiDiff1 = nil;
            apiDiffAcc = nil;
            apiDiffRej = nil;
            
            }
            else {
                break;
            }

            
            
        }
        
        
        
    }
    
    if ([currentOutputString rangeOfString:@"ASC0"].location != NSNotFound) {
        
        
        for (int i = 0; i >= 0; i++) {
            


            
            NSString *pgaCount = [NSString stringWithFormat:@"ASC%d", i];
            
            if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {

                    i = 0;
                                pgaCount = [NSString stringWithFormat:@"ASC%d", i];
                                if ([currentOutputString rangeOfString:pgaCount].location == NSNotFound) {
                                    break; break;
                                }
            }
            
            
            
            if ([currentOutputString rangeOfString:pgaCount].location != NSNotFound) {
            
            NSString *pgaAPIData = [self getDataBetweenFromString:currentOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            //                                NSLog(pgaCount);
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
                NSString *mhs5S = @"";
                if ([currentOutputString rangeOfString:@"20s"].location != NSNotFound) {
                    mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"20s] =>" rightString:@"[" leftOffset:8];
                }
                else {
                    mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
                }
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
                NSString *apiNameOrigin = [self getDataBetweenFromString:pgaAPIData leftString:@"[Name] =>" rightString:@"[" leftOffset:10];
                int r = arc4random_uniform(74);
                NSString *apiName = [NSString stringWithFormat:apiNameOrigin, "%d", r];

            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:apiName,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity", @" ", @"location", nil]];
                
                
                NSString *apiPoolString = @"unknown";
                if ([self.prefs stringForKey:@"defaultPoolValue"] != nil) {
                    apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                }

                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                
            }
            else {
                
                NSString *apiTemp = @"0";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:apiName,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity", @" ", @"location", nil]];
                
                
                NSString *apiPoolString = @"unknown";
                if ([self.prefs stringForKey:@"defaultPoolValue"] != nil) {
                    apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                }
                
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;

            }
            
            currentOutputString = [currentOutputString stringByReplacingOccurrencesOfString:pgaAPIData withString:@""];
            
            pgaCount = nil;
            pgaAPIData = nil;
            apiStatus = nil;
            mhsAv = nil;
            mhs5S = nil;
            apiAccepted = nil;
            apiRejected = nil;
            apiHWError = nil;
            apiUtility = nil;
            apiDiff1 = nil;
            apiDiffAcc = nil;
            apiDiffRej = nil;

            
            
        }
            else {
                break;
            }
        }

    }
    }
    }
    
    [self.apiTableView reloadData];
    [self.apiTableView setNeedsDisplay:YES];
            


    }

    appDelegate = nil;

}

-(void)apiAbstraction {
                     AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
         [appDelegate.outputMathString setString:@""];
    
    
    char *command = "devs";
    const char *host = "127.0.0.1";

    if ([appDelegate.asicReadBack isHidden] == NO) {
    command = "devs";
    host = "127.0.0.1";
    short int port = 4028;
    
    
    callapi(command, host, port);
    }
    
    if ([appDelegate.cgReadBack isHidden] == NO) {
        command = "devs";
        host = "127.0.0.1";
        short int port = 4048;
        
        
        callapi(command, host, port);
    }
    if ([appDelegate.bfgReadBack isHidden] == NO) {
        command = "devs";
        host = "127.0.0.1";
        short int port = 4052;
        
        callapi(command, host, port);
    }
    
    if (self.minerAddressesArray.count >= 1) {
        int i;
        int q;
        q = self.minerAddressesArray.count-1;
        
        for (i = 0; i <= q; i++) {
            
            if ([self.minerAddressesArray objectAtIndex:i]) {
                
                NSString *itemString = [self.minerAddressesArray objectAtIndex:i];
                NSString *ipString = @"";
                NSString *portString = @"";
                if ([itemString rangeOfString:@":"].location != NSNotFound) {
                    
                    NSURL *url = [NSURL URLWithString:itemString];
                    
                    ipString = [url host];
                    portString = [[url port] stringValue];
                    
                    //                NSLog(@"host: %@", [url host]);
                    //                NSLog(@"port: %@", [url port]);
                    
                    
                    char *command = "devs";
                    const char *host = "127.0.0.1";
                    host = [ipString UTF8String];
                    short int port = portString.intValue;
                    
                    callapi(command, host, port);
                }
                else {
                    if (itemString.length <= 4) {
                        command = "devs";
                        host = "127.0.0.1";
                        short int port = itemString.intValue;
                        
                        callapi(command, host, port);
                    }
                    command = "devs";
                    
                    host = [itemString UTF8String];
                    short int port = 4028;
                    
                    callapi(command, host, port);
                }
                
            }
        }
        
    }

 

    
    appDelegate = nil;

}

- (void)toggleTimerFired:(NSTimer*)timer
{
//        NSLog(@"Loop2");

    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.prefs synchronize];
    
    NSString *speechSetting = [self.prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }
    
    else if ([self.megaHashLabel.stringValue isEqual: @"0"] && self.megaHashLabel.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    speechSetting = nil;

    
    if ([self.megaHashLabel.stringValue isNotEqualTo:@"0"]) {
        self.megaHashLabel.tag = 1;
    }

    
    if (findTwoRunning == YES) {
        [apiTask stopTask];
        apiTask = nil;
        findTwoRunning = NO;
    }
    else {

        // If the task is still sitting around from the last run, release it
        if (apiTask!=nil) {
            apiTask = nil;
        }
        
        if (self.acceptLabel.tag == 0) {
        self.acceptLabel.tag = 1;
        }
        else {
        self.acceptLabel.tag = 0;
        }
        

}
    
        self.asicAPIOutput.string = [NSString stringWithString:appDelegate.outputMathString];
   [self performSelectorInBackground:@selector(apiAbstraction) withObject:nil];

    appDelegate = nil;
}


- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didProduceOutput:(NSString *)output
{
//    NSLog(@"output");
    output = [output substringToIndex:[output length]-1];
    
    if ([output rangeOfString:@"Reply was"].location != NSNotFound) {
        
        
        if([output hasPrefix:@"R"] && [output hasSuffix:@")"]) {

//            self.asicAPIOutput.string = @"";
            
//            [self.asicAPIOutput delete:nil];
//            [self.asicAPIOutput didChangeText];
            
//            self.asicAPIOutput.string = output;

        }
        
    }
        output = nil;
}

- (void)taskTwoWrapperWillStartTask:(taskTwoWrapper *)taskTwoWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    findTwoRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    //    [asicStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    findTwoRunning=NO;


    
}

- (void)stopToggling
{
    [loopTimer invalidate];
    loopTimer = nil;  // you don't want dangling pointers...
    
    // perform any other needed house-keeping here
                            [self.asicStartButton setTitle:@"Start"];
}


- (void)startToggling
{
    [timerTimer invalidate];
    timerTimer = nil;
    [loopTimer invalidate];
    loopTimer = nil;  // you don't want dangling pointers...
    
//    if ([asicStartButton.title isEqual: @"Start"]) {


//            [asicStartButton setTitle:@"Stop"];
//    [self stopToggling:self];
    
    loopTimer = [NSTimer scheduledTimerWithTimeInterval:6. target:self selector:@selector(toggleLoopTimerFired:) userInfo:nil repeats:YES];
        timerTimer = [NSTimer scheduledTimerWithTimeInterval:6. target:self selector:@selector(toggleTimerFired:) userInfo:nil repeats:YES];
    
//    }


}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    
    
    [self.prefs synchronize];
    
    NSString *speechSetting = [self.prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }

    else if ([output rangeOfString:@"auth failed"].location != NSNotFound) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Authorisation Failed"];
    }
    
    if ([output rangeOfString:@"s:"].location != NSNotFound) {
        self.numberString = [self getDataBetweenFromString:output
                                                     leftString:@"s" rightString:@"a" leftOffset:2];
        self.megaHashLabel.stringValue = [self.numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.numberString = nil;
    }
        if ([output rangeOfString:@"A:"].location != NSNotFound) {
        self.acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        self.acceptLabel.stringValue = [self.acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        self.acceptString = nil;
        }
        if ([output rangeOfString:@"R:"].location != NSNotFound) {
        self.rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"+" leftOffset:0];
        self.rejecttLabel.stringValue = [self.rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        self.rejectString = nil;
        }
    
        if ([output rangeOfString:@"kh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Kh";
        }
        if ([output rangeOfString:@"Mh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Mh";
        }
        if ([output rangeOfString:@"Gh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Gh";
        }
        
        
        
        if ([self.prefs objectForKey:@"showDockReading"] != nil) {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate.bfgReadBack setHidden:YES];
            [appDelegate.bfgReading setHidden:YES];
            [[NSApp dockTile] display];
            appDelegate = nil;
        }
        else
        {
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.asicReading.stringValue = [self.megaHashLabel.stringValue stringByAppendingString:self.asicHashField.stringValue];
            [appDelegate.asicReadBack setHidden:NO];
            [appDelegate.asicReading setHidden:NO];
            [[NSApp dockTile] display];
            appDelegate = nil;
        }


        self.numberString = nil;
        self.acceptString = nil;
        self.rejectString = nil;
    
  
    if ([output rangeOfString:@"Unknown stratum msg"].location != NSNotFound) {
        output = nil;
    }
    else {
        
        NSString *newOutput = [self.asicOutputView.string stringByAppendingString:output];
        self.asicOutputView.string = newOutput;
        newOutput = nil;
    
    
    [self.prefs synchronize];

    self.logLength = [self.prefs objectForKey:@"logLength" ];
    if (self.logLength.intValue <= 1) {
        self.logLength = @"5000";
    }
    
    if (self.asicOutputView.string.length >= self.logLength.intValue) {
        [self.asicOutputView setEditable:true];
        [self.asicOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.asicOutputView delete:nil];
        [self.asicOutputView setEditable:false];
    }

        self.logLength = nil;
        
    }


        /*    [[appDelegate.pingReport textStorage] appendAttributedString: [[NSAttributedString alloc]
         initWithString: output]];
         */
        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
    output = nil;
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
    self.foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];

                scanner = nil;
                leftData = nil;
                rightData = nil;
                
    return self.foundData;

    }
    else return @"left string is nil";
}

// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
    //   AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.asicOutputView scrollRangeToVisible:NSMakeRange([[self.asicOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    findRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
//    [asicStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    [appDelegate.asicReadBack setHidden:YES];
    [appDelegate.asicReading setHidden:YES];
    
    findRunning=NO;
    // change the button's title back for the next search
    [self.asicStartButton setTitle:@"Start"];
    if (self.asicStartButton.tag == 0) {
        
        [self performSelector:@selector(start:) withObject:nil afterDelay:10.0];
        
        NSAlert *restartMessage = [[NSAlert alloc] init];
        [restartMessage addButtonWithTitle:@"Umm… OK."];
        
        [restartMessage setMessageText:@"Settings changed"];
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
//        NSLog(@"newDateString %@", newDateString);
        outputFormatter = nil;
        NSString *restartMessageInfo = [NSString stringWithFormat:@"Your miner was resarted automatically after a sudden stop at %@.", newDateString];
        [restartMessage setInformativeText:restartMessageInfo];
        
        restartMessage = nil;
        
        [restartMessage setAlertStyle:NSWarningAlertStyle];
        //        returnCode: (NSInteger)returnCode
        
        [restartMessage beginSheetModalForWindow:self.asicWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
    }
    appDelegate = nil;

}


-(BOOL)windowShouldClose:(id)sender
{



    return YES;
    
}

// Display the release notes, as chosen from the menu item in the Help menu.
- (IBAction)displayHelp:(id)sender
{
[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}

- (IBAction)addNetworkedMiner:(id)sender
{
        [self.addNetworkedMinerWindow orderFront:sender];
}

- (IBAction)addNetworkedMinerApply:(id)sender
{
//self.prefs = [NSUserDefaults standardUserDefaults];
//        [self.minerAddressesArray addObject:@"devs"];
    
    NSString *addAddress = self.ipAddress.stringValue;
    if ([self.ipAddress.stringValue rangeOfString:@"http://"].location == NSNotFound) {
        addAddress = [@"http://" stringByAppendingString:addAddress];
    }
    
    [self.minerAddressesArray addObject:addAddress];
    
//        [self.prefs setObject:self.minerAddressesArray forKey:@"ipAddress"];

    [self.prefs synchronize];
    
    [self.addNetworkedMinerWindow orderOut:sender];
}

- (IBAction)clearNetworkedMinerApply:(id)sender
{
    

    [self.minerAddressesArray removeAllObjects];
    

}



// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
    
    
    
    findRunning=NO;

    findTwoRunning=NO;
    asicTask=nil;
    apiTask=nil;
    

    
    // getting an NSString
    NSString *asicOptionsString = [self.prefs stringForKey:@"asicOptionsValue"];
    

    if (asicOptionsString != nil) {
        [self.asicOptionsView setStringValue:asicOptionsString];
    }
    
    if ([[self.prefs objectForKey:@"startAsic"] isEqualToString:@"start"]) {
        
                        [self.asicWindow orderFront:nil];
        
        
        [self.asicStartButton setTitle:@"Stop"];
        self.asicStartButton.tag = 0;
        //            self.asicAPIOutput.string = @"";
        //            [self.asicAPIOutput delete:nil];
        
        
        
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        
        
        
        self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
        self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
        self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
        self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
        NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];
        
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"R:0/0", nil];
        if ([self.bonusOptions isNotEqualTo:@""]) {
            NSArray *deviceItems = [self.bonusOptions componentsSeparatedByString:@" "];
            
            [launchArray addObjectsFromArray:deviceItems];
        }
        
        
        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        if (self.bigpicEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bigpic:all"];
        }
        if (self.antminerEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"antminer:all"];
        }
        if (self.bflEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bfl:all"];
        }
        if (self.bitfuryEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bifury:all"];
        }
        if (self.erupterEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"erupter:all"];
        }

        NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];
            if ([saveLogFile isNotEqualTo:nil]) {
            [launchArray addObject:@"--debuglog"];
            [launchArray addObject:@"-L"];
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
            
            NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
            
            NSString *btcConfig = @"";
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            if ([fileManager fileExistsAtPath:userpath] == YES) {
                btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            }

            NSString *acceptString = @"";
            
            if (btcConfig.length >= 20) {
                acceptString = [self getDataBetweenFromString:btcConfig
                                                             leftString:@"user" rightString:@"," leftOffset:9];
            }

            NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;
            
            
            NSString *logFile = [userpath stringByAppendingString:[@"/" stringByAppendingString:[bfgUserValue stringByAppendingString:[dateString stringByAppendingString:@".txt"]]]];
            
            [launchArray addObject:logFile];

        }
        
        
        
        if ([self.noGPU isNotEqualTo:nil]) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        
        cpuThreads = nil;
        

        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        
        
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        
        [self.asicOutputView setString:@""];
        
        asicTask =[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                                 arguments:launchArray
                                               environment:nil
                                                  delegate:self];
        // kick off the process asynchronously
        
        [asicTask startTask];
        
        
    }


}

- (IBAction)asicMinerToggle:(id)sender {
    
    if ([self.asicWindow isVisible]) {
        [self.asicWindow orderOut:sender];
    }
    else
    {
        [self.asicWindow orderFront:sender];
    }
}


- (IBAction)optionsToggle:(id)sender {
    
        if ([self.asicOptionsWindow isVisible]) {
            [self.asicOptionsButton setState:NSOffState];
            [self.asicOptionsWindow orderOut:sender];
        }
        else
        {
            [self.asicOptionsButton setState:NSOnState];
            [self.asicOptionsWindow orderFront:sender];
            
            
            [self.prefs synchronize];
            
            
            NSString *noGPU = [self.prefs stringForKey:@"disableASICGPU"];
            NSString *debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
            NSString *quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
            NSString *bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
            NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];
            
            NSString *bflEnable = [self.prefs stringForKey:@"bflEnable"];
            NSString *bigpicEnable = [self.prefs stringForKey:@"bigpicEnable"];
            NSString *bitfuryEnable = [self.prefs stringForKey:@"bitfuryEnable"];
            NSString *erupterEnable = [self.prefs stringForKey:@"erupterEnable"];
            NSString *antminerEnable = [self.prefs stringForKey:@"antminerEnable"];

            NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];

            if ([saveLogFile isNotEqualTo:nil]) {
                self.saveLogFile.state = NSOnState;
            }
            
            if ([bflEnable isNotEqualTo:nil]) {
                self.bflEnable.state = NSOffState;
            }
            if ([bigpicEnable isNotEqualTo:nil]) {
                self.bigpicEnable.state = NSOffState;
            }
            if ([bitfuryEnable isNotEqualTo:nil]) {
                self.bitfuryEnable.state = NSOffState;
            }
            if ([erupterEnable isNotEqualTo:nil]) {
                self.erupterEnable.state = NSOffState;
            }
            if ([antminerEnable isNotEqualTo:nil]) {
                self.antminerEnable.state = NSOffState;
            }
            
            if ([noGPU isNotEqualTo:nil]) {
                self.asicNoGpuButton.state = NSOnState;
            }

            if ([debugOutputOn isNotEqualTo:nil]) {
                self.asicDebugButton.state = NSOnState;
            }
            else {
                self.asicDebugButton.state = NSOffState;
            }
            if ([quietOutputOn isNotEqualTo:nil]) {
                self.asicQuietButton.state = NSOnState;
            }
            
            if ([bonusOptions isNotEqualTo:nil]) {
                self.asicOptionsView.stringValue = bonusOptions;
            }
            
            if ([cpuThreads isNotEqualTo:nil]) {
                self.asicThreadsField.stringValue = cpuThreads;
            }

            noGPU = nil;
            debugOutputOn = nil;
            quietOutputOn = nil;
            bonusOptions = nil;
            cpuThreads = nil;
            
            bflEnable = nil;
            bigpicEnable = nil;
            bitfuryEnable = nil;
            erupterEnable = nil;
            antminerEnable = nil;

            
        }
        
        
        
    }


    
- (IBAction)optionsApply:(id)sender {
    

        
        if (self.asicNoGpuButton.state == NSOffState) {
            [self.prefs setObject:nil forKey:@"disableASICGPU"];
        }
        else {
            [self.prefs setObject:@"-S opencl:auto" forKey:@"disableASICGPU"];
        }

        if (self.asicDebugButton.state == NSOnState) {
            [self.prefs setObject:@"-D" forKey:@"debugASICOutput"];
        }
        else {
            [self.prefs setObject:nil forKey:@"debugASICOutput"];
        }
        if (self.asicQuietButton.state == NSOnState) {
            [self.prefs setObject:@"-q" forKey:@"quietASICOutput"];
        }
        else {
            [self.prefs setObject:nil forKey:@"quietASICOutput"];
        }
    
    
    if (self.bflEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bflEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bflEnable"];
    }
    if (self.bigpicEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bigpicEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bigpicEnable"];
    }
    if (self.bitfuryEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bitfuryEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bitfuryEnable"];
    }
    if (self.erupterEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"erupterEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"erupterEnable"];
    }
    if (self.antminerEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"antminerEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"antminerEnable"];
    }
    if (self.saveLogFile.state == NSOnState) {
        [self.prefs setObject:@"save" forKey:@"saveLogFile"];
    }
    else {
        [self.prefs setObject:nil forKey:@"saveLogFile"];
    }

    
    
        [self.prefs setObject:self.asicOptionsView.stringValue forKey:@"asicOptionsValue"];
    
    if (self.asicThreadsField.stringValue.length >= 1) {
    [self.prefs setObject:self.asicThreadsField forKey:@"cpuASICThreads"];
    }

    
        [self.prefs synchronize];
        
        [self.asicOptionsButton setState:NSOffState];
        [self.asicOptionsWindow orderOut:sender];
    
        
}

- (IBAction)showLogFiles:(id)sender {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    applicationSupportDirectory = [applicationSupportDirectory stringByAppendingString:@"/MacMiner"];
    
NSURL* urlToDirectory = [NSURL fileURLWithPath:applicationSupportDirectory isDirectory:YES];

NSArray *fileURL = [NSArray arrayWithObjects:urlToDirectory, nil];
[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURL];

    
}

void display(char *buf)
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    

	char *nextobj, *item, *nextitem, *eq;
	int itemcount;
    
	while (buf != NULL) {
		nextobj = strchr(buf, SEPARATOR);
		if (nextobj != NULL)
			*(nextobj++) = '\0';
        
		if (*buf) {
			item = buf;
			itemcount = 0;
			while (item != NULL) {
				nextitem = strchr(item, COMMA);
				if (nextitem != NULL)
					*(nextitem++) = '\0';
                
				if (*item) {
					eq = strchr(item, EQ);
					if (eq != NULL)
						*(eq++) = '\0';
                    
					if (itemcount == 0) {
//						printf("[%s%s] =>\n(\n", item, (eq != NULL && isdigit(*eq)) ? eq : "");
//                        [appDelegate.outputMathString stringByAppendingString:[NSString stringWithFormat:@"[%s%s] =>\n(\n", item, (eq != NULL && isdigit(*eq)) ? eq : ""]];
[appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:[NSString stringWithFormat:@"[%s%s] =>\n(\n", item, (eq != NULL && isdigit(*eq)) ? eq : ""]]];
[appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:@"("]];
                    }
                    
					if (eq != NULL)
                    {
//						printf("   [%s] => %s\n", item, eq);
                        [appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:[NSString stringWithFormat:@"   [%s] => %s\n", item, eq]] ];
					}
                    else {
//						printf("   [%d] => %s\n", itemcount, item);

                        [appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:[NSString stringWithFormat:@"   [%d] => %s\n", itemcount, item]]];
				}
                    

                    

                    
                }
                
				item = nextitem;
				itemcount++;
			}
			if (itemcount > 0)
//				puts(")");
[appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:@")"]];
		}

		buf = nextobj;
	}
//    NSString *tempString = [NSString stringWithString:appDelegate.outputMathString];
//                        NSLog(tempString);
    
    appDelegate = nil;

}

void callapi(char *command, const char *host, short int port)
{
	char buf[RECVSIZE+1];
	struct hostent *ip;
	struct sockaddr_in serv;
	SOCKETTYPE sock;
	int ret = 0;
	int n, p;

    
	SOCKETINIT;
    
	ip = gethostbyname(host);
    
	sock = socket(AF_INET, SOCK_STREAM, 0);
    

        

    
	if (sock == INVSOCK) {
//		printf("Socket initialisation failed: %s\n", SOCKERRMSG);
        
	}
    else {
    
	memset(&serv, 0, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_addr = *((struct in_addr *)ip->h_addr);
	serv.sin_port = htons(port);
    
	if (SOCKETFAIL(connect(sock, (struct sockaddr *)&serv, sizeof(struct sockaddr)))) {
//		printf("Socket connect failed: %s\n", SOCKERRMSG);
        
        return;

	}
    
	n = send(sock, command, strlen(command), 0);
	if (SOCKETFAIL(n)) {
//		printf("Send failed: %s\n", SOCKERRMSG);
        return;

	}
	else {
		p = 0;
		buf[0] = '\0';
		while (p < RECVSIZE) {
			n = recv(sock, &buf[p], RECVSIZE - p , 0);
            
			if (SOCKETFAIL(n)) {
//				printf("Recv failed: %s\n", SOCKERRMSG);
				ret = 1;
				break;
			}
            
			if (n == 0)
				break;
            
			p += n;
			buf[p] = '\0';
		}
        
        
		if (!ONLY) {
            
                AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            
            NSString *whichMiner = [NSString stringWithFormat:@"[Data for %s]" , host];
            
            [appDelegate.outputMathString setString:[appDelegate.outputMathString stringByAppendingString:[whichMiner stringByAppendingString:@"\n"]]];
            
			display(buf);
        }
        
        	CLOSESOCKET(sock);
	}
        


    }

    

}

static char *trim(char *str)
{
	char *ptr;
    
	while (isspace(*str))
		str++;
    
	ptr = strchr(str, '\0');
	while (ptr-- > str) {
		if (isspace(*ptr))
			*ptr = '\0';
	}
    
	return str;
}




@end
