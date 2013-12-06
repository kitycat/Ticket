//
//  TZoneView.m
//  TMarket
//
//  Created by ZhangAo on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TZoneView.h"

@interface TZoneView ()
-(void)showTags;
-(BOOL)rectIntersects:(CGRect)theRect;
-(void)tagPressed:(id)sender;
-(UIButton *)addTagWithTitle:(NSString *)title andFontSize:(float)fontSize WithX:(float)x AndY:(float)y AndTag:(NSInteger)tag;
@end

@implementation TZoneView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        tagsArray = [[NSMutableArray alloc] init];
        colorList = [[NSArray alloc]initWithObjects:
                              @"blackColor", 
                              @"grayColor",
                              @"darkGrayColor",
                              @"lightGrayColor",
                              @"redColor",
                              @"greenColor",
                              @"blueColor",
                              @"tableCellBlueTextColor",
                              @"cyanColor",
                              @"magentaColor",
                              @"purpleColor",
                              @"brownColor",
                              @"tableSeparatorDarkColor",
                              @"tableSelectionColor",
                              @"orangeColor",
                              @"darkTextColor",
                              @"pinStripeColor",
                              @"textFieldAtomPurpleColor",nil];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [NSThread detachNewThreadSelector:@selector(showTags)
                             toTarget:self
                           withObject:nil];
}

-(void)showTags{
    @autoreleasepool {
        scrollYConstraint = CGRectGetHeight(self.bounds);
        scrollLastUsed = 0;
        
        int tag = 1;
        //max width to go down with the button (portrait iphone screen)
        int xConstraint = CGRectGetWidth(self.bounds) - 20;
        int yConstraint = 0;
        
        count = [delegate zoneViewNumberOfTexts];
        
        NSMutableArray *centerArray = [[NSMutableArray alloc] initWithCapacity:count];
        CGPoint center = CGPointMake(self.center.x, self.center.y - 44);
        
        for(int i = 0; i < count; i++) {
            NSString *theTitle = [delegate zoneViewTextForIndex:i];
            if (tag > scrollLastUsed) {
                float x = 10.0f, y = 10.0f;
                
                //between xx and xx
                float fontSize = (arc4random() % 10) + 14;
                
                for (UIButton *btn in tagsArray) {					
                    CGSize theSize = [theTitle sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:CGSizeMake(9999.0f, 9999.0f) lineBreakMode:UILineBreakModeWordWrap];
                    
                    //not too wide?
                    while (theSize.width > xConstraint) {
                        fontSize -= 1;
                        theSize = [theTitle sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:CGSizeMake(9999.0f, 9999.0f) lineBreakMode:UILineBreakModeWordWrap];
                    }
                    
                    CGRect compareRect = CGRectMake(x, y, theSize.width + 10, theSize.height);
                    while ([self rectIntersects:compareRect]) {
                        if((theSize.width + x +5) < xConstraint) x += 15;
                        else {
                            x = 10;
                            y += 12;
                        }
                        compareRect = CGRectMake(x, y, theSize.width, theSize.height);
                    }
                }
                
                UIButton *button = [self addTagWithTitle:theTitle andFontSize:fontSize WithX:x AndY:y AndTag:tag];
                [centerArray addObject:NSStringFromCGPoint(button.center)];
                [self addSubview:button];
                
                //get the button height and add it to the constraint
                int btnHeight = (int)[self viewWithTag:tag].frame.size.height;
                if ((y + btnHeight) > yConstraint) yConstraint = (y + btnHeight);		
            }		
            //stop if we reached the wanted constraint
            if(yConstraint > scrollYConstraint) break;
            
            //otherwise, next tag
            tag++;		
        }
        
        //remember the last used tag
        scrollLastUsed = tag;
        
        for (UIView *view in tagsArray) {
            view.center = center;
        }
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             for (int i = 0; i < tagsArray.count; i++) {
                                 UIView *view = [self.subviews objectAtIndex:i];
                                 view.center = CGPointFromString([centerArray objectAtIndex:i]);
                             }
                         }];
        [centerArray release];
    }
}

- (void)dealloc {
    [tagsArray release];
    [colorList release];
    
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIButton *)addTagWithTitle:(NSString *)title andFontSize:(float)fontSize WithX:(float)x AndY:(float)y AndTag:(NSInteger)tag {
	
	UIButton *theBtn = [UIButton buttonWithType:UIButtonTypeCustom];

	CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] 
                       constrainedToSize:CGSizeMake(9999.0f, 9999.0f) 
                           lineBreakMode:UILineBreakModeWordWrap];
    
	theBtn.frame = CGRectMake(x, y, titleSize.width, titleSize.height);

	[tagsArray addObject:theBtn];
	
	[theBtn setTitle:title forState:UIControlStateNormal];
	
    int colorIndex = (arc4random() % colorList.count);
    SEL colorSelector = NSSelectorFromString([colorList objectAtIndex:colorIndex]);
	UIColor *titleColor = [UIColor performSelector:colorSelector];
	
	[theBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [theBtn setBackgroundColor:[UIColor clearColor]];
	theBtn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
	theBtn.tag = tag;
    
	
	[theBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	CGRect frame = theBtn.frame;
	frame.size.width += 10; //l + r padding 
	theBtn.frame = frame;
	
	// add action
	[theBtn addTarget:self action:@selector(tagPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return theBtn;
}

-(BOOL)rectIntersects:(CGRect)theRect {
	int t = 0;
	for (UIButton *btn in tagsArray) {					
		t++;
		if (t >= (scrollLastUsed - 10)) {
			CGRect testRect = CGRectIntersection(btn.frame, theRect);
			if (!CGRectIsNull(testRect)) return TRUE;
		}
	}
	return FALSE;
}

-(void)tagPressed:(id)sender{
    [delegate zoneViewSelectedFor:((UIView *)sender).tag - 1];
}

@end
