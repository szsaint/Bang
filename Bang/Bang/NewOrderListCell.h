//
//  NewOrderListCell.h
//  iBang
//
//  Created by yyx on 15/10/2.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderListCell : UITableViewCell

@property (strong, nonatomic) NSString *orderId;
@property (nonatomic) NSUInteger status;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *serverId;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *snLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
