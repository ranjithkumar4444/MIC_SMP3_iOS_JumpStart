//
//  BSUtils.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSUtils.h"

static NSArray *colors;
static NSDictionary *categoryIcons;
static NSDictionary *materialImageNames;

@implementation BSUtils

+ (UIColor *) colorForIndex: (NSUInteger) index {
    return colors[index % [colors count]];
}

+ (UIImage *) iconForGroup: (NSString *) groupID {
    return [categoryIcons objectForKey: groupID];
}

+ (UIImage *) imageForMaterial: (NSString *) matID {
    NSString *imgName = [materialImageNames valueForKey: matID];
    if (imgName) {
        return [UIImage imageNamed: imgName];
    } else {
        return nil;
    }
}




+ (void) initialize {
    NSArray *colorInts = @[ @0x189cd8, @0x027cc1, @0x144788,
                            @0xed8922, @0xe76a24, @0xc74527,
                            @0xbacd32, @0x78b443, @0x1b8241  ];

    NSMutableArray *mutColors = [NSMutableArray arrayWithCapacity: [colorInts count]];
    for (NSNumber *num in colorInts) {
        NSInteger hexColor = [num intValue];
        [mutColors addObject: [UIColor colorWithRed: (CGFloat)((hexColor & 0xFF0000) >> 16) / 255.0f
                                              green: (CGFloat)((hexColor & 0x00FF00) >> 8) / 255.0f
                                               blue: (CGFloat)(hexColor & 0x0000FF) / 255.0f
                                              alpha: 1.0f]];
    }
    colors = [NSArray arrayWithArray: mutColors];

    categoryIcons = @{
                      // These icons match their category names
                      // Washing machines
                      @"MIC005" : [UIImage imageNamed: @"ico_common_small_category_1"],
                      // Wrenches
                      @"MIC002" : [UIImage imageNamed: @"ico_common_small_category_2"],
                      // Hammers
                      @"MIC009" : [UIImage imageNamed: @"ico_common_small_category_3"],
                      // Pliers
                      @"MIC001" : [UIImage imageNamed: @"ico_common_small_category_4"],
                      // Vacuum cleaners
                      @"MIC010" : [UIImage imageNamed: @"ico_common_small_category_5"],
                      // Screwdrivers
                      @"MIC007" : [UIImage imageNamed: @"ico_common_small_category_9"],

                      // These don't match, but we have all these extra icons, so we might as well use them...
                      // Category = Ratchet sets, icon = toolbox
                      @"MIC006" : [UIImage imageNamed: @"ico_common_small_category_6"],
                      // Category = Drills, icon = screw
                      @"MIC003" : [UIImage imageNamed: @"ico_common_small_category_7"],
                      // Category = Sanders, icon = oven
                      @"MIC004" : [UIImage imageNamed: @"ico_common_small_category_8"],
                      // Category = Cutting tools, icon = coffeemaker
                      @"MIC008" : [UIImage imageNamed: @"ico_common_small_category_10"]
                      };

    materialImageNames = @{
                       @"MIC-001" : @"mat001.jpg",
                       @"MIC-002" : @"mat002.jpg",
                       @"MIC-003" : @"mat003.jpg",
                       @"MIC-004" : @"mat004.jpg",
                       @"MIC-005" : @"mat005.jpg",
                       @"MIC-006" : @"mat006.jpg",
                       @"MIC-007" : @"mat007.jpg",
                       @"MIC-008" : @"mat008.jpg",
                       @"MIC-009" : @"mat009.jpg",
                       @"MIC-010" : @"mat010.jpg",
                       @"MIC-011" : @"mat011.jpg",
                       @"MIC-012" : @"mat012.jpg",
                       @"MIC-013" : @"mat013.jpg",
                       @"MIC-014" : @"mat014.jpg",
                       @"MIC-015" : @"mat015.jpg",
                       @"MIC-016" : @"mat016.jpg",
                       @"MIC-017" : @"mat017.jpg",
                       @"MIC-018" : @"mat018.jpg",
                       @"MIC-019" : @"mat019.jpg",
                       @"MIC-020" : @"mat020.jpg",
                       @"MIC-021" : @"mat021.jpg",
                       @"MIC-022" : @"mat022.jpg",
                       @"MIC-023" : @"mat023.jpg",
                       @"MIC-024" : @"mat024.jpg",
                       @"MIC-025" : @"mat025.jpg",
                       @"MIC-026" : @"mat026.jpg",
                       @"MIC-027" : @"mat027.jpg",
                       @"MIC-028" : @"mat028.jpg",
                       @"MIC-029" : @"mat029.jpg",
                       @"MIC-030" : @"mat030.jpg",
                       @"MIC-031" : @"mat031.jpg",
                       @"MIC-032" : @"mat032.jpg",
                       @"MIC-033" : @"mat033.jpg",
                       @"MIC-034" : @"mat034.jpg",
                       @"MIC-035" : @"mat035.jpg",
                       @"MIC-036" : @"mat036.jpg",
                       @"MIC-037" : @"mat037.jpg",
                       @"MIC-038" : @"mat038.jpg",
                       @"MIC-039" : @"mat039.jpg",
                       @"MIC-040" : @"mat040.jpg",
                       @"MIC-041" : @"mat041.jpg",
                       @"MIC-042" : @"mat042.jpg",
                       @"MIC-043" : @"mat043.jpg",
                       @"MIC-044" : @"mat044.jpg",
                       @"MIC-045" : @"mat045.jpg",
                       @"MIC-046" : @"mat046.jpg",
                       @"MIC-047" : @"mat047.jpg",
                       };
}

+(void)addCellShadow:(UICollectionViewCell *)cell
{
    cell.layer.masksToBounds = NO;
    //cell.layer.borderColor = [UIColor whiteColor].CGColor;
    //cell.layer.borderWidth = 7.0f;
    //cell.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.layer.shadowOpacity = 0.50f;
    cell.layer.shadowRadius = 3.0f;
    cell.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    //cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    //cell.layer.shouldRasterize = YES;
}
@end
