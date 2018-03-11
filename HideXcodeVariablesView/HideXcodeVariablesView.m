#import <objc/runtime.h>
#import <objc/message.h>
#import "HideXcodeVariablesView.h"

void (*objc_msgSendTyped)(id self, SEL _cmd, int foo) = (void*)objc_msgSend;

@implementation HideXcodeVariablesView

+ (void)load {
    NSLog(@"HideXcodeVariablesView: Loading!");

    SEL replacementSelector = NSSelectorFromString(@"replacement_loadView");
    Class class = objc_getClass("IDESplitViewDebugArea");
    IMP replacementLoadViewIMP = imp_implementationWithBlock(^(id this){
        NSLog(@"HideXcodeVariablesView: defaulting to hiding variables view!");
        [this performSelector:replacementSelector];
        objc_msgSendTyped(this, NSSelectorFromString(@"setPreferredLayoutMode:"), 2);
    });

    Method originalLoadView = class_getInstanceMethod(class, NSSelectorFromString(@"loadView"));
    const char *encoding = method_getTypeEncoding(originalLoadView);
    BOOL added = class_addMethod(class, replacementSelector, replacementLoadViewIMP, encoding);
    if (!added) {
        NSLog(@"HideXcodeVariablesView: Failed to add method :(");
        return;
    }

    Method replacementLoadView = class_getInstanceMethod(class, replacementSelector);
    method_exchangeImplementations(originalLoadView, replacementLoadView);
    NSLog(@"HideXcodeVariablesView: Done!");
}

@end
