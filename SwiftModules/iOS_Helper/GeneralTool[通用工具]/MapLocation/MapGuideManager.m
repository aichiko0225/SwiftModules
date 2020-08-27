//
//  MapGuideManager.m
//  DFVehicleSteward
//
//  Created by 王立 on 2018/4/27.
//  Copyright © 2018年 ssi. All rights reserved.
//

#import "MapGuideManager.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ApplicationManager.h"

@implementation MapGuideManager

+ (void)startMapGuide:(double)lat lon:(double)lon
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];

        MKPlacemark *place;
        if (@available(iOS 10.0, *)) {
            place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)];
        } else {
            place = [[MKPlacemark alloc] init];
            place.coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        
        MKMapItem *targetLocation = [[MKMapItem alloc] initWithPlacemark:place];
        [MKMapItem openMapsWithItems:@[currentLocation,targetLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *schemeArr = [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
        NSString *schemeStr = @"";
        if ([schemeArr count] > 0){
            schemeStr = schemeArr[0][@"CFBundleURLSchemes"][0];
        }else{
            schemeStr = @"";
        }
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",[ApplicationManager displayName],schemeStr,lat, lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",lat, lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action1];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alertVC addAction:action2];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertVC addAction:action3];
    }
    [alertVC addAction:action_cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:true completion:nil];
}

@end
