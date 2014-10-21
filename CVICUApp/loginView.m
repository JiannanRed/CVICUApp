//
//  loginView.m
//  CVICUApp
//
//  Created by Jiannan on 10/19/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "loginView.h"
#import "management.h"
#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

UIButton *loginButton,*userButton;
UIImageView *mainImage;
UITextField *passwordText;
UIPickerView *userPicker;
NSMutableArray *usernames,*firstname,*lastname,*password,*isAdmin,*ID;
NSString *fullname,*name;
NSInteger count;
@interface loginView ()

@end

@implementation loginView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count=[self loadUsernames];
    name=@"Select user";
    
    mainImage=[[UIImageView alloc]initWithFrame:CGRectMake(35, 35, 250, 300)];
    mainImage.image=[UIImage imageNamed:@"main.jpg"];
    [self.view addSubview:mainImage];
    
    userButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [userButton addTarget:self action:@selector(clickUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [userButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [userButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    userButton.frame=CGRectMake(35.0f, 350.0f, 250.0f, 40.0f);
    [userButton setTitle:@"Select user" forState:UIControlStateNormal];
    [userButton setBackgroundColor:[UIColor whiteColor]];
    CALayer *btnLayer = [userButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:userButton];
    
    passwordText=[[UITextField alloc]init];
    //passwordText.textAlignment=UITextAlignmentCenter;
    [passwordText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    passwordText.placeholder=@"Password";
    passwordText.borderStyle=UITextBorderStyleRoundedRect;
    passwordText.secureTextEntry=YES;
    passwordText.delegate=self;
    passwordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordText.textAlignment = UITextAlignmentCenter;
    passwordText.frame=CGRectMake(35.0f, 410.0f, 250.0f, 40.0f);
    btnLayer = [passwordText layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:passwordText];
    
    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    loginButton.frame=CGRectMake(35.0f, 470.0f, 250.0f, 40.0f);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    btnLayer = [loginButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) loadUsernames{
    usernames=[[NSMutableArray alloc]init];
    firstname=[[NSMutableArray alloc]init];
    lastname=[[NSMutableArray alloc]init];
    password=[[NSMutableArray alloc]init];
    isAdmin=[[NSMutableArray alloc]init];
    ID=[[NSMutableArray alloc]init];
    NSString *a,*b;
    NSInteger i=0;
    NSLog(@"Start to load usernames information from database in login view.");
    
    NSString *domainName=[[NSString alloc]initWithFormat:@"Physicians"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"AKIAIRLA73QCMCCGCKQA" withSecretKey:@"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"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select * from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    for (SimpleDBItem *item in select1Response.items){
        fullname=@"";
        for(SimpleDBAttribute *attri in item.attributes){
            if([attri.name isEqualToString:@"Firstname"]){
                [firstname addObject:(id)attri.value];
                a=attri.value;
            }
            if([attri.name isEqualToString:@"Lastname"]){
                [lastname addObject:(id)attri.value];
                b=attri.value;
            }
            if([attri.name isEqualToString:@"password"]){
                [password addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"admin"]){
                [isAdmin addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"ID"]){
                [ID addObject:(id)attri.value];
            }
        }
        fullname=[NSString stringWithFormat:@"%@ %@",a,b];
        [usernames addObject:(id)fullname];
        i++;
    }
    NSLog(@"Finish load username from dataBase in login view");
    return usernames.count;
}

-(void)clickLoginButton:(id)sender{
    NSInteger i=0;
    BOOL isAccount=FALSE;
    for(i=0;i<count;++i){
        if ([[usernames objectAtIndex:i] isEqualToString:userButton.titleLabel.text] && [[password objectAtIndex:i] isEqualToString:passwordText.text]) {
            isAccount=TRUE;
            break;
        }
    }
    if(isAccount){
        [[NSUserDefaults standardUserDefaults]setValue:[isAdmin objectAtIndex:i] forKey:@"isAdmin"];
        [[NSUserDefaults standardUserDefaults]setValue:[usernames objectAtIndex:i] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setValue:[ID objectAtIndex:i] forKey:@"ID"];
        management *managementView=[self.storyboard instantiateViewControllerWithIdentifier:@"management"];
        managementView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:managementView animated:YES completion:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please Check" message:@"Username or password is wrong!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

- (void)clickUserButton:(id)sender {
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select user name", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    userPicker=[[UIPickerView alloc]init];
    userPicker.delegate=self;
    userPicker.dataSource=self;
    userPicker.showsSelectionIndicator=YES;
    sheet.tag=1;
    [sheet addSubview:userPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return count+1;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row==0){
        return @"Select user";
    }else{
        return [usernames objectAtIndex:row-1];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row>0){
        [userButton setTitle:[usernames objectAtIndex:row-1] forState:UIControlStateNormal];
        name=[usernames objectAtIndex:row-1];
    }else{
        [userButton setTitle:@"Select user" forState:UIControlStateNormal];
        name=@"Select user";
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= 200;
        rect.size.height += 200;
    }
    else
    {
        rect.origin.y += 200;
        rect.size.height -= 200;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidEndEditing:(UITextField *)sender
{
    if  (self.view.frame.origin.y < 0)
        [self setViewMovedUp:NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if  (self.view.frame.origin.y >= 0)
        [self setViewMovedUp:YES];
}

@end
