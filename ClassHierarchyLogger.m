//
//  ClassHierarchyLogger.m
//
//  Created by Sebastian Venditti on 9/3/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "ClassHierarchyLogger.h"
#import "objc/runtime.h"


/// Used internally to store the list of classes in the runtime.
static Class *classes;

/// Used internally to store the number of classes in the runtime (array length).
static int numClasses;


@implementation ClassHierarchyLogger


#pragma mark - Public methods


+ (void)printHierarchyOfClass:(Class)class
               formatterBlock:(NSString * (^)(ClassRepresentation *classRepresentation))formatterBlock
            indentationString:(NSString *)indentationString
{
    // Fetch the list of classes from the runtime.
    // @see http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html
    numClasses = objc_getClassList(NULL, 0);
    classes = NULL;
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    // Create a representation of the specified class (and subclasses, recursively).
    ClassRepresentation *classRepresentation = [ClassHierarchyLogger representationOfClass:class];

    // Recursively print the representation of the specified class and all of
    // it descendants.
    [ClassHierarchyLogger recursivelyPrintClassRepresentation:classRepresentation
                                               formatterBlock:formatterBlock
                                            indentationString:indentationString
                                             indentationLevel:0];

    // Free the memory allocated previously.
    free(classes);
}


#pragma mark - Private methods


/**
 * Recursively prints a ClassRepresentation object and all of its nested 
 * subclassesRepresentations.
 *
 * @param classRepresentation the representation of the class whose hierarchy 
 *        needs to be printed.
 *
 * @param formatterBlock a block used to create a descriptive string from a
 *        ClassRepresentation.
 *
 * @param indentationString a string used to indent the description of a class
 *        depending on its depth level in the hierarchy.
 *
 * @param indentationLevel the level of indentation that should be used when
 *        printing the current class.
 */
+ (void)recursivelyPrintClassRepresentation:(ClassRepresentation *)classRepresentation
                             formatterBlock:(NSString * (^)(ClassRepresentation *classRepresentation))formatterBlock
                          indentationString:(NSString *)indentationString
                           indentationLevel:(int)indentationLevel
{
    NSString *currentClassRepresentation = @"";

    // Add the indentation
    for (int i=0; i<indentationLevel; i++) {
        currentClassRepresentation = [indentationString stringByAppendingString:currentClassRepresentation];
    }

    // Add the current class representation
    currentClassRepresentation = [currentClassRepresentation stringByAppendingString:formatterBlock(classRepresentation)];

    // Log it to the console
    NSLog(@"%@", currentClassRepresentation);

    // Cycle through the nested subclasses
    for (ClassRepresentation *subclassRepresentation in classRepresentation.subclassesRepresentations) {
        [self recursivelyPrintClassRepresentation:subclassRepresentation
                                   formatterBlock:formatterBlock
                                indentationString:indentationString
                                 indentationLevel:indentationLevel + 1];
    }
}


/**
 * Returns a ClassRepresentation object created using the specified class.
 */
+ (ClassRepresentation *)representationOfClass:(Class)class
{
    ClassRepresentation *classRepresentation = [[ClassRepresentation alloc] init];

    classRepresentation.name = NSStringFromClass(class);

    // Add the representation of the subclasses
    NSMutableArray *subclassesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = class_getSuperclass(classes[i]);
        if (superClass == class) {
            [subclassesArray addObject:[self representationOfClass:classes[i]]];
        }
    }
    classRepresentation.subclassesRepresentations = subclassesArray;

    return classRepresentation;
}


@end


#pragma mark - ClassRepresentation Implementation


/// No implementation needed, since this is just a DTO
@implementation ClassRepresentation

@end

