//
//  TranslationModel.h
//  FinalApp
//
//  Created by Mehr Sethi on 12/4/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslationModel : NSObject

+ (NSString*)translateJSON:(NSString*)q targetLang:(NSString*)target sourceLang:(NSString*)source;

@end
