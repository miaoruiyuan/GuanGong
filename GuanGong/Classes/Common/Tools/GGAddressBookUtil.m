//
//  GGAddressBookUtil.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/28.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAddressBookUtil.h"
#import <AddressBook/AddressBook.h>
#import "GGAddressBook.h"
#import "GGDataBaseManager.h"

@implementation GGAddressBookUtil

+ (void)loadPhoneContactsToDB
{
    GGAddressBookUtil *util = [[GGAddressBookUtil alloc] init];
    [util loadPersonData];
}

#pragma mark - 取得通讯录数据

- (void)loadPersonData
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if (granted){
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                                   message:@"您没有授权通讯录访问,请到设置里打开"
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil
                                                   handler:nil];
                });
            }
        });
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    // 4.从通信录对象中,将所有的联系人拷贝出来
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    if (!peopleArray) {
        return;
    }
    // 5.遍历所有的联系人(每一个联系人都是一条记录)
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:peopleCount];
    
    @autoreleasepool {
        for (CFIndex i = 0; i < peopleCount; i++) {
            
            // 6.获取到联系人
            ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
            
            // 7.获取姓名
            CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef lastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef fullName = ABRecordCopyCompositeName(person);
            
            NSString *nameString = (__bridge NSString *)(firstName);
            NSString *lastNameString = (__bridge NSString *)(lastname);
            
            if ((__bridge id)fullName != nil) {
                nameString = (__bridge NSString *)fullName;
            } else {
                if ((__bridge id)lastname != nil){
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            
            GGAddressBook *aBook = [[GGAddressBook alloc]init];
            aBook.lastname = lastNameString;
            aBook.fullname = nameString;
            
            ABPropertyID multiProperties[] = {
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
            for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                ABPropertyID property = multiProperties[j];
                ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
                NSInteger valuesCount = 0;
                if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                
                if (valuesCount == 0) {
                    CFRelease(valuesRef);
                    continue;
                }
                //获取电话号码和email
                for (NSInteger k = 0; k < valuesCount; k++) {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                    switch (j) {
                        case 0: {// Phone number
                            aBook.mobile = (__bridge NSString*)value;
                            break;
                        }
                        case 1: {// Email
                            aBook.email = (__bridge NSString*)value;
                            break;
                        }
                    }
                    CFRelease(value);
                }
                CFRelease(valuesRef);
            }
            if (aBook.mobile) {
                NSString *telPhone = [aBook.mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
                telPhone = [telPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
                telPhone = [telPhone stringByReplacingOccurrencesOfString:@" (" withString:@""];
                telPhone = [telPhone stringByReplacingOccurrencesOfString:@") " withString:@""];
                aBook.mobile = telPhone;
                [resultArray addObject:[aBook modelToJSONObject]];
            }
        }
    }
    
    [[GGDataBaseManager shareDB] putAddressBookListWithData:resultArray];
    // 8.释放不再使用的对象
    CFRelease(peopleArray);
    CFRelease(addressBook);
}

@end
