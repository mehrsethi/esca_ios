//
//  UserModel.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "UserModel.h"
#import "StringValues.h"

@interface UserModel ()

@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger age;
@property (strong, nonatomic) NSMutableArray *allergiesArray;
@property (strong, nonatomic) NSMutableArray *medicalArray;
@property (strong, nonatomic) NSMutableArray *yesFoods;
@property (strong, nonatomic) NSMutableArray *noFoods;
@property (strong, nonatomic) NSString *dietPreference;

@property (strong, nonatomic) NSString *filePath;

@end

@implementation UserModel

//initialize the properties
- (instancetype) init{
    // if the user already exists, read their information from a plist file
    if (self){
        NSString *documentsDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filename = @"userInfo.plist";
        
        self.filePath = [NSString stringWithFormat:@"%@/%@", documentsDirPath, filename];
        
        NSArray *infoInDocDir = [[NSArray alloc] initWithContentsOfFile:self.filePath];
        
        if (infoInDocDir != nil){
            _imagePath = infoInDocDir[0];
            _name = infoInDocDir[1];
            _age = [infoInDocDir[2] integerValue];
            
            [self setAllergiesArray:[NSMutableArray arrayWithArray:infoInDocDir[3]]];
            [self setMedicalArray:[NSMutableArray arrayWithArray:infoInDocDir[4]]];
            [self setYesFoods:[NSMutableArray arrayWithArray:infoInDocDir[5]]];
            [self setNoFoods:[NSMutableArray arrayWithArray:infoInDocDir[6]]];
            _dietPreference = infoInDocDir[7];
        }
        else{
            _allergiesArray = [[NSMutableArray alloc] init];
            _medicalArray = [[NSMutableArray alloc] init];
            _yesFoods = [[NSMutableArray alloc] init];
            _noFoods = [[NSMutableArray alloc] init];
            
            _imagePath = @"";
            _name = @"";
            _age = 0;
            _dietPreference = @"";
        }
    }
    return self;
}


// accessing the model
+ (instancetype) sharedModel{
    static UserModel *userModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[UserModel alloc] init];
    });
    return userModel;
}


// getters
- (NSMutableArray*) getAllergiesArray{
    return _allergiesArray;
}

- (NSMutableArray*) getMedicalArray{
    return _medicalArray;
}

- (NSMutableArray*) getYesFoods{
    return _yesFoods;
}

- (NSMutableArray*) getNoFoods{
    return _noFoods;
}

- (NSString*) getDietPreference{
    return _dietPreference;
}

- (NSString*) getName{
    return _name;
}

- (NSInteger) getAge{
    return _age;
}

- (NSString*) getImagePath{
    return _imagePath;
}


// setters
- (void) setDietPreference:(NSString *)dietPreference{
    _dietPreference = dietPreference;
    [self save];
}

- (void) setName:(NSString*)name{
    _name = name;
    [self save];
}

- (void) setAge:(NSInteger)age{
    _age = age;
    [self save];
}

- (void) setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    [self save];
}


// add methods
- (void) addAllergy: (NSString*) allergy{
    [self.allergiesArray addObject:allergy];
    [self save];
}

- (void) addMedical: (NSString*) medical{
    [self.medicalArray addObject:medical];
    [self save];
}


// clear methods
- (void) clearAllergies{
    [self.allergiesArray removeAllObjects];
}

- (void) clearMedical{
    [self.medicalArray removeAllObjects];
}

- (void) clearYesFoods{
    [self.yesFoods removeAllObjects];
}

- (void) clearNoFoods{
    [self.noFoods removeAllObjects];
}


// write the user's information to a plist file
- (void) save{
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    
    [saveArray addObject:self.imagePath];
    [saveArray addObject:self.name];
    [saveArray addObject:[NSString stringWithFormat:@"%ld", self.age]];
    [saveArray addObject:self.allergiesArray];
    [saveArray addObject:self.medicalArray];
    [saveArray addObject:self.yesFoods];
    [saveArray addObject:self.noFoods];
    [saveArray addObject:self.dietPreference];
    
    [saveArray writeToFile:self.filePath atomically:YES];
}

//loop through the medical conditions array
//and figure out which foods should be eaten/avoided by that person
//edit both yesfoods and nofoods
//and add to the allergens list, if necessary
- (void) editYesNoFood{
    for (int j=0; j<self.medicalArray.count; j++){
        if ([self.medicalArray[j] isEqualToString:GOUT]){
            BOOL found1 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:FISH]){
                    found1 = YES;
                }
            }
            if (!found1){
                [self addAllergy:FISH];
            }
            BOOL found2 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:CRUSTACEAN]){
                    found2 = YES;
                }
            }
            if (!found2){
                [self addAllergy:CRUSTACEAN];
            }
            [self.noFoods addObject:@"high-fructose-corn-syrup"];
            [self.noFoods addObject:@"anchov"];
            [self.noFoods addObject:@"sardine"];
            [self.noFoods addObject:@"mussel"];
            [self.noFoods addObject:@"codfish"];
            [self.noFoods addObject:@"scallop"];
            [self.noFoods addObject:@"trout"];
            [self.noFoods addObject:@"bacon"];
            [self.noFoods addObject:@"turkey"];
            [self.noFoods addObject:@"veal"];
            [self.noFoods addObject:@"venison"];
            [self.noFoods addObject:@"liver"];
            [self.noFoods addObject:@"caffeine"];
        }
        if ([self.medicalArray[j] isEqualToString:HIGH_CHOLESTEROL]){
            BOOL found1 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:OATS]){
                    found1 = YES;
                }
            }
            if (!found1){
                [self.yesFoods addObject:OATS];
            }
            BOOL found2 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:SOYBEANS]){
                    found2 = YES;
                }
            }
            if (!found2){
                [self.yesFoods addObject:SOYBEANS];
            }
            
            BOOL found3 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:TREE_NUTS]){
                    found3 = YES;
                }
            }
            if (!found3){
                [self.yesFoods addObject:TREE_NUTS];
            }
            
            BOOL found4 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:EGGS]){
                    found4 = YES;
                }
            }
            if (!found4){
                [self.noFoods addObject:EGGS];
            }
            
            [self.yesFoods addObject:@"porridge"];
            [self.yesFoods addObject:@"barley"];
            [self.yesFoods addObject:@"bean"];
            [self.yesFoods addObject:@"lentil"];
            [self.yesFoods addObject:@"tofu"];
        }
        if ([self.medicalArray[j] isEqualToString:LACTOSE_INTOLERANCE]){
            BOOL found = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:MILK]){
                    found = YES;
                }
            }
            if (!found){
                [self addAllergy:MILK];
            }
        }
        if ([self.medicalArray[j] isEqualToString:OSTEOPOROSIS]){
            BOOL found1 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:MILK]){
                    found1 = YES;
                }
            }
            if (!found1){
                [self.yesFoods addObject:MILK];
            }
            BOOL found2 = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:FISH]){
                    found2 = YES;
                }
            }
            if (!found2){
                [self.yesFoods addObject:@"tuna"];
                [self.yesFoods addObject:@"sardine"];
                [self.yesFoods addObject:@"salmon"];
                [self.yesFoods addObject:@"mackerel"];
            }
        }
        if ([self.medicalArray[j] isEqualToString:CELIAC_DISEASE]){
            BOOL found = NO;
            for (int i=0; i<self.allergiesArray.count; i++){
                if ([self.allergiesArray[i] isEqualToString:GLUTEN]){
                    found = YES;
                }
            }
            if (!found){
                [self.noFoods addObject:GLUTEN];
            }
        }
    }
}

@end
