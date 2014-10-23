# Class Hierarchy Logger

Helper to log the complete hierarchy of a class in Objective-C.


## What can I do with this? What led you to implement it?

One of my apps uses several APIs, resulting in a complex hierarchy. I needed to migrate all the requests from one endpoint to a newer one, and this helper saved me a lot of time determining what to change. It might also be helpful to understand your UIView or UIViewController class hierarchy.


## How to use

1. Copy the the .h and .m files to your project.
2. `#import "ClassHierarchyLogger.h"` where you want to use it.
3. Use the ClassHierarchyLogger's `printHierarchyOfClass:formatterBlock:indentationString:` method.

### Example 1: Indented list

It's sometimes useful to have an indented view of the hierarchy, so...

#### This code:

```smalltalk
    [ClassHierarchyLogger printHierarchyOfClass:[UIViewController class]
                                 formatterBlock:^NSString *(ClassRepresentation *classRepresentation) {
                                     return [NSString stringWithFormat:@"* %@", classRepresentation.name];
                                 }
                              indentationString:@"    "];
```

#### Produces this output:

    * MyBaseViewController
        * MyCustomAViewController
            * MyCustomA1ViewController
            * MyCustomA2ViewController
                * MyCustomA2AViewController
            * MyCustomA3ViewController
                * MyCustomA3AViewController
                    * MyCustomA3A1ViewController
                * MyCustomA3BViewController
        * MyBaseScreenViewController
            * MyScreen1MasterViewController
            * MyScreen1DetailViewController
                * MyScreen1iPadDetailViewController
            * MyScreen2DetailViewController
                * MyScreen2iPhoneDetailViewController
                * MyScreen2iPadDetailViewController

### Example 2: Detailed grid

If you would prefer to print several attributes of your class on each line, separated by tabs, in order to paste them into a spreadsheet, try something like this (replacing `MyBaseAPIConnector` with your class name):

#### This code:

```smalltalk
    // Print the header line
	NSLog(@"Class\tBase URL\tRelative Path\tMethod");
	// Print the list
    [ClassHierarchyLogger printHierarchyOfClass:[MyBaseAPIConnector class]
                                 formatterBlock:^NSString *(ClassRepresentation *classRepresentation) {
                                     NSString *result = @"";
                                     result = [NSString stringWithFormat:@"%@\t%@", result, classRepresentation.name];
                                     MyBaseAPIConnector* instance = [[NSClassFromString(classRepresentation.name) alloc] init];
                                     result = [NSString stringWithFormat:@"%@\t%@", result, [instance baseUrl]];
                                     result = [NSString stringWithFormat:@"%@\t%@", result, [instance relativePath]];
                                     result = [NSString stringWithFormat:@"%@\t%@", result, [instance method]];
                                     return result;
                                 }
                              indentationString:@""];
```

#### Produces this output:

    Class	Base URL	Relative Path	Method
    MyBaseConnector	api.mysite.com	/	GET
    ListUsersConnector	api.mysite.com	/users	GET
    GetUserConnector	api.mysite.com	/user/{id}	GET
    CreateUserConnector	api.mysite.com	/users	POST
    DeleteUserConnector	api.mysite.com	/user/{id}	DELETE
    UpdateUserConnector	api.mysite.com	/user/{id}	PUT
    .
    .
    .

This output can then be copied and pasted into a spreadsheet for further processing...

Have fun!
