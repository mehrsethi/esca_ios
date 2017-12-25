//
//  TranslationModel.m
//  FinalApp
//
//  Created by Mehr Sethi on 12/4/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "TranslationModel.h"

@implementation TranslationModel

//tranlate words using the google translation API
+ (NSString*)translateJSON:(NSString*)q targetLang:(NSString*)target sourceLang:(NSString*)source{
    NSError* error;
    NSData* translationData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://translation.googleapis.com/language/translate/v2?q=%@&target=%@&key=AIzaSyDVoOBlLEVo-lkk8FfoVSzODv2jTd-MoTM&source=%@", q, target, source]]];
    NSMutableDictionary* translationJson = [NSJSONSerialization JSONObjectWithData:translationData options:kNilOptions error:&error];
    NSMutableDictionary* data = [translationJson objectForKey:@"data"];
    NSMutableDictionary* translations = [[data objectForKey:@"translations"] objectAtIndex:0];
    NSString* string = [translations objectForKey:@"translatedText"];
    return string;
}

@end
