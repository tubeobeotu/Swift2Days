//
//  ERHTMLtoPDF.h
//  DyonicsV2
//
//  Created by Trung on 7/7/14.
//  © 2010-2015 Smith & Nephew Inc - All Rights Reserved
//

#import <UIKit/UIKit.h>
#define kPaperSizeA4 CGSizeMake(595.2,841.8)
#define kPaperSizeLetter CGSizeMake(612,792)
#define kPaperSizeMinimum CGSizeMake(595.2,792)
@class ERHTMLtoPDF;

typedef void (^ERHTMLtoPDFCompletionBlock)(NSString *path);



@interface ERHTMLtoPDF : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) ERHTMLtoPDFCompletionBlock successBlock;
@property (nonatomic, copy) ERHTMLtoPDFCompletionBlock failBlock;

@property (nonatomic, strong) NSString *pdfPath;
@property (nonatomic, strong) NSData *pdfData;

+(id) createPDFWithHTML:(NSString *)htmlString baseURL:(NSURL *)url pathForPDF:(NSString *)pdfPath pageSize:(CGSize) pageSize OnSuccessBlock:(ERHTMLtoPDFCompletionBlock)successBlock OnFailBlock:(ERHTMLtoPDFCompletionBlock)failBlock;
+(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
@end








