//
//  AVQueuePlayerView.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 2/9/17.
//  Copyright © 2017 Alexander Iashchuk. All rights reserved.
//

import UIKit

class AVQueuePlayerView: AVQueuePlayer {
    if let <#constant name#> = <#optional#> {
        <#statements#>
    }
}
guard <#condition#> else {
    <#statements#>
}enum <#name#> {
    case <#case#>
}var <#variable name#>: <#type#> {
get {
    <#statements#>
}
set {
    <#variable name#> = newValue
}
}@try {
    <#Code that can potentially throw an exception#>
} @catch (NSException *exception) {
    <#Handle an exception thrown in the @try block#>
} @finally {
    <#Code that gets executed whether or not an exception is thrown#>
    }- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == <#context#>) {
        <#code to be executed upon observing keypath#>
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        <#statements#>
    }
    return self;
}
