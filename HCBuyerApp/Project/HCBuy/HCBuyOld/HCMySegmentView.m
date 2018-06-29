//
//  HCMySegmentView.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCMySegmentView.h"
#define kButtonTagStart 100

#define SEG_FONT [self getFont]


@implementation HCMySegmentView
{
    UIView *lineView;
    
    int select;
}

@synthesize selectedIndex,clickDelegate,currentBtn,curentTag,buttonArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(CGFloat)getFont
{
    if (iPhone5||iPhone4s) {
        return 16;
    }else{
        return 18;
    }
}

-(id)initWithFrame:(CGRect)frame andItems:(NSMutableArray*)titleArray
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        selectedIndex = 0;
        int width = (HCSCREEN_WIDTH-60)/8;
        buttonArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < titleArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:SEG_FONT];
            [button setTitleColor:UIColorFromRGBValue(0x212121) forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
                 button.titleLabel.font = [UIFont systemFontOfSize:SEG_FONT];
            }
            
        
            NSString *title = [titleArray HCObjectAtIndex:i];
            
            [button setTitle:title forState:UIControlStateNormal];
            button.tag = kButtonTagStart+i;
            CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:SEG_FONT],NSFontAttributeName, nil] context:nil];
            ///CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:SEG_FONT] constrainedToSize:CGSizeMake(MAXFLOAT, 35) lineBreakMode:NSLineBreakByWordWrapping];
            CGSize size = tmpRect.size;
            button.frame = CGRectMake(width, 0, size.width, 35);
            
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (titleArray.count==3) {
                if (i==1) {
                    UIImageView *hotIcon = [[UIImageView alloc]init];
                    hotIcon.image = [UIImage imageNamed:@"hoticon"];
                    hotIcon.frame = CGRectMake(button.width, 3, 13, 13);
                    [button addSubview:hotIcon];
                }
            }
            
            [buttonArray addObject:button];
            width += size.width+(HCSCREEN_WIDTH-60)/8;
        }
        self.contentSize = CGSizeMake(width, 25);
        self.width = width;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}

-(void)onClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    curentTag = btn.tag;
    
    for (UIButton *but in buttonArray) {
        
        if (but.tag==curentTag) {
            [but setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal] ;
            but.titleLabel.font = [UIFont systemFontOfSize:SEG_FONT];
        }else if (but.tag!=curentTag){
            [but setTitleColor:UIColorFromRGBValue(0x212121)forState:UIControlStateNormal];
        }
    }
    
    //  [btn setTitleColor:[UIColor colorWithRed:0.12f green:0.66f blue:0.90f alpha:1.00f]forState:UIControlStateSelected] ;
    if (selectedIndex != btn.tag - kButtonTagStart)
    {
        
        [self selectIndex:(int)(btn.tag - kButtonTagStart)];
    }}


-(void)selectIndex:(int)index
{
 
        if (selectedIndex != index)
        {
            UIButton *btn = [buttonArray HCObjectAtIndex:index];
            for (UIButton *but in buttonArray) {
                if ([but isEqual:btn]==YES) {
                    [but setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal] ;
                    but.titleLabel.font = [UIFont systemFontOfSize:SEG_FONT];
                }else{
                    [but setTitleColor:UIColorFromRGBValue(0x212121) forState:UIControlStateNormal];
                }
            }
            
            selectedIndex =  index;
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:0.2];
            CGRect lineRC  = [self viewWithTag:selectedIndex+kButtonTagStart].frame;
            lineView.frame = CGRectMake(lineRC.origin.x-2, lineRC.size.height+2 , lineRC.size.width+4, 3);
            
            [UIView commitAnimations];
            
            if (clickDelegate != nil && [clickDelegate respondsToSelector:@selector(barSelectedIndexChanged:)])
            {
                [clickDelegate barSelectedIndexChanged:selectedIndex];
                
            }
            
            if (lineRC.origin.x - self.contentOffset.x > HCSCREEN_WIDTH * 2  /5)
            {
                int index = selectedIndex;
                if (selectedIndex + 2 < buttonArray.count)
                {
                    index = selectedIndex + 2;
                }
                else if (selectedIndex + 1 < buttonArray.count)
                {
                    index = selectedIndex + 1;
                }
                CGRect rect = [self viewWithTag:index +kButtonTagStart].frame;
                CGRect rc = CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width, rect.size.height);
                
                [self scrollRectToVisible:rc animated:YES];
            }
            else if ( lineRC.origin.x - self.contentOffset.x < HCSCREEN_WIDTH / 3)
            {
                int index = selectedIndex;
                if (selectedIndex - 2 >= 0)
                {
                    index = selectedIndex - 2;
                }
                else if (selectedIndex - 1 >= 0)
                {
                    index = selectedIndex - 1;
                }
                CGRect rc = [self viewWithTag:index +kButtonTagStart].frame;
                [self scrollRectToVisible:rc animated:YES];
            }
        }

}

-(void)setLineOffsetWithPage:(float)page andRatio:(float)ratio
{
    
    [UIView animateWithDuration:0.1 animations:^{
        if (self.clickDelegate) {  //2.6版本添加的
            [self.clickDelegate UINavigationBarAndTabBarHidden];
        }
    } completion:^(BOOL finished) {
        CGRect lineRC  = [self viewWithTag:page+kButtonTagStart].frame;
        
        CGRect lineRC2  = [self viewWithTag:page+1+kButtonTagStart].frame;
        
        
        float width = lineRC2.size.width;
        if (lineRC2.size.width < lineRC.size.width)
        {
            width =  lineRC.size.width - (lineRC.size.width-lineRC2.size.width)*ratio;
            
        }
        else if(lineRC2.size.width > lineRC.size.width)
        {
            width =  lineRC.size.width + (lineRC2.size.width-lineRC.size.width)*ratio;
        }
        float x = lineRC.origin.x + (lineRC2.origin.x - lineRC.origin.x)*ratio;
        
        //lineView.frame = CGRectMake(lineRC.origin.x-2, lineRC.size.height+2 , lineRC.size.width+4, 3);
        lineView.frame = CGRectMake(x-2,  lineRC.size.height+2,width+4,   3);
        
        [self scrollRectToVisible:lineRC2 animated:YES];
    }];
 
    
    
  
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
