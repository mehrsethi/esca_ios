//
//  ProductModel.h
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
@property (nonatomic, strong) NSString* sourceLang;

// making the model
- (instancetype)init;
+ (instancetype) sharedModel;

// clear methods
- (void) clearIngredients;
- (void) clearAllergens;
- (void) clearDiet;
- (void) clearNutrition;

// add methods
- (void) addIngredient: (NSString*) ingredient;
- (void) addAllergen: (NSString*) allergen;
- (void) addDietTag:(NSString *)dietTag;

// getters
- (NSMutableDictionary *) getNutritionDict;
- (NSMutableArray *) getDietsArray;
- (NSMutableArray *) getIngredientsArray;
- (NSMutableArray *) getQuestionableArray;
- (NSInteger) getSuitability;
- (NSMutableArray *) getAllergensArray;
- (NSString *)getName;

// setters
- (void) setSuitability:(NSInteger)suitability;
- (void)setName:(NSString *)name;
- (void)setNutritionDict:(NSMutableDictionary *)nutritionDict;

// calculate the suitability of the product based on the user's diet preferences
- (NSMutableArray *) calculateSuitability;

@end
