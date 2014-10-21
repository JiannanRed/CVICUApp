//
//  admin.m
//  CVICUApp
//
//  Created by Jiannan on 10/20/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "admin.h"

NSString *username;
NSInteger isAdmin;
UILabel *userLabel,*comLabel;
UIScrollView *scrollview;
UITextField *firstnameText,*lastnameText,*passwordText,*level1Text,*level2Text;
UIButton *isAdminButton,*addUserButton,*deleteUserButton,*listUserButton,*addComButton,*deleteComButton,*listComButton;

@interface admin ()

@end

@implementation admin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    username=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:240/255.0 green:250.0f/255.0 blue:255/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLogoutButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:username];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,60,320,680)];
    scrollview.showsVerticalScrollIndicator=YES;
    scrollview.scrollEnabled=YES;
    scrollview.userInteractionEnabled=YES;
    [self.view addSubview:scrollview];
    [scrollview setContentSize:CGSizeMake(320, 940)];
    
    userLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 260, 40)];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    userLabel.textColor=[UIColor blackColor];
    userLabel.text = @"Manage Physicians";
    [scrollview addSubview:userLabel];
    
    firstnameText=[[UITextField alloc]init];
    [firstnameText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [firstnameText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    firstnameText.placeholder=@"First Name";
    firstnameText.borderStyle=UITextBorderStyleRoundedRect;
    firstnameText.delegate=self;
    firstnameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    firstnameText.frame=CGRectMake(30.0f, 100.0f, 120.0f, 40.0f);
    CALayer *btnLayer = [firstnameText layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:firstnameText];
    
    lastnameText=[[UITextField alloc]init];
    [lastnameText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [lastnameText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    lastnameText.placeholder=@"Last Name";
    lastnameText.borderStyle=UITextBorderStyleRoundedRect;
    lastnameText.delegate=self;
    lastnameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    lastnameText.frame=CGRectMake(170.0f, 100.0f, 120.0f, 40.0f);
    btnLayer = [lastnameText layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:lastnameText];
    
    passwordText=[[UITextField alloc]init];
    [passwordText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    passwordText.placeholder=@"Password";
    passwordText.borderStyle=UITextBorderStyleRoundedRect;
    passwordText.secureTextEntry=YES;
    passwordText.delegate=self;
    passwordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordText.frame=CGRectMake(30.0f, 160.0f, 120.0f, 40.0f);
    btnLayer = [passwordText layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:passwordText];
    
    isAdminButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [isAdminButton addTarget:self action:@selector(clickisAdminButton) forControlEvents:UIControlEventTouchUpInside];
    [isAdminButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [isAdminButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    isAdminButton.frame=CGRectMake(170.0f, 160.0f, 120.0f, 40.0f);
    [isAdminButton setTitle:@"Administrator?" forState:UIControlStateNormal];
    [isAdminButton setBackgroundColor:[UIColor lightGrayColor]];
    btnLayer = [isAdminButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:isAdminButton];
    
    addUserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addUserButton addTarget:self action:@selector(clickAddUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [addUserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    addUserButton.frame=CGRectMake(30.0f, 220.0f, 70.0f, 40.0f);
    [addUserButton setTitle:@"add" forState:UIControlStateNormal];
    [addUserButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [addUserButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:addUserButton];
    
    deleteUserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteUserButton addTarget:self action:@selector(clickDeleteUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [deleteUserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    deleteUserButton.frame=CGRectMake(125.0f, 220.0f, 70.0f, 40.0f);
    [deleteUserButton setTitle:@"delete" forState:UIControlStateNormal];
    [deleteUserButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [deleteUserButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:deleteUserButton];
    
    listUserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [listUserButton addTarget:self action:@selector(clickListUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [listUserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [listUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    listUserButton.frame=CGRectMake(220.0f, 220.0f, 70.0f, 40.0f);
    [listUserButton setTitle:@"list" forState:UIControlStateNormal];
    [listUserButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [listUserButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:listUserButton];
    
    comLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 280, 260, 40)];
    comLabel.backgroundColor = [UIColor clearColor];
    comLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    comLabel.textColor=[UIColor blackColor];
    comLabel.text = @"Manage Complications";
    [scrollview addSubview:comLabel];
    
    level1Text=[[UITextField alloc]init];
    [level1Text addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [level1Text setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    level1Text.placeholder=@"Complication level1";
    level1Text.borderStyle=UITextBorderStyleRoundedRect;
    level1Text.delegate=self;
    level1Text.clearButtonMode=UITextFieldViewModeWhileEditing;
    level1Text.frame=CGRectMake(30.0f, 340.0f, 260.0f, 40.0f);
    btnLayer = [level1Text layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:level1Text];
    
    level2Text=[[UITextField alloc]init];
    [level2Text addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [level2Text setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    level2Text.placeholder=@"Complication level2";
    level2Text.borderStyle=UITextBorderStyleRoundedRect;
    level2Text.delegate=self;
    level2Text.clearButtonMode=UITextFieldViewModeWhileEditing;
    level2Text.frame=CGRectMake(30.0f, 400.0f, 260.0f, 40.0f);
    btnLayer = [level2Text layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:level2Text];
    
    addComButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addComButton addTarget:self action:@selector(clickAddComButton:) forControlEvents:UIControlEventTouchUpInside];
    [addComButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addComButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    addComButton.frame=CGRectMake(30.0f, 460.0f, 70.0f, 40.0f);
    [addComButton setTitle:@"add" forState:UIControlStateNormal];
    [addComButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [addComButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:addComButton];
    
    deleteComButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteComButton addTarget:self action:@selector(clickDeleteComButton:) forControlEvents:UIControlEventTouchUpInside];
    [deleteComButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteComButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    deleteComButton.frame=CGRectMake(125.0f, 460.0f, 70.0f, 40.0f);
    [deleteComButton setTitle:@"delete" forState:UIControlStateNormal];
    [deleteComButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [deleteComButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:deleteComButton];
    
    listComButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [listComButton addTarget:self action:@selector(clickListComButton:) forControlEvents:UIControlEventTouchUpInside];
    [listComButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [listComButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    listComButton.frame=CGRectMake(220.0f, 460.0f, 70.0f, 40.0f);
    [listComButton setTitle:@"list" forState:UIControlStateNormal];
    [listComButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [listComButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:listComButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLogoutButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickisAdminButton{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Is this physician an administrator?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag=0;
    [alert show];
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
    //NSLog(@"dDDDD:%f",sender.frame.origin.y);
    //if(sender.frame.origin.y>400)
    //if  (self.view.frame.origin.y < 0)
        //[self setViewMovedUp:NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //if(sender.frame.origin.y<=200)
    //if  (self.view.frame.origin.y >= 0)
        //[self setViewMovedUp:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==0) {
        if(buttonIndex==0){
            isAdmin=0;
        }
        if(buttonIndex==1){
            isAdmin=1;
        }
    }
}

@end
