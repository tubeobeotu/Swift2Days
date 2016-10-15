//
//  ERHTMLtoPDF.m
//  DyonicsV2
//
//  Created by Trung on 7/7/14.
//  © 2010-2015 Smith & Nephew Inc - All Rights Reserved
//

#import "ERHTMLtoPDF.h"

@interface UIPrintPageRenderer (PDF)

- (NSData *) printToPDF;

@end


@interface ERHTMLtoPDF ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGSize pageSize;


@end

@implementation ERHTMLtoPDF

+(id) createPDFWithHTML:(NSString *)htmlString baseURL:(NSURL *)url pathForPDF:(NSString *)pdfPath pageSize:(CGSize) pageSize OnSuccessBlock:(ERHTMLtoPDFCompletionBlock)successBlock OnFailBlock:(ERHTMLtoPDFCompletionBlock)failBlock {
    ERHTMLtoPDF *creator = [[ERHTMLtoPDF alloc] initWithHTML:htmlString baseURL:url pathForPDF:pdfPath pageSize:pageSize];
    creator.successBlock = successBlock;
    creator.failBlock = failBlock;
    
    return creator;
}
+(void)createPDFfromUIView:(UIWebView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    if (aView.isLoading)
        return;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:aView.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 10.0f;
    float bottomPadding = 10.0f;
    float leftPadding = 10.0f;
    float rightPadding = 10.0f;
    CGRect printableRect = CGRectMake(leftPadding,
                                      topPadding,
                                      kPaperSizeA4.width-leftPadding-rightPadding,
                                      kPaperSizeA4.height-topPadding-bottomPadding);
    CGRect paperRect = CGRectMake(0, 0, kPaperSizeA4.width, kPaperSizeA4.height);
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    NSData *pdfData = [render printToPDF];
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    NSArray* components = [desktopPath componentsSeparatedByString:@"/"];
    if (pdfData) {
        [pdfData writeToFile:[NSString stringWithFormat:@"%@/%@/%@/tmp.pdf", components[1], components[2], components.lastObject] atomically: YES];
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
}
-(id)init {
    if (self = [super init]) {
        self.pdfData = nil;
    }
    return self;
}

-(id) initWithHTML:(NSString *)htmlString baseURL:(NSURL *)url pathForPDF:(NSString *)pdfPath pageSize:(CGSize)pageSize {
    if (self = [super init]) {
        self.html = htmlString;
        self.url = url;
        self.pdfPath = pdfPath;
        self.pageSize = pageSize;
        [self forceLoadView];
    }
    return self;
}

- (void)forceLoadView
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.view];
    
    self.view.frame = CGRectMake(0, 0, 1, 1);
    self.view.alpha = 0.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    if (self.html == nil) {
        [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }else{
//        [_webView loadHTMLString:self.html baseURL:self.url];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    if (awebView.isLoading)
        return;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:awebView.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 10.0f;
    float bottomPadding = 10.0f;
    float leftPadding = 10.0f;
    float rightPadding = 10.0f;
    CGRect printableRect = CGRectMake(leftPadding,
                                      topPadding,
                                      kPaperSizeA4.width-leftPadding-rightPadding,
                                      kPaperSizeA4.height-topPadding-bottomPadding);
    CGRect paperRect = CGRectMake(0, 0, kPaperSizeA4.width, kPaperSizeA4.height);
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    NSData *pdfData = [render printToPDF];
    if (pdfData) {
        [pdfData writeToFile:@"/Users/tuuu/Desktop/PDFFiles/tmp.pdf" atomically: YES];
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView.isLoading) {
        return;
    }
    [self terminateWebTask];
    if (self.failBlock) {
        self.failBlock(error.description);
    }
}

- (void)terminateWebTask
{
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    
    [self.view removeFromSuperview];
    
    self.webView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIPrintPageRenderer (PDF)
-(NSData *)printToPDF {
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
}
@end
