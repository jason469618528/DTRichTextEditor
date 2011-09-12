//
//  DTRichTextEditorViewController.m
//  DTRichTextEditor
//
//  Created by Oliver Drobnik on 1/23/11.
//  Copyright 2011 Cocoanetics. All rights reserved.
//

#import "DTRichTextEditorViewController.h"
#import "NSAttributedString+HTML.h"
#import "NSAttributedString+DTRichText.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation DTRichTextEditorViewController



/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //	NSString *perc = @"%3Cp%3EAB%3C/p%3E%3Cp%3E%3Cimg%20type=%221%22%20src=%22images/NOTES_BM_UNCLEAR_A.png%22%20alt=%22%22%20name=%22%20%22%20value=%222011-07-27T08:11:58.118%23-1%23-1%22%20class=%22BMClass%22%20style=%22width:16px;height:16px;%22%20/%3E%3C/p%3E%3Cp%3ECD%3C/p%3E%3Cp%3E%3Cimg%20type=%221%22%20src=%22images/NOTES_BM_UNCLEAR_A.png%22%20name=%22%20%22%20alt=%22%22%20value=%222011-07-26T08:28:42.176%23-1%23-1%22%20class=%22BMClass%22%20style=%22width:16px;height:16px;%22%20/%3E%3C/p%3E";
    //	NSString *html = [perc stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// defaults
	//richEditor.baseURL = [NSURL URLWithString:@"http://www.drobnik.com"];
    richEditor.textDelegate = self;
	richEditor.defaultFontFamily = @"Helvetica";
	richEditor.textSizeMultiplier = 2.2;
	richEditor.maxImageDisplaySize = CGSizeMake(300, 300);
	
    NSString *html = @"<p><span style=\"color:red;\">Hello</span> <b>bold</b> <i>italic</i> <span style=\"color: green;font-family:Courier;\">World!</span></p>";
	
//	NSString *html = @"<img src=\"Oliver.jpg\">blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><br><br>blaba<br><img src=\"Oliver.jpg\"><br><br>";
	
//	NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
//	NSAttributedString *attr = [[NSAttributedString alloc] initWithHTML:data options:[richEditor textDefaults] documentAttributes:NULL];
//	//richEditor.attributedText = attr;
//	[attr release];
    
	//[DTCoreTextLayoutFrame setShouldDrawDebugFrames:YES];
	
	[richEditor setHTMLString:html];
	
	// image as drawn by your custom views which you return in the delegate method
	richEditor.contentView.shouldDrawImages = YES;
	
	
	photoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(insertPhoto:)];
	photoButton.enabled = NO;
	
	boldButton = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleBold:)];
	boldButton.enabled = NO;

	italicButton = [[UIBarButtonItem alloc] initWithTitle:@"I" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleItalic:)];
	italicButton.enabled = NO;

	underlineButton = [[UIBarButtonItem alloc] initWithTitle:@"U" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleUnderline:)];
	underlineButton.enabled = NO;

	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	// disable this once you use your own image views
	//richEditor.contentView.shouldDrawImages = YES;
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
	richEditor.inputAccessoryView = toolbar;
	
	[toolbar setItems:[NSArray arrayWithObjects:boldButton, italicButton, underlineButton, spacer, photoButton, nil]];
	
	
	// watch the selectedTextRange property
	[richEditor addObserver:self forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionNew context:self];
	
	// notification for isDirty
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:DTRichTextEditorTextDidBeginEditingNotification object:richEditor];
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[richEditor removeObserver:self forKeyPath:@"selectedTextRange"];
	
	[lastSelection release];
    
    popover.delegate = nil;
    [popover release];
    
	[boldButton release];
	[italicButton release];
	[underlineButton release];
	[photoButton release];
	[toolbar release];
	
    [_imageViewCache release];
    
    [super dealloc];
}

#pragma mark Helpers

- (void)replaceCurrentSelectionWithPhoto:(UIImage *)image
{
	if (!lastSelection)
	{
		return;
	}
	
	// make an attachment
	DTTextAttachment *attachment = [[[DTTextAttachment alloc] init] autorelease];
	attachment.contents = (id)image;
	attachment.displaySize = image.size;
	attachment.originalSize = image.size;
	attachment.contentType = DTTextAttachmentTypeImage;
	
	[richEditor replaceRange:lastSelection withAttachment:attachment inParagraph:YES];
}


#pragma mark Actions

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        
        CGImageRef iref = [representation fullScreenImage];
        if (iref) {
            UIImage *theThumbnail = [UIImage imageWithCGImage:iref];
			[self replaceCurrentSelectionWithPhoto:theThumbnail];
        }
    };
	
	
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
	
    if(imageURL)
    {
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:imageURL 
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
        [popover dismissPopoverAnimated:YES];
        [popover release], popover = nil;
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)insertPhoto:(UIBarButtonItem *)sender
{
	// preserve last selection because this goes away when editor loses firstResponder
	[lastSelection release];
	lastSelection = [richEditor.selectedTextRange retain];
	
	if (!lastSelection)
	{
		return;
	}
	
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.delegate = self;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		popover = [[UIPopoverController alloc] initWithContentViewController:picker];
		popover.delegate = self;
		[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else
	{
		[self presentModalViewController:picker animated:YES];
	}
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [popover release], popover = nil;
}

- (void)toggleBold:(UIBarButtonItem *)sender
{
	UITextRange *range = richEditor.selectedTextRange;
	[richEditor toggleBoldInRange:range];
}

- (void)toggleItalic:(UIBarButtonItem *)sender
{
	UITextRange *range = richEditor.selectedTextRange;
	[richEditor toggleItalicInRange:range];
}
- (void)toggleUnderline:(UIBarButtonItem *)sender
{
	UITextRange *range = richEditor.selectedTextRange;
	[richEditor toggleUnderlineInRange:range];
}

#pragma mark Notifications
- (void)textChanged:(NSNotification *)notification
{
	isDirty = YES;
	//NSLog(@"Text Changed");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"selectedTextRange"] && context == self)
	{
		id newRange = [change objectForKey:NSKeyValueChangeNewKey];
		
		// disable photo/bold button if there is no selection
		if (newRange == [NSNull null])
		{
			for (UIBarButtonItem *oneItem in toolbar.items)
			{
				oneItem.enabled = NO;
			}
		}
		else
		{
			for (UIBarButtonItem *oneItem in toolbar.items)
			{
				oneItem.enabled = YES;
			}
			
			[lastSelection release];
			lastSelection = [richEditor.selectedTextRange retain];
		}
	}
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    NSNumber *cacheKey = [NSNumber numberWithUnsignedInteger:[attachment hash]];
    
    UIImageView *imageView = [self.imageViewCache objectForKey:cacheKey];
    
    if (imageView)
    {
        imageView.frame = frame;
        return imageView;
    }
    
    if (attachment.contentType == DTTextAttachmentTypeImage)
	{
        imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        if ([attachment.contents isKindOfClass:[UIImage class]])
        {
            imageView.image = attachment.contents;
        }
        
        [self.imageViewCache setObject:imageView forKey:cacheKey];
        
        return imageView;
    }
    
	
	return nil;
}

#pragma mark Properties

- (DTCache *)imageViewCache
{
    if (!_imageViewCache)
    {
        _imageViewCache = [[DTCache alloc] init];
    }
    
    return _imageViewCache;
}

@synthesize imageViewCache = _imageViewCache;

@end
