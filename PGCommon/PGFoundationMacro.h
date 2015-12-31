//
//  PGFoundationMacro.h
//  PGUtil
//
//  Created by hql on 15/6/21.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#ifndef PGUtil_PGFoundationMacro_h
#define PGUtil_PGFoundationMacro_h

#ifdef DEBUG
#define PGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PGLog(...)
#endif

// block self
//#define WEAKSELF typeof(&*self) __weak weakSelf = self;
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// image STRETCH
#define PG_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

#endif
