//
//  DnsCtrl.m
//  DNS
//
//  Created by WENTAO XING on 2018/11/29.
//  Copyright © 2018 WENTAO XING. All rights reserved.
//

#import "DnsCtrl.h"
#import <stdlib.h>
#import "./ColorQuantizer.h"

@interface DnsCtrl ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong) UITextField * domainInput;
@property(nonatomic, strong) UIButton * searchBtn;
@property(nonatomic, strong) UILabel * recvText;
@property(nonatomic, strong) UIButton * imageBtn;
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic) unsigned char * rawData;
@end

@implementation DnsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.domainInput = [[UITextField alloc] init];
    self.searchBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.recvText = [[UILabel alloc] init];
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    
    UIImage * girl = [UIImage imageNamed: @"girl2.jpg"];
    self.imageView.image = girl;
    
    self.recvText.font = [UIFont systemFontOfSize:20];
    self.recvText.text = @"hahah";
    self.recvText.textColor = [UIColor redColor];
    
    
    
    
    
    
    
    [self.searchBtn setTitle:@"search" forState:(UIControlStateNormal)];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.searchBtn setBackgroundColor:[UIColor blueColor]];
    
    [self.imageBtn setTitle:@"Choose" forState:(UIControlStateNormal)];
    [self.imageBtn setBackgroundColor:[UIColor redColor]];
    [self.imageBtn addTarget:self action:@selector(getThemeColor) forControlEvents:(UIControlEventTouchDown)];
    
    [self.view addSubview: self.domainInput];
    [self.view addSubview: self.searchBtn];
    [self.view addSubview: self.recvText];
    [self.view addSubview: self.imageBtn];
    [self.view addSubview: self.imageView];
    
    self.searchBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.domainInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.domainInput.borderStyle = UITextBorderStyleRoundedRect;
    self.recvText.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.searchBtn.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.searchBtn.heightAnchor constraintEqualToConstant:50].active = YES;;
    [self.searchBtn.topAnchor constraintEqualToAnchor:self.domainInput.bottomAnchor constant:50].active = YES;
    
    [self.searchBtn addTarget:self action:@selector(search) forControlEvents:(UIControlEventTouchDown)];
    
    [self.recvText.topAnchor constraintEqualToAnchor: self.searchBtn.bottomAnchor constant:50].active = YES;
    
    [self.recvText.centerXAnchor constraintEqualToAnchor: self.searchBtn.centerXAnchor].active = YES;
    
    [self.imageBtn.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.imageBtn.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.imageBtn.leadingAnchor constraintEqualToAnchor:self.searchBtn.leadingAnchor].active = YES;
    [self.imageBtn.topAnchor constraintEqualToAnchor:self.searchBtn.bottomAnchor].active = YES;
    
    
    [self.domainInput.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 100].active = YES;
    
    [self.domainInput.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    
    [self.domainInput.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20].active = YES;
    
    [self.domainInput.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.domainInput.centerXAnchor constraintEqualToAnchor:self.searchBtn.centerXAnchor].active = YES;
    
    [self getImageData];
    
    
    
    // Do any additional setup after loading the view.
}

-(void) search {
    /*
    NSString * text = self.domainInput.text;
    DnsSearch s;
    char * str = s.search([text UTF8String]);
    NSString * recvMsg = [NSString stringWithCString:str encoding:(NSUTF8StringEncoding)];
    NSLog(@"recvMsg: %@", recvMsg);
    self.recvText.text = recvMsg;
    self.recvText.text = [NSString stringWithCString:str encoding:(NSUTF8StringEncoding)];
     */
}

-(void) chooseFile {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    NSLog(@"picker: %@", info);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getImageData
{
    CGImageRef imageRef = [self.imageView.image CGImage];
    NSUInteger width = 100;
    NSUInteger height = 100;
    
    NSLog(@"width: %lu, height: %lu", width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    self.rawData = (unsigned char *) calloc(width * height * 4, sizeof(unsigned char));
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(self.rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    self.imageView.image = [UIImage imageNamed: @"girl2.jpg"];
    
//    ColorNode * node = getColor(root);
    /*
    NSLog(@"r = %d, g = %d, b = %d, pixelCount = %llu", node->r, node->g, node->b, node->pixelCount);
     */
    self.view.backgroundColor = [UIColor greenColor];
    
    
//    self.imageView.image = [UIImage imageNamed: @"girl2.jpg"];
    
    /* back to image*/
    /*
    size_t bufferLength = width * height * 4;
    CGDataProviderRef prodiver = CGDataProviderCreateWithData(NULL, rawData, bufferLength, NULL);
    
    CGImageRef iref = CGImageCreate(width, height, bitsPerComponent, bytesPerPixel * 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big, prodiver, NULL, YES, kCGRenderingIntentDefault);
    
    self.imageView.image = [UIImage imageWithCGImage: iref];
    */
    /*
    uint8_t * theme = getImageThemeColor(self.rawData, width * height * 4, 8);
    
    NSLog(@"r = %d, g = %d, b = %d", theme[0], theme[1], theme[2]);
    
    
    self.view.backgroundColor = [UIColor colorWithRed:theme[0]/255.0 green:theme[1]/255.0 blue:theme[2]/255.0 alpha:1];
     */
    
    
    
    
}

-(void) getThemeColor
{
//    test();
    /*
    uint8_t * theme = getImageThemeColor(self.rawData, 100 * 100 * 4, 8);
    NSLog(@"r = %d, g = %d, b = %d", theme[0], theme[1], theme[2]);
    self.view.backgroundColor = [UIColor colorWithRed:theme[0]/255.0 green:theme[1]/255.0 blue:theme[2]/255.0 alpha:1];
    free(theme);
     */
    
    QuantizedColor * p = getQuantizedColor(self.rawData, 100 * 100 * 4, 8);
    NSLog(@"count: %d", p->count);
    for (int i = 0; i < p->count; i++) {
        ColorRGB * c = p->colors[i];
        NSLog(@"r=%d, g=%d, b=%d, count=%llu", c->r, c->g, c->b, c->pixelCount);
    }
    freeQuantizedColor(p);
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
