//
//  CoinsViewController.m
//  iphoneLive
//
//  Created by christlee on 16/8/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "CoinsViewController.h"
#import "CoinsCell.h"
#import <StoreKit/StoreKit.h>

@interface CoinsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *coinsList;


//IAP
@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSMutableSet *purchasedProducts;
@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, copy) NSString *OrderNo;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSString *orderId;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation CoinsViewController

static NSString * const coinsCellIdentifier = @"CoinsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-33)/2, (SCREEN_WIDTH-33)/2);
        layout.sectionInset = UIEdgeInsetsMake(0, 11, 0, 11);
    layout.minimumInteritemSpacing = 11;
    layout.minimumLineSpacing = 10;
    
    _collectionView.collectionViewLayout = layout;
//    _collectionView.backgroundColor = COLOR(243, 243, 243, 1.0);
    
    UINib *nib = [UINib nibWithNibName:@"CoinsCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:coinsCellIdentifier];
    
    __weak UICollectionView *weakCollectionView = self.collectionView;

    [HttpService getCoinsListWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *temp in commonReturn.data) {
                [array addObject:[[CoinsModel alloc] initWithDictionary:temp]];
            }
            self.coinsList = array;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakCollectionView reloadData];
            [weakCollectionView.mj_header endRefreshing];
        });
    }];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.headerView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
    self.coinsLabel.text = [Config getpersonInfoModel].coin;
//    self.collectionView.backgroundColor = [UIColor colorWithRed:162/255.0 green:109/255.0 blue:215/255.0 alpha:1];
    self.collectionView.backgroundView = [[UIView alloc] init];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.collectionView.backgroundView hexColorStart:col_view_bg_lt_purple hexColorEnd:col_view_bg_drk_purple];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Button
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_coinsList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoinsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:coinsCellIdentifier forIndexPath:indexPath];
    
    CoinsModel *model = _coinsList[indexPath.row];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *num = [NSNumber numberWithFloat:[model.coins intValue]];
    cell.coinsLabel.text = [formatter stringFromNumber:num];
    
    if (model.bonus != nil && ![model.bonus isEqualToString:@"0"]) {
        cell.bonusLabel.hidden = NO;
        cell.bonusLabel.text = [NSString stringWithFormat:@"+%@ BONUS", model.bonus];
    } else {
        cell.bonusLabel.hidden = YES;
    }
    
    [cell.usdButton setTitle:[NSString stringWithFormat:@"$%@", model.usd] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    
    [self purchase];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)purchase {
    CoinsModel *model = _coinsList[_selectedIndexPath.row];
    NSSet *productSet = [[NSSet alloc] initWithObjects:model.appleProduct, nil];
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    self.request.delegate = self;
    
    [MBProgressHUD showMessage:@"waiting"];
    [self.request start];
}

/////////////////////////////////////////////
#pragma mark - SKProductsRequestDelegate
/////////////////////////////////////////////
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.request = nil;
    
    for (SKProduct *product in response.products) {
        NSLog(@"get product info, title:%@, des:%@, price:%@",product.localizedTitle, product.localizedDescription,product.price);
        self.product = product;
        
        break;
    }
    
    if (!self.product) {
        [MBProgressHUD hideHUD];
        [self showAlertView:@"Failed!"];
        
        return;
    }
    
    CoinsModel *model = _coinsList[_selectedIndexPath.row];
    [HttpService getOrderWithProductId:model.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            self.orderId = commonReturn.data[@"order_id"];
            
            //Get the product information, join the payment queue
            SKPayment *payment = [SKPayment paymentWithProduct:self.product];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            [MBProgressHUD hideHUD];
            [self showAlertView:@"Purchase failure!"];
        }
    }];
}

/////////////////////////////////////////////
#pragma mark - SKPaymentTransactionObserver
/////////////////////////////////////////////
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    
    [self verifyReceipt:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // Optional: Record the transaction on the server side...
    //Record the current purchase of a successful product
    // NSLog(@"recordTransaction");
}

- (void)provideContent:(NSString *)productIdentifier {
    
    // NSLog(@"provideContent %@", productIdentifier);
    //In view of the purchase of goods, provide different services.
    [_purchasedProducts addObject:productIdentifier];
}

#pragma mark 服务器验证购买凭据 ('server purchase identification')
- (void) verifyReceipt:(SKPaymentTransaction *)transaction {
    NSString *receiptEncoding = [transaction.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
// use HttpController call for stage_mode only
#if run_stage_mode
    [HttpController appPayWithOrderId:self.orderId receipt:receiptEncoding callback:^(CommonReturn *cr) {
        [MBProgressHUD hideHUD];
        
        if (cr.state == 1) {
            if (cr.ret == 0) {
                [MBProgressHUD showSuccess:@"Purchase success"];
            } else {
                [MBProgressHUD showError:@"Purchase failure!"];
            }
        } else {
            [MBProgressHUD showError:@"Purchase failed! Please check your internet!"];
        }
    }];

#else // use HttpService call for release_mode and sandbox_mode
    [HttpService appPayWithOrderId:self.orderId receipt:receiptEncoding result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        
        if (commonReturn.state == 1) {
            [MBProgressHUD showSuccess:@"Purchase success"];
        } else {
            [MBProgressHUD showError:@"Purchase failure!"];
        }
    }];
#endif
    
//    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.102/ios/sanbox.php"];
//    NSURL *url = [NSURL URLWithString:[purl stringByAppendingFormat:@"/appcmf/Pay/index/notify_ios"]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//    request.HTTPMethod = @"POST";
//    
//    NSString *encodeStr = [transaction.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//
//    int isSandBox =0;
//#ifdef TEST_SANDBOX
//    isSandBox=1;
//#endif
//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\",\"sandbox\":%d,\"out_trade_no\" : \"%@\"}", encodeStr,isSandBox,self.OrderNo];
//    //把bodyString转换为NSData数据
//    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];//把bodyString转换为NSData数据
//    [request setHTTPBody:bodyData];
//    
//    // 提交验证请求，并获得官方的验证JSON结果
//    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    
//    NSString *debugaa = [[NSString alloc] initWithData:result  encoding:NSUTF8StringEncoding];
//    // 官方验证结果为空
//    
//    [MBProgressHUD hideHUD];
//    if (result == nil) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"验证失败"];
//    }
//    else
//    {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        if(dict==nil)
//        {
//            [MBProgressHUD showError:@"请查看网站是否开启了调试模式"];
//            return;
//        }
//        if ([[dict valueForKey:@"status"] isEqualToString:@"success"]) {
//            // 比对字典中以下信息基本上可以保证数据安全
//            [MBProgressHUD showSuccess:@"充值成功"];
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [self doReturn];
////            });
////            
//        }
//        
//        else
//        {
//            [MBProgressHUD showError:[dict valueForKey:@"info"] ];
//            
//        }
//    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [self showAlertView:@"用户已恢复购买"];
    [MBProgressHUD hideHUD];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [MBProgressHUD hideHUD];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self showAlertView:transaction.error.localizedDescription];
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }else{
        [self showAlertView:@"Cancel purchase"];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Prompt" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
