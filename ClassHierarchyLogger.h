//
//  ClassHierarchyLogger.h
//
//  Created by Sebastian Venditti on 9/3/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassRepresentation; // See below

/**
 * Helper that provides functionality to print the hierarchy of a class.
 */
@interface ClassHierarchyLogger : NSObject

/**
 * Prints the hierarchy of the specified class.
 *
 * @param class the class whose hierarchy needs to be printed.
 *
 * @param formatterBlock a block used to create a descriptive string from a
 *        ClassRepresentation.
 *
 * @param indentationString a string used to indent the description of a class
 *        depending on its depth level in the hierarchy.
 */
+ (void)printHierarchyOfClass:(Class)class
               formatterBlock:(NSString * (^)(ClassRepresentation *classRepresentation))formatterBlock
            indentationString:(NSString *)indentationString;

@end


/**
 * Object used to represent a class in the hierarchy. Contains a name and an
 * array of subclasses.
 *
 * It's a inner class used as a DTO.
 */
@interface ClassRepresentation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *subclassesRepresentations; // Contains ClassRepresentation*

@end

