//
//  management.m
//  CVICUApp
//
//  Created by Jiannan on 10/19/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "management.h"
#import "admin.h"
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;
UIScrollView *scrollview;
UILabel *timeLabel,*level1Label,*level2Label,*bedLabel,*FINLabel;
UIButton *complicationsButton,*bedButton,*addLogButton,*FINButton;
NSString *compID,*bID,*domainName,*FINLog,*comID,*level1Log,*level2Log,*bedLog,*sublocationLog,*username,*physiciansID;
NSInteger FINcount,level1Count,level2Count,bedCount,sublocationCount,isAdmin;
NSMutableArray *FIN,*level1,*level2,*complicationID,*level2show,*level1show,*bedID,*bed,*sublocation,*bedshow,*sublocationshow,*comlogID,*comlogLogTime,*comlogphyID,*comlogBedID,*comlogPatFIN,*comlogcomlog,*firstname,*lastname,*fullnames,*phyID;
UIPickerView *FINPicker,*level1Picker,*level2Picker,*bedPicker,*sublocationPicker;

@interface management ()

@end

@implementation management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    username=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    physiciansID=[[NSUserDefaults standardUserDefaults]stringForKey:@"ID"];
    isAdmin=[[[NSUserDefaults standardUserDefaults]stringForKey:@"isAdmin"] intValue];
    FINLog=@"Select FIN";
    level1Log=@"Select level1";
    level2Log=@"Select level2";
    bedLog=@"Select bed";
    sublocationLog=@"Select sublocation";
    FINcount=[self loadFIN];
    level1Count=[self loadlevel1];
    bedCount=[self loadBed];
    [self loadUsernames];
    
    self.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,320,680)];
    scrollview.showsVerticalScrollIndicator=YES;
    scrollview.scrollEnabled=YES;
    scrollview.userInteractionEnabled=YES;
    [self.view addSubview:scrollview];
    [scrollview setContentSize:CGSizeMake(320, 740)];
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:240/255.0 green:250.0f/255.0 blue:255/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLogoutButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:username];
    navigItem.leftBarButtonItem=cancelButton;
    if(isAdmin==1){
        UIBarButtonItem *adminButton=[[UIBarButtonItem alloc]initWithTitle:@"Admin" style:UIBarButtonItemStyleBordered target:self action:@selector(clickAdminButton)];
        navigItem.rightBarButtonItem=adminButton;
    }
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 80, 250, 40)];
    timeLabel.numberOfLines = 1;
    timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    timeLabel.adjustsFontSizeToFitWidth = YES;
    //timeLabel.adjustsLetterSpacingToFitWidth = YES;
    timeLabel.minimumScaleFactor = 10.0f/12.0f;
    timeLabel.clipsToBounds = YES;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [scrollview addSubview:timeLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayTime) userInfo:nil repeats:YES];
    
    FINButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [FINButton addTarget:self action:@selector(clickFINButton) forControlEvents:UIControlEventTouchUpInside];
    [FINButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [FINButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    FINButton.frame=CGRectMake(35.0f, 140.0f, 250.0f, 40.0f);
    [FINButton setTitle:@"Select FIN" forState:UIControlStateNormal];
    [FINButton setBackgroundColor:[UIColor lightGrayColor]];
    CALayer *btnLayer = [FINButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:FINButton];
    
    FINLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 200, 250, 40)];
    FINLabel.numberOfLines = 2;
    FINLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    FINLabel.adjustsFontSizeToFitWidth = YES;
    //FINLabel.adjustsLetterSpacingToFitWidth = YES;
    FINLabel.minimumScaleFactor = 10.0f/12.0f;
    FINLabel.clipsToBounds = YES;
    FINLabel.backgroundColor = [UIColor clearColor];
    FINLabel.textColor = [UIColor blackColor];
    FINLabel.textAlignment = NSTextAlignmentCenter;
    FINLabel.text=@"FIN";
    [scrollview addSubview:FINLabel];
    
    complicationsButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [complicationsButton addTarget:self action:@selector(clickComplicationsButton) forControlEvents:UIControlEventTouchUpInside];
    [complicationsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [complicationsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    complicationsButton.frame=CGRectMake(35.0f, 260.0f, 250.0f, 40.0f);
    [complicationsButton setTitle:@"Select Complication" forState:UIControlStateNormal];
    [complicationsButton setBackgroundColor:[UIColor lightGrayColor]];
    btnLayer = [complicationsButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:complicationsButton];
    
    level1Label = [[UILabel alloc]initWithFrame:CGRectMake(35, 320, 250, 40)];
    level1Label.numberOfLines = 2;
    level1Label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    level1Label.adjustsFontSizeToFitWidth = YES;
    //level1Label.adjustsLetterSpacingToFitWidth = YES;
    level1Label.minimumScaleFactor = 10.0f/12.0f;
    level1Label.clipsToBounds = YES;
    level1Label.backgroundColor = [UIColor clearColor];
    level1Label.textColor = [UIColor blackColor];
    level1Label.textAlignment = NSTextAlignmentCenter;
    level1Label.text=@"Complication level 1";
    [scrollview addSubview:level1Label];
    
    level2Label = [[UILabel alloc]initWithFrame:CGRectMake(35, 380, 250, 40)];
    level2Label.numberOfLines = 1;
    level2Label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    level2Label.adjustsFontSizeToFitWidth = YES;
    //level2Label.adjustsLetterSpacingToFitWidth = YES;
    level2Label.minimumScaleFactor = 10.0f/12.0f;
    level2Label.clipsToBounds = YES;
    level2Label.backgroundColor = [UIColor clearColor];
    level2Label.textColor = [UIColor blackColor];
    level2Label.textAlignment = NSTextAlignmentCenter;
    level2Label.text=@"Complication level 2";
    /*btnLayer = [level1Label layer];
     [btnLayer setMasksToBounds:YES];
     [btnLayer setCornerRadius:5.0f];
     [btnLayer setBorderWidth:1.0f];
     [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];*/
    [scrollview addSubview:level2Label];
    
    bedButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bedButton addTarget:self action:@selector(clickBedButton) forControlEvents:UIControlEventTouchUpInside];
    [bedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    bedButton.frame=CGRectMake(35.0f, 440.0f, 250.0f, 40.0f);
    [bedButton setTitle:@"Select Bed" forState:UIControlStateNormal];
    [bedButton setBackgroundColor:[UIColor lightGrayColor]];
    btnLayer = [bedButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:bedButton];
    
    bedLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 500, 250, 40)];
    bedLabel.numberOfLines = 2;
    bedLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    bedLabel.adjustsFontSizeToFitWidth = YES;
    //bedLabel.adjustsLetterSpacingToFitWidth = YES;
    bedLabel.minimumScaleFactor = 10.0f/12.0f;
    bedLabel.clipsToBounds = YES;
    bedLabel.backgroundColor = [UIColor clearColor];
    bedLabel.textColor = [UIColor blackColor];
    bedLabel.textAlignment = NSTextAlignmentCenter;
    bedLabel.text=@"Bed Number";
    [scrollview addSubview:bedLabel];
    
    addLogButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addLogButton addTarget:self action:@selector(clickAddLogButton) forControlEvents:UIControlEventTouchUpInside];
    [addLogButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addLogButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    addLogButton.frame=CGRectMake(35.0f, 560.0f, 250.0f, 40.0f);
    [addLogButton setTitle:@"Add to log" forState:UIControlStateNormal];
    [addLogButton setBackgroundColor:[UIColor lightGrayColor]];
    btnLayer = [addLogButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [scrollview addSubview:addLogButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) checkinput{
    if ([FINLog isEqualToString:@"Select FIN"]) {
        return 1;
    }
    if ([level1Log isEqualToString:@"Select level1"]) {
        return 2;
    }
    if ([level2Log isEqualToString:@"Select level2"]) {
        return 3;
    }
    if ([bedLog isEqualToString:@"Select bed"]) {
        return 4;
    }
    if ([sublocationLog isEqualToString:@"Select sublocation"]) {
        return 1;
    }
    return 0;
}

-(void)clickFINButton{
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select FIN", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    FINPicker=[[UIPickerView alloc]init];
    FINPicker.delegate=self;
    FINPicker.dataSource=self;
    FINPicker.showsSelectionIndicator=YES;
    sheet.tag=1;
    [sheet addSubview:FINPicker];
}

-(void)clickComplicationsButton{
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select complication", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    level1Picker=[[UIPickerView alloc]init];
    level1Picker.delegate=self;
    level1Picker.dataSource=self;
    level1Picker.showsSelectionIndicator=YES;
    sheet.tag=2;
    [sheet addSubview:level1Picker];
}

-(void)clickBedButton{
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select Bed", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    bedPicker=[[UIPickerView alloc]init];
    bedPicker.delegate=self;
    bedPicker.dataSource=self;
    bedPicker.showsSelectionIndicator=YES;
    sheet.tag=4;
    [sheet addSubview:bedPicker];
}

-(void)clickAdminButton{
    admin *adminView=[self.storyboard instantiateViewControllerWithIdentifier:@"admin"];
    [self presentViewController:adminView animated:YES completion:nil];
}

-(void)clickAddLogButton{
    NSInteger s=[self checkinput];
    NSString *Imessage;
    if (s==1) {
        Imessage=@"Please select FIN.";
    }
    if (s==2) {
        Imessage=@"Please select Complication level1.";
    }
    if (s==3) {
        Imessage=@"Please select Complication level2.";
    }
    if (s==4) {
        Imessage=@"Please select Bed Number.";
    }
    if (s==5) {
        Imessage=@"Please select sublocation.";
    }
    if(s>0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incompleted Input" message:Imessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSInteger IDhere=[self check24];
        if(IDhere>-1){
            NSString *phyname;
            NSInteger i=0;
            for (i=0; i<phyID.count; ++i) {
                if (IDhere==[[phyID objectAtIndex:i]intValue]) {
                    phyname=[fullnames objectAtIndex:i];
                }
            }
            Imessage=[NSString stringWithFormat:@"%@ have added same log within 24 hours.Still want to add?",phyname];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:Imessage delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag=1;
            [alert show];
        }else{
            [self insert];
        }
    }
}

-(void)insert{
    NSLog(@"Start to insert.");
    NSInteger maxID=0;
    for(int i=0;i<comlogID.count;++i){
        if (maxID<[[comlogID objectAtIndex:i]intValue]) {
            maxID=[[comlogID objectAtIndex:i]intValue];
        }
    }
    maxID++;
    domainName=@"ComplicationLog";
    NSLog(@"item:%ld, ID:%ld, LogTime:%@, PhyID:%@, BedID:%@, PatientFIN:%@, ComID:%@",(long)maxID,(long)maxID,timeLabel.text,physiciansID,bID,FINLog,compID);
    SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:@"ID" andValue:[NSString stringWithFormat:@"%ld",(long)maxID] andReplace:YES];
    SimpleDBReplaceableAttribute *attrib2=[[SimpleDBReplaceableAttribute alloc]initWithName:@"LogTime" andValue:timeLabel.text andReplace:YES];
    SimpleDBReplaceableAttribute *attrib3=[[SimpleDBReplaceableAttribute alloc]initWithName:@"PhysiciansID" andValue:physiciansID andReplace:YES];
    SimpleDBReplaceableAttribute *attrib4=[[SimpleDBReplaceableAttribute alloc]initWithName:@"BedID" andValue:bID andReplace:YES];
    SimpleDBReplaceableAttribute *attrib5=[[SimpleDBReplaceableAttribute alloc]initWithName:@"PatientFIN" andValue:FINLog andReplace:YES];
    SimpleDBReplaceableAttribute *attrib6=[[SimpleDBReplaceableAttribute alloc]initWithName:@"ComplicationID" andValue:compID andReplace:YES];
    NSMutableArray *attribList=[[NSMutableArray alloc]initWithObjects:attrib1, attrib2,attrib3,attrib4,attrib5,attrib6, nil];
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:[NSString stringWithFormat:@"%ld",(long)maxID] andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Have added Log" message:@"" delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=2;
        [alert show];
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
}

-(NSInteger)check24{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *time1 = [[NSDate alloc] init],*time2=[[NSDate alloc]init];
    time1 = [dateFormatter dateFromString:timeLabel.text];
    NSInteger phyID=-1;
    for (int i=0; i<level2.count; ++i) {
        if ([level1Log isEqualToString:[level1 objectAtIndex:i]] && [level2Log isEqualToString:[level2 objectAtIndex:i]]) {
            compID=[complicationID objectAtIndex:i];
            break;
        }
    }
    for (int i=0; i<bed.count; ++i) {
        if ([bedLog isEqualToString:[bed objectAtIndex:i]] && [sublocationLog isEqualToString:[sublocation objectAtIndex:i]]) {
            bID=[bedID objectAtIndex:i];
            break;
        }
    }
    
    NSInteger logcount=[self loadComplicationLog],i;
    for (i=0; i<logcount; ++i) {
        time2=[dateFormatter dateFromString:[comlogLogTime objectAtIndex:i]];
        NSTimeInterval secondsBetween = [time1 timeIntervalSinceDate:time2]/3600;
        if ([FINLog isEqualToString:[comlogPatFIN objectAtIndex:i]] && [compID isEqualToString:[comlogcomlog objectAtIndex:i]] && [bID isEqualToString:[comlogBedID objectAtIndex:i]] && secondsBetween<24) {
            return [[comlogphyID objectAtIndex:i] intValue];
        }
    }
    return phyID;
}

-(void) loadUsernames{
    fullnames=[[NSMutableArray alloc]init];
    firstname=[[NSMutableArray alloc]init];
    lastname=[[NSMutableArray alloc]init];
    phyID=[[NSMutableArray alloc]init];
    NSString *a,*b,*fullname;
    NSInteger i=1;
    NSLog(@"Start to load usernames information from database in management view.");
    NSString *domainName=[[NSString alloc]initWithFormat:@"Physicians"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"AKIAIRLA73QCMCCGCKQA" withSecretKey:@"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"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select Firstname,Lastname,ID from %@",domainName];
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
            if([attri.name isEqualToString:@"ID"]){
                [phyID addObject:(id)attri.value];
            }
        }
        fullname=[NSString stringWithFormat:@"%@ %@",a,b];
        [fullnames addObject:(id)fullname];
        i++;
    }
    NSLog(@"Finish load username from dataBase in management view");
}

-(NSInteger)loadComplicationLog{
    NSLog(@"Start to load complication log");
    comlogID=[[NSMutableArray alloc]init];
    comlogLogTime=[[NSMutableArray alloc]init];
    comlogphyID=[[NSMutableArray alloc]init];
    comlogBedID=[[NSMutableArray alloc]init];
    comlogPatFIN=[[NSMutableArray alloc]init];
    comlogcomlog=[[NSMutableArray alloc]init];
    domainName=[[NSString alloc]initWithFormat:@"ComplicationLog"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"AKIAIRLA73QCMCCGCKQA" withSecretKey:@"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"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select * from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    for (SimpleDBItem *item in select1Response.items){
        for(SimpleDBAttribute *attri in item.attributes){
            if([attri.name isEqualToString:@"ID"]){
                [comlogID addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"LogTime"]){
                [comlogLogTime addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"PhysiciansID"]){
                [comlogphyID addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"BedID"]){
                [comlogBedID addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"PatientFIN"]){
                [comlogPatFIN addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"ComplicationID"]){
                [comlogcomlog addObject:(id)attri.value];
            }
        }
    }
    NSLog(@"Finish to load complication log. %lu",(unsigned long)comlogcomlog.count);
    return comlogcomlog.count;
}

-(NSInteger)loadFIN{
    FIN=[[NSMutableArray alloc]init];
    domainName=@"PatientEncounter";
    NSString *selectExpression=[NSString stringWithFormat:@"select FIN from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    NSLog(@"Start to load FIN information from database in management view.");
    for (SimpleDBItem *item in select1Response.items){
        for(SimpleDBAttribute *attri in item.attributes){
            if([attri.name isEqualToString:@"FIN"]){
                [FIN addObject:(id)attri.value];
            }
        }
    }
    NSLog(@"Finish load FIN from dataBase in management view");
    return FIN.count;
}

-(NSInteger)loadlevel1{
    level1=[[NSMutableArray alloc]init];
    level2=[[NSMutableArray alloc]init];
    level1show=[[NSMutableArray alloc]init];
    complicationID=[[NSMutableArray alloc]init];
    domainName=@"complications";
    NSString *selectExpression=[NSString stringWithFormat:@"select ID,level1,level2 from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    NSLog(@"Start to load Complication information from database in management view.");
    for (SimpleDBItem *item in select1Response.items){
        for(SimpleDBAttribute *attri in item.attributes){
            if([attri.name isEqualToString:@"ID"]){
                [complicationID addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"level1"]){
                [level1 addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"level2"]){
                [level2 addObject:(id)attri.value];
            }
        }
    }
    [level1show addObject:(id)[level1 objectAtIndex:0]];
    for(int i=1;i<level1.count;++i){
        if(![[level1 objectAtIndex:i] isEqualToString:[level1 objectAtIndex:i-1]]){
            [level1show addObject:[level1 objectAtIndex:i]];
        }
    }
    NSLog(@"Finish load Complication from dataBase in management view");
    return level1show.count;
}

-(NSInteger)loadBed{
    NSMutableArray *bed1=[[NSMutableArray alloc]init];
    bed=[[NSMutableArray alloc]init];
    sublocation=[[NSMutableArray alloc]init];
    bedshow=[[NSMutableArray alloc]init];
    bedID=[[NSMutableArray alloc]init];
    domainName=@"CVICU_bed";
    NSString *selectExpression=[NSString stringWithFormat:@"select ID,BedNumber,sublocation from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    NSLog(@"Start to load bed information from database in management view.");
    for (SimpleDBItem *item in select1Response.items){
        for(SimpleDBAttribute *attri in item.attributes){
            if([attri.name isEqualToString:@"ID"]){
                [bedID addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"BedNumber"]){
                [bed addObject:(id)attri.value];
                [bed1 addObject:(id)attri.value];
            }
            if([attri.name isEqualToString:@"sublocation"]){
                [sublocation addObject:(id)attri.value];
            }
        }
    }
    for(int i=0;i<bed1.count-1;++i){
        for (int j=i+1; j<bed1.count; ++j) {
            if ([[bed1 objectAtIndex:i] intValue]>[[bed1 objectAtIndex:j] intValue]) {
                NSNumber *t=[bed1 objectAtIndex:i];
                [bed1 replaceObjectAtIndex:i withObject:(id)[bed1 objectAtIndex:j]];
                [bed1 replaceObjectAtIndex:j withObject:t];
            }
        }
    }
    [bedshow addObject:(id)[bed1 objectAtIndex:0]];
    for(int i=1;i<bed1.count;++i){
        if(![[bed1 objectAtIndex:i] isEqualToString:[bed1 objectAtIndex:i-1]]){
            [bedshow addObject:[bed1 objectAtIndex:i]];
        }
    }
    NSLog(@"Finish load Bed from dataBase in management view");
    return bedshow.count;
}

-(NSInteger)loadlevel2{
    level2show=[[NSMutableArray alloc]init];
    for (int i=0; i<level1.count; ++i) {
        if ([level1Log isEqual:[level1 objectAtIndex:i]] && ![[level2 objectAtIndex:i] isEqualToString:@" "]) {
            [level2show addObject:(id)[level2 objectAtIndex:i]];
        }
    }
    return level2show.count;
}

-(NSInteger)loadsublocation{
    sublocationshow=[[NSMutableArray alloc]init];
    for (int i=0; i<bed.count; ++i) {
        if ([bedLog isEqual:[bed objectAtIndex:i]] && ![[sublocation objectAtIndex:i] isEqualToString:@" "]) {
            [sublocationshow addObject:(id)[sublocation objectAtIndex:i]];
        }
    }
    return sublocationshow.count;
}

-(void)displayTime{
    NSDate *currentTime = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    timeLabel.text=resultString;
}

-(void)clickLogoutButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if([pickerView isEqual:FINPicker]){
        return FINcount+1;
    }
    if([pickerView isEqual:level1Picker]){
        return level1Count+1;
    }
    if([pickerView isEqual:level2Picker]){
        return level2Count+1;
    }
    if([pickerView isEqual:bedPicker]){
        return bedCount+1;
    }
    if([pickerView isEqual:sublocationPicker]){
        return sublocationCount+1;
    }
    return 0;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([pickerView isEqual:FINPicker]){
        if(row==0){
            return @"Select FIN";
        }else{
            return [FIN objectAtIndex:row-1];
        }
    }
    if([pickerView isEqual:level1Picker]){
        if(row==0){
            return @"Select Complication level1";
        }else{
            return [level1show objectAtIndex:row-1];
        }
    }
    if([pickerView isEqual:level2Picker]){
        if(row==0){
            return @"Select Complication level2";
        }else{
            return [level2show objectAtIndex:row-1];
        }
    }
    if([pickerView isEqual:bedPicker]){
        if(row==0){
            return @"Select Bed";
        }else{
            return [bedshow objectAtIndex:row-1];
        }
    }
    if([pickerView isEqual:sublocationPicker]){
        if(row==0){
            return @"Select Sublocation";
        }else{
            return [sublocationshow objectAtIndex:row-1];
        }
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:FINPicker]){
        if(row>0){
            [FINLabel setText:[NSString stringWithFormat:@"%@%@", @"FIN: ",[FIN objectAtIndex:row-1]]];
            FINLog=[FIN objectAtIndex:row-1];
        }else{
            [FINLabel setText:@"Select FIN"];
            FINLog=@"Select FIN";
        }
    }
    if([pickerView isEqual:level1Picker]){
        if(row>0){
            [level1Label setText:[NSString stringWithFormat:@"%@",[level1show objectAtIndex:row-1]]];
            level1Log=[level1show objectAtIndex:row-1];
            
        }else{
            level1Log=@"Select level1";
        }
    }
    if([pickerView isEqual:level2Picker]){
        if(row>0){
            [level2Label setText:[NSString stringWithFormat:@"%@",[level2show objectAtIndex:row-1]]];
            level2Log=[level2show objectAtIndex:row-1];
            
        }else{
            level2Log=@"Select level2";
        }
    }
    if([pickerView isEqual:bedPicker]){
        if(row>0){
            [bedLabel setText:[NSString stringWithFormat:@"%@",[bedshow objectAtIndex:row-1]]];
            bedLog=[bedshow objectAtIndex:row-1];
            
        }else{
            bedLog=@"Select bed";
        }
    }
    if([pickerView isEqual:sublocationPicker]){
        if(row>0){
            [bedLabel setText:[NSString stringWithFormat:@"Bed: %@, Sublocation: %@",bedLog,[sublocationshow objectAtIndex:row-1]]];
            sublocationLog=[sublocationshow objectAtIndex:row-1];
        }else{
            sublocationLog=@"Select sublocation";
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0 && actionSheet.tag==2) {
        level2Count=[self loadlevel2];
        if (level2Count>0) {
            NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select complication", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
            [sheet showInView:self.view];
            level2Picker=[[UIPickerView alloc]init];
            level2Picker.delegate=self;
            level2Picker.dataSource=self;
            level2Picker.showsSelectionIndicator=YES;
            sheet.tag=3;
            [sheet addSubview:level2Picker];
        }else{
            [level2Label setText:@"No option"];
            level2Log=@" ";
        }
    }
    if (buttonIndex==0 && actionSheet.tag==4) {
        sublocationCount=[self loadsublocation];
        if (sublocationCount>0) {
            NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select sublocation", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
            [sheet showInView:self.view];
            sublocationPicker=[[UIPickerView alloc]init];
            sublocationPicker.delegate=self;
            sublocationPicker.dataSource=self;
            sublocationPicker.showsSelectionIndicator=YES;
            sheet.tag=5;
            [sheet addSubview:sublocationPicker];
        }else{
            [bedLabel setText:@"Please select bed"];
            sublocationLog=@"Select sublocation";
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1) {
        if(buttonIndex==1){
            [self insert];
        }
    }
}

@end
