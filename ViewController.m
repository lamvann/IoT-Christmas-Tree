//
//  ViewController.m
//  IoT Tree
//
//  Created by Ivann Ruiz on 12/22/16.
//  Copyright © 2016 Ivann Ruiz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

NSString * IP = @"0.0.0.0";
int PORT = 2200;

NSString * ON = @"1";
NSString * OFF = @"0";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIColor * bgColor = [UIColor colorWithRed:0.18 green:0.75 blue:1.00 alpha:1.0];
    [[self view] setBackgroundColor:bgColor];
}

-(IBAction)treeON {
    
    //Connect to server
    
    NSLog(@"Setting up connection to %@ : %i", IP, PORT); //Optional line
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) IP, PORT, &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
    
    NSData *data = [[NSData alloc] initWithData:[ON dataUsingEncoding:NSASCIIStringEncoding]];
    
    [outputStream write:[data bytes] maxLength:[data length]];
    
    [self close];
    
    UIColor * bgColor = [UIColor colorWithRed:0.09 green:0.93 blue:0.11 alpha:1.0];
    
    [[self view] setBackgroundColor:bgColor];
    
    NSString * happy = @":)";
    
    _smiley.text = happy;
}

-(IBAction)treeOFF {
    
    //Connect to server
    
    NSLog(@"Setting up connection to %@ : %i", IP, PORT); //Optional
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) IP, PORT, &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
    
    NSData *data = [[NSData alloc] initWithData:[OFF dataUsingEncoding:NSASCIIStringEncoding]];
    
    [outputStream write:[data bytes] maxLength:[data length]];
    
    [self close];
    
    UIColor * bgColor = [UIColor colorWithRed:0.96 green:0.07 blue:0.14 alpha:1.0];
    
    [[self view] setBackgroundColor:bgColor];
    
    NSString * sad = @":(";
    
    _smiley.text = sad;
}


- (void) messageReceived:(NSString *)message {
    
    [messages addObject:message];
    
    if ([message length] == 0) {
        NSLog(@"Error turning tree on");
    }
    
    NSLog(@"Server said:%@", message);
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");

            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output)
                        {
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

- (void)disconnect:(id)sender {
    
    [self close];
}

- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    
}

- (void)open {
    
    NSLog(@"Opening streams.");
    
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
