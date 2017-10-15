//
//  ViewController.m
//  Lab2
//
//  Created by Ernest on 10/13/17.
//  Copyright © 2017 Ernest. All rights reserved.
//

#import "ADD.h"
#import "AppDelegate.h"

@interface ADD ()

@end

@implementation ADD

- (void) alertMessage:(NSString *) msg{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"LAB 2"
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:yesButton];
}

- (void)clearFields {
    self.o1.text = self.o2.text= self.o3.text = self.o4.text = self.o5.text = self.o6.text = @"";
    self.notite.text = @"";
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.date.text = theAppDelegate.strResponse;
    self.date.textAlignment = NSTextAlignmentCenter;
    
    if (theAppDelegate.isPair){
        self.tip.text = @"Saptamina para";
    }
    
    else{
        self.tip.text = @"Saptamina impara";
    }
    
    [self clearFields];
    
    [[self.notite layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.notite layer] setBorderWidth:1.5];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *) modifyOrar:(NSMutableArray *) arr{
    arr[0] = self.o1.text;
    arr[1] = self.o2.text;
    arr[2] = self.o3.text;
    arr[3] = self.o4.text;
    arr[4] = self.o5.text;
    arr[5] = self.o6.text;
    
    return arr;
}

- (IBAction)save:(id)sender {
    
    if ([theAppDelegate.strResponse isEqualToString:@"Duminica nu sunt lectii"]){
        [self alertMessage:@"Pentru Duminica nu este orar"];
        return ;
    }
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"orar.json"];
        NSString *key = theAppDelegate.isPair ? @"pair" : @"impair";
        
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSMutableArray *arr;
        
        arr = [json objectForKey:key];
        
        arr[theAppDelegate.weekday] = [self modifyOrar:arr[theAppDelegate.weekday]];
        
        [json removeObjectForKey:key];
        [json setObject:arr forKey:key];
        
        [json removeObjectForKey:theAppDelegate.noteDate];
        [json setObject:self.notite.text forKey:theAppDelegate.noteDate];
        
        data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
        
        [data writeToFile:jsonPath atomically:YES];
        NSLog(@"%@",json);
       
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self alertMessage:@"Orar salvat"];
        });
        
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
