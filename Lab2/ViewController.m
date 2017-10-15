//
//  ViewController.m
//  Lab2
//
//  Created by Ernest on 10/13/17.
//  Copyright © 2017 Ernest. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

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

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.data.text = theAppDelegate.strResponse;
    
    if (theAppDelegate.tempDate != nil){
        [_datepick setDate:theAppDelegate.tempDate];
    }
    
    self.add.layer.borderWidth = 1.5f;
    self.add.layer.borderColor = [UIColor greenColor].CGColor;
    
    self.remove.layer.borderWidth = 2.0f;
    self.remove.layer.borderColor = [UIColor redColor].CGColor;
    
    self.update.layer.borderWidth = 1.5f;
    self.update.layer.borderColor = [UIColor blueColor].CGColor;
    
    self.show.layer.borderWidth = 2.0f;
    self.show.layer.borderColor = [UIColor blackColor].CGColor;
    
    [[self.notite layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.notite layer] setBorderWidth:1.5];
    
    [self initView];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) initView{
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        
        NSDate *choice = [_datepick date];
        NSString* currentDate;
        NSString* dayOfTheWeek;
        
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"orar.json"];
        NSString *sapt;
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit)  fromDate:choice];
        
        
        
        NSInteger weekday = [components weekday];
        
        if (weekday>1)
            weekday--;
        else
            weekday=7;
        --weekday;
        theAppDelegate.weekday = weekday;
        
        if (weekday == 6){
            dispatch_sync(dispatch_get_main_queue(), ^{
                theAppDelegate.strResponse = self.data.text = @"Duminica nu sunt lectii";
                self.o1.text = self.o2.text = self.o3.text = self.o4.text = self.o5.text = self.o6.text = @"";
                self.notite.text = @"";
            });
            
            return ;
        }
        
        theAppDelegate.tempDate = choice;
        
        theAppDelegate.isPair =([components weekOfYear] + 1) % 2 == 0;
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        dayOfTheWeek = [dateFormatter stringFromDate:choice];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        currentDate = [dateFormatter stringFromDate:choice];
        
        theAppDelegate.strResponse = [NSString stringWithFormat:@"%@ %@",currentDate, dayOfTheWeek];
        theAppDelegate.noteDate = currentDate;
        
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *arr;
        
        if (theAppDelegate.isPair){
            arr = [json objectForKey:@"pair"];
            sapt = @"Saptamina para";
        }
        
        else{
            arr = [json objectForKey:@"impair"];
            sapt = @"Saptamina impara";
        }
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.data.text = [NSString stringWithFormat:@"%@ %@",currentDate, dayOfTheWeek];
            self.tip.text = sapt;
            self.notite.text = [json objectForKey:theAppDelegate.noteDate];
            [self changeText:arr[theAppDelegate.weekday]];
        });
        
    });
}

- (void)changeText:(NSArray *)arr{
    self.o1.text = arr[0];
    self.o2.text = arr[1];
    self.o3.text = arr[2];
    self.o4.text = arr[3];
    self.o5.text = arr[4];
    self.o6.text = arr[5];
}

- (IBAction)showDate:(id)sender {
    
    [self initView];
    
}

- (IBAction)remove:(id)sender {
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
        
        arr[theAppDelegate.weekday][0] = arr[theAppDelegate.weekday][1]
            = arr[theAppDelegate.weekday][2] = arr[theAppDelegate.weekday][3]
                = arr[theAppDelegate.weekday][4] = arr[theAppDelegate.weekday][5] = @"";
       
        
        [json removeObjectForKey:key];
        [json setObject:arr forKey:key];
        
        [json removeObjectForKey:theAppDelegate.noteDate];
        
        data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
        
        [data writeToFile:jsonPath atomically:YES];
        NSLog(@"%@",json);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
             self.o1.text = self.o2.text = self.o3.text = self.o4.text = self.o5.text = @"";
             self.notite.text = @"";
            [self alertMessage:@"Orar sters"];
        });
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
