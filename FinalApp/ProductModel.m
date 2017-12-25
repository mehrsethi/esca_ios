//
//  ProductModel.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "ProductModel.h"
#import "UserModel.h"
#import "StringValues.h"

@interface  ProductModel ()

@property (strong, nonatomic) NSMutableArray *ingredientsArray;
@property (strong, nonatomic) NSMutableArray *allergensArray;
@property (nonatomic) NSInteger suitability;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) NSMutableArray *dietsArray;
@property (strong, nonatomic) NSMutableDictionary *nutritionDict;
@property (strong, nonatomic) NSMutableArray *questionableArray;
@property (strong, nonatomic) NSString *name;
@end


@implementation ProductModel

//initialize the properties
- (instancetype) init{
    if (self){
        _ingredientsArray = [[NSMutableArray alloc] init];
        _allergensArray = [[NSMutableArray alloc] init];
        _nutritionDict = [[NSMutableDictionary alloc] init];
        _dietsArray = [[NSMutableArray alloc] init];
        _questionableArray = [[NSMutableArray alloc] init];
        _suitability = 100;
        _user = [UserModel sharedModel];
    }
    return self;
}


// accessing the model
+ (instancetype) sharedModel{
    static ProductModel *productModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productModel = [[ProductModel alloc] init];
    });
    return productModel;
}


// clear methods
- (void) clearIngredients{
    [self.ingredientsArray removeAllObjects];
}

- (void) clearAllergens{
    [self.allergensArray removeAllObjects];
}

- (void) clearNutrition{
    [self.nutritionDict removeAllObjects];
}

- (void) clearDiet{
    [self.dietsArray removeAllObjects];
}


// add methods
- (void) addIngredient: (NSString*) ingredient{
    [self.ingredientsArray addObject:ingredient];
}

- (void) addAllergen: (NSString*) allergen{
    [self.allergensArray addObject:allergen];
}

- (void) addDietTag:(NSString *)dietTag{
    [_dietsArray addObject:dietTag];
}

// getters
- (NSMutableArray*) getIngredientsArray{
    return _ingredientsArray;
}

- (NSMutableArray*) getAllergensArray{
    return _allergensArray;
}

- (NSInteger) getSuitability{
    return _suitability;
}

- (NSMutableArray *) getQuestionableArray{
    return _questionableArray;
}

- (NSMutableArray *) getDietsArray{
    return _dietsArray;
}

- (NSMutableDictionary *) getNutritionDict{
    return _nutritionDict;
}

- (NSString *)getName{
    return _name;
}


// setters
- (void)setNutritionDict:(NSMutableDictionary *)nutritionDict{
    _nutritionDict = nutritionDict;
}

- (void) setSuitability:(NSInteger)suitability{
    _suitability = suitability;
}

- (void)setName:(NSString *)name{
    _name = name;
}


// calculate the suitability of the user based on their diet preferences
- (NSMutableArray*) calculateSuitability{
    //set up for calculation
    self.suitability = 100;
    [self.questionableArray removeAllObjects];
    [self.user editYesNoFood];
    
    //diet preference
    BOOL found1 = NO;
    if (![self.user.getDietPreference isEqualToString:NSLocalizedString(@"No preference", nil)]){
        for (int i=0; i<self.dietsArray.count; i++){
            if (!([self.dietsArray[i] rangeOfString:self.user.getDietPreference].location == NSNotFound)) {
                found1 = YES;
            }
        }
    }
    else{
        found1 = YES;
    }
    if (!found1){
        _suitability -= 50;
        [_questionableArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Not %@", nil), self.user.getDietPreference]];
        if (_suitability < 0){
            _suitability = 0;
        }
    }
    
    //loop through the user's allergies and see if any of them appear in allergens
    for (int i=0; i<_allergensArray.count; i++){
        for (int j=0; j<_user.getAllergiesArray.count; j++){
            if ([self.user.getAllergiesArray[j] isEqualToString:TREE_NUTS]){
                NSArray *tempArray = @[@"almond", @"pinenut", @"cashew", @"chestnut", @"hazelnut", @"pistacio", @"walnut", @"macadamia", @"pecan", @"nut"];
                BOOL found = NO;
                NSMutableArray *foundArray = [[NSMutableArray alloc] init];
                for (int k=0; k<tempArray.count; k++){
                    if ((!([[_allergensArray[i] lowercaseString] rangeOfString:tempArray[k]].location == NSNotFound)) &&([[_allergensArray[i] lowercaseString] rangeOfString:PEANUTS].location == NSNotFound)){
                        found = YES;
                    }
                }
                [foundArray addObject:_allergensArray[i]];
                if (found){
                    self.suitability -= 25;
                    for (int l=0; l<foundArray.count; l++){
                        [_questionableArray addObject:foundArray[l]];
                    }
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
            else if ([self.user.getAllergiesArray[j] isEqualToString:FISH]){
                NSArray *tempArray = @[@"anchov", @"bass", @"catfish", @"cod", @"flounder", @"grouper", @"haddock", @"hake", @"halibut", @"herring", @"mahi mahi", @"perch", @"pike", @"pollock", @"salmon", @"snapper", @"sole", @"swordfish", @"tilapia", @"trout", @"tuna", @"walleye"];
                BOOL found = NO;
                NSMutableArray *foundArray = [[NSMutableArray alloc] init];
                for (int k=0; k<tempArray.count; k++){
                    if ((!([[_allergensArray[i] lowercaseString] rangeOfString:tempArray[k]].location == NSNotFound))){
                        found = YES;
                    }
                }
                [foundArray addObject:_allergensArray[i]];
                if (found){
                    self.suitability -= 25;
                    for (int l=0; l<foundArray.count; l++){
                        [_questionableArray addObject:foundArray[l]];
                    }
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
            else if ([self.user.getAllergiesArray[j] isEqualToString:CRUSTACEAN]){
                NSArray *tempArray = @[@"crab", @"lobster", @"shrimp"];
                BOOL found = NO;
                NSMutableArray *foundArray = [[NSMutableArray alloc] init];
                for (int k=0; k<tempArray.count; k++){
                    if ((!([[_allergensArray[i] lowercaseString] rangeOfString:tempArray[k]].location == NSNotFound)) &&([[_allergensArray[i] lowercaseString] rangeOfString:PEANUTS].location == NSNotFound)){
                        found = YES;
                    }
                }
                [foundArray addObject:_allergensArray[i]];
                if (found){
                    self.suitability -= 25;
                    for (int l=0; l<foundArray.count; l++){
                        [_questionableArray addObject:foundArray[l]];
                    }
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
            else{
                if (!([[_allergensArray[i] lowercaseString] rangeOfString:[_user.getAllergiesArray[j] lowercaseString]].location == NSNotFound)){
                    self.suitability -= 25;
                    [_questionableArray addObject:_allergensArray[i]];
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
        }
    }
    
    //loop through the user's noFoods, and see if any of them appear in ingredients
    for (int j=0; j<_ingredientsArray.count; j++){
        for (int k=0; k<_user.getNoFoods.count; k++){
            if ([_user.getNoFoods[k] isEqualToString:_ingredientsArray[j]]){
                self.suitability -= 10;
                [_questionableArray addObject:_ingredientsArray[j]];
                if (_suitability < 0){
                    _suitability = 0;
                }
            }
        }
    }

    //loop through the user's yesFoods and see if any of them appear in ingredients
    for (int i=0; i<self.ingredientsArray.count; i++){
        for (int j=0; j<self.user.getYesFoods.count; j++){
            if ([self.user.getYesFoods[j] isEqualToString:self.ingredientsArray[i]]){
                self.suitability += 10;
                if (_suitability > 100){
                    _suitability = 100;
                }
            }
        }
    }
    
    //accounting for medical conditions of the user using nutritients -- besides ingredients
    for (int i=0; i<_user.getMedicalArray.count; i++){
        if ([_user.getMedicalArray[i] isEqualToString:DIABETES]){
            if ([[self.nutritionDict objectForKey:@"sugars"] isEqualToString:@"high"]){
                self.suitability -= 10;
                [self.questionableArray addObject:@"High sugar"];
                if (_suitability < 0){
                    _suitability = 0;
                }
            }
        }
        if ([_user.getMedicalArray[i] isEqualToString:KIDNEY_DISEASES]){
            if ([[self.nutritionDict objectForKey:@"proteins"] intValue] > 18){
                self.suitability -= 10;
                [self.questionableArray addObject:@"High protein"];
                if (_suitability < 0){
                    _suitability = 0;
                }
            }
        }
        if ([_user.getMedicalArray[i] isEqualToString:KIDNEY_DISEASES] || [_user.getMedicalArray[i] isEqualToString:HIGH_CHOLESTEROL]){
            if ([[self.nutritionDict objectForKey:@"salt"] isEqualToString:@"high"]){
                BOOL found = NO;
                for (int j=0; j<self.questionableArray.count; j++){
                    if ([self.questionableArray[j] isEqualToString:@"High salt"]){
                        found = YES;
                    }
                }
                if (!found){
                    self.suitability -= 10;
                    [self.questionableArray addObject:@"High salt"];
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
        }
        if ([_user.getMedicalArray[i] isEqualToString:OSTEOPOROSIS] || [_user.getMedicalArray[i] isEqualToString:HIGH_CHOLESTEROL] || [_user.getMedicalArray[i] isEqualToString:GOUT]){
            if ([[self.nutritionDict objectForKey:@"fat"] isEqualToString:@"high"]){
                BOOL found = NO;
                for (int j=0; j<self.questionableArray.count; j++){
                    if ([self.questionableArray[j] isEqualToString:@"High fat"]){
                        found = YES;
                    }
                }
                if (!found){
                    self.suitability -= 10;
                    [self.questionableArray addObject:@"High fat"];
                    if (_suitability < 0){
                        _suitability = 0;
                    }
                }
            }
        }
        if ([_user.getMedicalArray[i] isEqualToString:GOUT]){
            if ([[self.nutritionDict objectForKey:@"proteins"] intValue] > 18){
                self.suitability += 10;
                if (_suitability > 100){
                    _suitability = 100;
                }
            }
        }
    }
    return self.questionableArray;
}

@end
