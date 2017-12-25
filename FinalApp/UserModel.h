//
//  UserModel.h
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

// making the model
- (instancetype) init;
+ (instancetype) sharedModel;

// getters
- (NSMutableArray*) getAllergiesArray;
- (NSMutableArray*) getMedicalArray;
- (NSMutableArray*) getYesFoods;
- (NSMutableArray*) getNoFoods;
- (NSString*) getDietPreference;
- (NSString*) getName;
- (NSInteger) getAge;
- (NSString*) getImagePath;

// setters
- (void) setDietPreference:(NSString *)dietPreference;
- (void) setName:(NSString *)name;
- (void) setAge:(NSInteger)age;
- (void) setImagePath:(NSString*)imagePath;

// add methods
- (void) addAllergy: (NSString*) allergy;
- (void) addMedical: (NSString*) medical;

// clear methods
- (void) clearAllergies;
- (void) clearMedical;
- (void) clearYesFoods;
- (void) clearNoFoods;

// update the yes and no foods arrays
- (void) editYesNoFood;
@end
