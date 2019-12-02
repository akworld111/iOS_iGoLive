
//  ProfileSetupViewController.m
//  iphoneLive
//
//  Created by AK on 17/2/3.
//  Copyright © 2017 igo.live All rights reserved.
//

#import "ProfileSetupViewController.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetLocalePicker.h"
#import "LMImageSelector.h"
#import "ProfileSetUpTableViewCell.h"
#import "ProfilePictureAndGenderCell.h"
#import "UserIntroViewController.h"
#import "InterestView.h"

@interface ProfileSetupViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ProfilePictureAndGenderCellDelegate,UITextFieldDelegate,InterestViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *interestsArray;
@property (strong, nonatomic) LMImageSelector *selector;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) PersonalInfoModel *personalInfoModelmodel;
@property (assign, nonatomic) BOOL uploadImage;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic , strong) NSMutableArray *interesstArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *interestViewHeight;
@property (strong, nonatomic) IBOutlet InterestView *interestView;
@property (nonatomic , strong) XHFriendlyLoadingView *loadingView;
@property (nonatomic , strong) NSString * name;


@end

@implementation ProfileSetupViewController {
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    BOOL isEditMode;
    NSDate *_selectDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _personalInfoModelmodel = [[PersonalInfoModel alloc]init];

    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_window_width-120)/2, 0, 120, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.text = @"Profile Setup";
    [self.navigationController.navigationBar addSubview:_titleLabel];
    
    _personalInfoModelmodel.gender = @"2";
    self.interestsArray = [NSMutableArray array];
    _tableView.delegate  =self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ProfileSetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProfilePictureAndGenderCell" bundle:nil] forCellReuseIdentifier:@"pictureCell"];
    _uploadImage = NO;
    _interesstArray = [NSMutableArray array];
    self.nextBtn.userInteractionEnabled = NO;
    
    _loadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _loadingView.backgroundColor = [UIColor whiteColor];
    [self.interestView addSubview:_loadingView];
    [self getUserInterestList];
    
    if (self.type == 1) {
        [self.nextBtn setTitle:@"Save" forState:UIControlStateNormal];
        _personalInfoModelmodel.userNickname = _userModel.userNickname;
        _name = _userModel.userNickname;
        _personalInfoModelmodel.signature = _userModel.signature;
        _personalInfoModelmodel.birthday = _userModel.birthday;
        _personalInfoModelmodel.city = _userModel.city;
        _personalInfoModelmodel.interests = _userModel.interests;
        _personalInfoModelmodel.avatar = _userModel.avatar;
        _uploadImage = [_userModel.avatar hasPrefix:@"http"]?YES:NO;
        
    }else{
        [self.nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    }
    
    [self.btnNextRelease setHidden:YES];
    
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        
        /* eg_09.14.16: trying to get dynamic table view height for 'editMode' */
        //int cellHeight = 85; // set in ProfileSetupTableViewcell.m
        //CGRect tframe = _tableView.frame;
        //tframe.size.height = (cellHeight * 2) + 50;
        //_tableView.frame = tframe;
        
        /*
            eg_09.14.16: not needed with autolayout correction
         */
        //[self.scrollView setScrollEnabled:NO];
        //
        //[self.interestView setHidden:YES];
        //[self.btnNextRelease setHidden:NO];
        //[_nextBtn setHidden:YES];
        //_nextBtn = self.btnNextRelease;
    }
    
    /* eg_09.14.16: trying to get dynamic table view height for 'editMode' */
    //[ViewModifierHelpers setBorderWidth:5.0f color:[UIColor greenColor].CGColor forView:_tableView];
    
    _selectDate = [self birthdayDateFromString:_personalInfoModelmodel.birthday];
}

/* eg_09.14.16: trying to get dynamic table view height for 'editMode' */
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    // hides all fields except nick name & birthday
//    //  default image will be set on server side
//    if (!isEditMode){
//        int cellHeight = 85; // set in ProfileSetupTableViewcell.m
//        CGRect tframe = _tableView.frame;
//        tframe.size.height = (cellHeight * 2) + 50;
//        _tableView.frame = tframe;
//        
//        /*
//         eg_09.14.16: not needed with autolayout correction
//         */
//        //[self.scrollView setScrollEnabled:NO];
//        //
//        //[self.interestView setHidden:YES];
//        //[self.btnNextRelease setHidden:NO];
//        //[_nextBtn setHidden:YES];
//        //_nextBtn = self.btnNextRelease;
//    }
//    
//    //[ViewModifierHelpers setBorderWidth:5.0f color:[UIColor greenColor].CGColor forView:_tableView];
//}
- (void)getUserInterestList {
    [_loadingView showFriendlyLoadingViewWithText:@"Loading..." loadingAnimated:YES];
    __weak typeof(self) weakSelf = self;
    _loadingView.reloadButtonClickedCompleted = ^(UIButton *sender){
        [weakSelf getUserInterestList];
    };

    [HttpService getUserInterestListResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state==1) {
            if (_loadingView) {
                [_loadingView hideLoadingView];
            }
            NSArray *array = commonReturn.data;
            for (int i=0; i<array.count; i++) {
                InterestModel *model = [[InterestModel alloc]initWithDictionary:array[i]];
                [_interesstArray addObject:model];
                _interestViewHeight.constant = (32 + 5)*(_interesstArray.count/3+_interesstArray.count%3)+40;
            }
            InterestView *view = [[InterestView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, _interestViewHeight.constant) withArray:_interesstArray withSelectInterestArray:_userModel.interests];
            view.delegate = self;
            [_interestView addSubview:view];
        }else{
            if (_loadingView) {
                [_loadingView showReloadViewWithText:@"Click to reload"];
            }
        }
        
    }];
}

- (void)sendArray:(NSMutableArray *)array {
    [self.scrollView endEditing:YES];
    _personalInfoModelmodel.interests = array;
    [self updateNextButtonProperties];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    _titleLabel.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _titleLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        return 2;
    }
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        ProfileSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.section==1) {
            cell.contentTextFiled.userInteractionEnabled = NO;
            cell.titleLabel.text = @"Birthday";
            cell.contentTextFiled.text = [self stringFromDate:_selectDate];
        }
        else{
            cell.titleLabel.text = @"Username (20 character limit)";
            cell.contentTextFiled.text = _personalInfoModelmodel.userNickname;
        }
        cell.contentTextFiled.delegate = self;
        cell.contentTextFiled.tag = indexPath.section+1;
        cell.selectionStyle = 0;
        return cell;
    }

    
    if (indexPath.section<2||indexPath.section==4||indexPath.section==5) {
        ProfileSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.section==4) {
            cell.contentTextFiled.userInteractionEnabled = NO;
            cell.titleLabel.text = @"Birthday";
            cell.contentTextFiled.text = [self stringFromDate:_selectDate];
        }else if (indexPath.section==1){
            cell.titleLabel.text = @"Bio (50 character limit)";
            cell.contentTextFiled.text = _personalInfoModelmodel.signature;
        }else if (indexPath.section==5){
            cell.titleLabel.text = @"Location";
            cell.contentTextFiled.text = _personalInfoModelmodel.city;
        }
        else{
            cell.titleLabel.text = @"Username (20 character limit)";
            cell.contentTextFiled.text = _personalInfoModelmodel.userNickname;
        }
        cell.contentTextFiled.delegate = self;
        cell.contentTextFiled.tag = indexPath.section+1;
        cell.selectionStyle = 0;
        return cell;
    }else{
        ProfilePictureAndGenderCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell" forIndexPath:indexPath];
        if (indexPath.section ==2) {
            pictureCell.genderView.hidden = YES;
            pictureCell.maleButton.hidden = YES;
            pictureCell.femaleButton.hidden = YES;
            pictureCell.headImageView.hidden = NO;
            pictureCell.headImageView.layer.cornerRadius = pictureCell.headImageView.frame.size.height/2;
            pictureCell.headImageView.layer.masksToBounds = YES;
            if (_type==1) {
                [pictureCell.headImageView sd_setImageWithURL:[NSURL URLWithString:_personalInfoModelmodel.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
            }else{
                pictureCell.headImageView.image = [UIImage imageNamed:@"HeadDefault"];
            }
            pictureCell.titleLabel.text = @"Profile Picture";
            
        }else{
            pictureCell.genderView.hidden = NO;
            pictureCell.maleButton.hidden = NO;
            pictureCell.femaleButton.hidden = NO;
            pictureCell.headImageView.hidden = YES;
            pictureCell.selectionStyle = 0;
            pictureCell.titleLabel.text = @"Gender";
            pictureCell.delegate = self;
        }
        return pictureCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        return 85;
    }
    
    if (indexPath.section<2||indexPath.section==4||indexPath.section==5) {
        return 85;
    }else{
        return 64;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (BOOL)validateBirthday:(NSDate *)bday {
    if(!bday)
    {
        XLM_error(@"bday is nil; returning NO");
        return NO;
    }
    
    NSDate *yearsAgo = [MiscUtilities nsdateWithYearsFromNow:-years_min_age];
    return [MiscUtilities nsdate:bday isEarlierThan:yearsAgo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.scrollView endEditing:YES];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        if (indexPath.section==1) {
            ProfileSetUpTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"Confirm Age (12+)"
                                                                          datePickerMode:UIDatePickerModeDate
                                                                            selectedDate:_selectDate?:[NSDate date]
                                                                               doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                _selectDate = selectedDate;
                /* 
                    eg_09.13.16: attempting to validate birthday AFTER selecting from UIPicker */
                //NSDate *bday = [ObjectTypeValidator nsdateFromObject:selectedDate];
                //if (![self validateBirthday:bday])
                //{
                //    XLM_alert(@"invalid bday selected: %@; presenting alert to select again", [self birthdayFromDate:selectedDate]);
                //    
                //    NSString *msg = [NSString stringWithFormat:@"You must be at least %i years old to continue", years_min_age];
                //    [AlertViewHelpers presentAlertWithTitle:@"You're Too Young : /" message:msg delegate:nil];
                //    
                //    return;
                //}
                
                cell.contentTextFiled.text = [self stringFromDate:selectedDate];
                _personalInfoModelmodel.birthday = [self birthdayFromDate:selectedDate];
                [self updateNextButtonProperties];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                XLM_error(@"\nActionSheetDatePicker -> 'cancelBlock' hit within bday picker table view;\n isEditMode == %u;\n indexPath.section == %li\n\n", isEditMode, indexPath.section);
            } origin:self.scrollView];
            
            /* china_09.13.16: validating birthday WHILE selecting from UIPicker view */
            NSDate *yearsAgo = [MiscUtilities nsdateWithYearsFromNow:-years_min_age];
            picker.maximumDate = yearsAgo;
            [picker showActionSheetPicker];
        }
        return;
    }
    
    if (indexPath.section==2) {
        self.selector = [[LMImageSelector alloc] init];
        ProfilePictureAndGenderCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        [self.selector showImageSheetWithView:self type:_type result:^(UIImage *image) {
            cell.headImageView.image = image;
            _uploadImage = YES;
            [self updateNextButtonProperties];
        }];

    }
    
    if (indexPath.section==4) {
        
        ProfileSetUpTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"select birthday" datePickerMode:UIDatePickerModeDate selectedDate:_selectDate?:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            _selectDate = selectedDate;
            cell.contentTextFiled.text = [self stringFromDate:selectedDate] ;
            _personalInfoModelmodel.birthday = [self birthdayFromDate:selectedDate];
            [self updateNextButtonProperties];

        } cancelBlock:^(ActionSheetDatePicker *picker) {
            XLM_error(@"\nActionSheetDatePicker -> 'cancelBlock' hit within bday picker table view;\n isEditMode == %u;\n indexPath.section == %i\n\n", isEditMode, (int)indexPath.section);
        } origin:self.scrollView];
        
        picker.maximumDate = [NSDate date];
        [picker showActionSheetPicker];
    }
}

- (void)chooseGenderButton:(UIButton *)sender {
//    _personalInfoModelmodel.gender = [NSString stringWithFormat:@"%ld",sender.tag-1];
    _personalInfoModelmodel.gender = [NSString stringWithFormat:@"%i", (int)sender.tag];
    [self updateNextButtonProperties];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    [self.scrollView endEditing:YES];
//    if ([_name isEqualToString:_personalInfoModelmodel.userNickname]) {
//        [MBProgressHUD showError:@"Please modify the user name"];
//        return;
//    }
    
    // note_(~end of aug '16): new model for create user integrated around end of august i think
    //  if edit mode: perform request to update profile, else: perform request to create profile
    if (isEditMode)
    {
        [self performHttpServiceUploadUserInfoRequest];
    }
    else
    {
        // NOTE_10.01.16: per jason, changed back to old model (always use update profile request)
        //  This class (ProfileSetupViewController) will now always have isEditMode == YES (ie. via VerificationViewController)
        //  Hence, this reequest for create profile, will never get called
        [self performHttpControllerCreateProfileRequest];
    }
}
- (void)performHttpServiceUploadUserInfoRequest
{
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService upLaodUserInfoWithPersonInfoModel:_personalInfoModelmodel result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state==1) {
            if  (_first==1) {
                UserIntroViewController *userIntroViewController  = [[UserIntroViewController alloc]init];
                userIntroViewController.first = _first;
                [self.navigationController pushViewController:userIntroViewController animated:YES];
            } else {
                if (_type==1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [appDelegate showTabBarController];
                }
            }
            
            LiveUser *user = [Config myProfile];
            user.user_nickname = _personalInfoModelmodel.userNickname;
            user.birthday = _personalInfoModelmodel.birthday;
            user.gender = _personalInfoModelmodel.gender;
            user.signature = _personalInfoModelmodel.signature;
            user.interests = _personalInfoModelmodel.interests;
            [Config updateProfile:user];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"icon" object:nil];
        }else{
            [ MBProgressHUD showError:commonReturn.msg];
        }
    }];
}
- (void)performHttpControllerCreateProfileRequest
{
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpController createProfileWithUserNick:_personalInfoModelmodel.userNickname birthday:_personalInfoModelmodel.birthday callback:^(CommonReturn *cr) {
        [MBProgressHUD hideHUD];
        
        if (cr.state == 1) {
            if (cr.ret == 0) {
                if  (_first==1) {
                    UserIntroViewController *userIntroViewController  = [[UserIntroViewController alloc]init];
                    userIntroViewController.first = _first;
                    [self.navigationController pushViewController:userIntroViewController animated:YES];
                } else {
                    if (_type==1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [appDelegate showTabBarController];
                    }
                }
                
                LiveUser *user = [Config myProfile];
                user.user_nickname = _personalInfoModelmodel.userNickname;
                user.birthday = _personalInfoModelmodel.birthday;
                user.gender = _personalInfoModelmodel.gender;
                user.signature = _personalInfoModelmodel.signature;
                user.interests = _personalInfoModelmodel.interests;
                [Config updateProfile:user];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"icon" object:nil];
            } else {
                [MBProgressHUD showError:@"Something went wrong, please try again"];
            }
        } else {
            [MBProgressHUD showError:cr.msg];
        }
    }];
}
- (BOOL)completeInfo {
    LiveUser *user = [Config myProfile];

    // hides all fields except nick name & birthday
    //  default image will be set on server side
    if (!isEditMode){
        if(_personalInfoModelmodel.userNickname.length==0) {
            return NO;
        }
        if (_personalInfoModelmodel.birthday.length == 0) {
            return NO;
        }
        
        return YES;
    }

    if(_personalInfoModelmodel.userNickname.length==0){
        return NO;
    }else if (_personalInfoModelmodel.signature.length==0){
        return NO;
    }else if (_personalInfoModelmodel.gender.length==0){
        return NO;
    }else if (_personalInfoModelmodel.interests.count==0){
        return NO;
    }else if (user.avatar.length==0||_uploadImage==NO){
        return NO;
    }else if (_personalInfoModelmodel.city.length==0){
        return NO;
    }else if (_personalInfoModelmodel.birthday.length == 0){
        return NO;
    }else{
        return YES;
    }
}

- (void)updateNextButtonProperties {
   
    if ([self completeInfo]) {
        self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"largeButtonInactiveCopySelected"] forState:0];
        
    } else {
        self.nextBtn.userInteractionEnabled = NO;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"largeButtonInactiveCopy"] forState:0];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length==0&&textField.text.length==1){
        self.nextBtn.userInteractionEnabled = NO;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"largeButtonInactiveCopy"] forState:0];
        return YES;
    }
    if (textField.tag==1) {
        _personalInfoModelmodel.userNickname = [NSString stringWithFormat:@"%@%@",textField.text,string] ;
        if(textField.text.length>=20){
            [self updateNextButtonProperties];
            if (string.length==0) {
                return YES;
            }else{
                return NO;

            }
        }
        
    } else if (textField.tag==2) {
        
        _personalInfoModelmodel.signature = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if(textField.text.length>=50){
            [self updateNextButtonProperties];
            if (string.length==0) {
                return YES;
            }else{
                return NO;
                
            }
        }

    } else if (textField.tag==6) {
        _personalInfoModelmodel.city = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }

    [self updateNextButtonProperties];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag==1) {
        _personalInfoModelmodel.userNickname = textField.text;
        
    } else if (textField.tag==2) {
        
        _personalInfoModelmodel.signature = textField.text;
    } else if (textField.tag==6) {
        _personalInfoModelmodel.city = textField.text;
    }
    [self updateNextButtonProperties];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSString *)birthdayFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSDate *)birthdayDateFromString:(NSString *)Date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:Date];
    return date;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.scrollView endEditing:YES];
}

////////////////////////////////////////
#pragma mark - pub - helpers
////////////////////////////////////////
- (void)setEditMode:(BOOL)edit {
    // hides all fields except nick name & birthday
    //  default image will be set on server side
    isEditMode = edit;
}

@end




