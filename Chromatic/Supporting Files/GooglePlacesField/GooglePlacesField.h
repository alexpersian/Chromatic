//
//  GooglePlacesField.h
//
//  Created by Ian Keen on 16/09/2015.
//  Copyright (c) 2015 Mustard Software. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GooglePlacesField : UITextField
@property (nonatomic, strong) IBInspectable UIFont *boldPredictionFont;
@property (nonatomic) IBInspectable CGFloat insetX;
@property (nonatomic) IBInspectable CGFloat insetY;
@property (nonatomic, strong) IBInspectable UIColor *successBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *failureBackgroundColor;
@property (readonly) NSString *selectedPlaceId;
@property (nonatomic, assign) BOOL hidePredictionWhenResigningFirstResponder; //default: NO
@end
