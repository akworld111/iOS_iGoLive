//
//  IGUtils.m
//  iphoneLive
//
//  Created by AK on 16/8/3.
//  Copyright © 2016 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IGUtils.h"


@implementation IGUtils

+(void)quickSort1:(NSMutableArray *)userlist
{
    for (int i = 0; i<userlist.count; i++)
    {
        for (int j=i+1; j<[userlist count]; j++)
        {
            int aac = [[[userlist objectAtIndex:i] valueForKey:@"level"] intValue];
            //                NSLog(@"a = %d",a);
            int bbc = [[[userlist objectAtIndex:j] valueForKey:@"level"] intValue];
            
            NSDictionary *da = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:i]];
            NSDictionary *db = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:j]];
            
            //                NSLog(@"b = %d",b);
            //                NSLog(@"------");
            if (aac >= bbc)
            {
                [userlist replaceObjectAtIndex:i withObject:da];
                [userlist replaceObjectAtIndex:j withObject:db];
            }else{
                [userlist replaceObjectAtIndex:j withObject:da];
                [userlist replaceObjectAtIndex:i withObject:db];
                
                
            }
            
        }
        
    }
    
    
}


//快速排序（两端交替着向中间扫描）
void quickSort1(int *a,int low,int high)
{
    int pivotkey=a[low];//以a[low]为枢纽值
    int i=low,j=high;
    if(low>=high)
        return;
    //一趟快速排序
    while(i<j){//双向扫描
        while(i < j && a[j] >= pivotkey)
            j--;
        a[i]=a[j];
        while(i < j && a[i] <= pivotkey)
            i++;
        a[j]=a[i];
    }
    
    a[i]=pivotkey;//放置枢纽值
    //分别对左边、右边排序
    quickSort1(a,low,i-1);
    quickSort1(a,i+1,high);
}

//快速排序（以最后一个记录的值为枢纽值，单向扫描数组）
void quickSort2(int *a,int low,int high)
{
    int pivotkey=a[high];//以a[high]为枢纽值
    int i=low-1,temp,j;
    if(low>=high)
        return;
    //一趟快速排序
    for(j=low;j<high;j++){
        if(a[j]<=pivotkey){
            i++;
            temp=a[i];
            a[i]=a[j];
            a[j]=temp;
        }
    }
    i++;
    //放置枢纽值
    temp=a[i];
    a[i]=pivotkey;
    a[high]=temp;
    //分别对左边、右边排序
    quickSort2(a,low,i-1);
    quickSort2(a,i+1,high);
}


@end

