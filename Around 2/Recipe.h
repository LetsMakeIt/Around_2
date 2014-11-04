//
//  Recipe.h
//  RecipeBook
//
//  Created by Simon on 12/8/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Recipe : NSObject

@property (nonatomic, strong) NSString *text; // name of recipe
@property (nonatomic, strong) NSString *prepTime; // preparation time
@property (nonatomic, strong) PFFile *imageFile; // image of recipe
@property (nonatomic, strong) NSString *urlad; // url adress

@end
