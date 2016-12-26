//
//  ViewController.h
//  IoT Tree
//
//  Created by Ivann Ruiz on 12/22/16.
//  Copyright © 2016 Ivann Ruiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate>

{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    
    NSMutableArray  *messages;
}

@property (weak, nonatomic) IBOutlet UILabel *smiley;

@end

