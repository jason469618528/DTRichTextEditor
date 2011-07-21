//
//  NSMutableAttributedString+DTRichText.m
//  DTRichTextEditor
//
//  Created by Oliver Drobnik on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableAttributedString+DTRichText.h"

#import "DTTextAttachment.h"
#import <CoreText/CoreText.h>
#import "NSAttributedStringRunDelegates.h"
#import "NSString+HTML.h"

#import "DTCoreTextFontDescriptor.h"


@implementation NSMutableAttributedString (DTRichText)

- (NSDictionary *)typingAttributesForRange:(NSRange)range
{
	NSInteger index = 0;
	
	if (range.length)
	{
		// range = first character of range
		index = range.location;
	}
	else
	{
		if (range.location>0)
		{
			index = range.location - 1;
		}
	}
	
	if (index >= [self length])
	{
		return nil;
	}
	
	return [self attributesAtIndex:index effectiveRange:NULL];
}

- (void)replaceRange:(NSRange)range withAttachment:(DTTextAttachment *)attachment
{
	NSMutableDictionary *attributes = [[self typingAttributesForRange:range] mutableCopy];
	
	// need run delegate for sizing
	CTRunDelegateRef embeddedObjectRunDelegate = createEmbeddedObjectRunDelegate((id)attachment);
	[attributes setObject:(id)embeddedObjectRunDelegate forKey:(id)kCTRunDelegateAttributeName];
	CFRelease(embeddedObjectRunDelegate);
	
	// add attachment
	[attributes setObject:attachment forKey:@"DTTextAttachment"];
	
	NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithString:UNICODE_OBJECT_PLACEHOLDER attributes:attributes];
	
	[self replaceCharactersInRange:range withAttributedString:tmpStr];
	
	[tmpStr release];
	[attributes release];
}

- (void)toggleBoldInRange:(NSRange)range
{
	// first character determines current boldness
	NSDictionary *currentAttributes = [self typingAttributesForRange:range];
	
	CTFontRef currentFont = (CTFontRef)[currentAttributes objectForKey:(id)kCTFontAttributeName];
	DTCoreTextFontDescriptor *typingFontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:currentFont];
	
	// need to replace name with family
	CFStringRef family = CTFontCopyFamilyName(currentFont);
	typingFontDescriptor.fontFamily = (NSString *)family;
	CFRelease(family);
	
	typingFontDescriptor.fontName = nil;
	
    NSRange attrRange;
    NSUInteger index=range.location;
    
    while (index < NSMaxRange(range)) 
    {
        NSMutableDictionary *attrs = [[self attributesAtIndex:index effectiveRange:&attrRange] mutableCopy];
		CTFontRef currentFont = (CTFontRef)[attrs objectForKey:(id)kCTFontAttributeName];
		DTCoreTextFontDescriptor *desc = [DTCoreTextFontDescriptor fontDescriptorForCTFont:currentFont];
		
		// need to replace name with family
		CFStringRef family = CTFontCopyFamilyName(currentFont);
		desc.fontFamily = (NSString *)family;
		CFRelease(family);
		
		desc.fontName = nil;
		
		desc.boldTrait = !typingFontDescriptor.boldTrait;
		CTFontRef newFont = [desc newMatchingFont];
		[attrs setObject:(id)newFont forKey:(id)kCTFontAttributeName];
		CFRelease(newFont);
		
		if (attrRange.location < range.location)
		{
			attrRange.length -= (range.location - attrRange.location);
			attrRange.location = range.location;
		}
		
		if (NSMaxRange(attrRange)>NSMaxRange(range))
		{
			attrRange.length = NSMaxRange(range) - attrRange.location;
		}
		
		[self setAttributes:attrs range:attrRange];
		
        index += attrRange.length;
    }
}


- (void)toggleItalicInRange:(NSRange)range
{
	// first character determines current italic status
	NSDictionary *currentAttributes = [self typingAttributesForRange:range];
	
	CTFontRef currentFont = (CTFontRef)[currentAttributes objectForKey:(id)kCTFontAttributeName];
	DTCoreTextFontDescriptor *typingFontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:currentFont];
	
	// need to replace name with family
	CFStringRef family = CTFontCopyFamilyName(currentFont);
	typingFontDescriptor.fontFamily = (NSString *)family;
	CFRelease(family);
	
	typingFontDescriptor.fontName = nil;
	
    NSRange attrRange;
    NSUInteger index=range.location;
    
    while (index < NSMaxRange(range)) 
    {
        NSMutableDictionary *attrs = [[self attributesAtIndex:index effectiveRange:&attrRange] mutableCopy];
		CTFontRef currentFont = (CTFontRef)[attrs objectForKey:(id)kCTFontAttributeName];
		DTCoreTextFontDescriptor *desc = [DTCoreTextFontDescriptor fontDescriptorForCTFont:currentFont];
		
		// need to replace name with family
		CFStringRef family = CTFontCopyFamilyName(currentFont);
		desc.fontFamily = (NSString *)family;
		CFRelease(family);
		
		desc.fontName = nil;
		
		desc.italicTrait = !typingFontDescriptor.italicTrait;
		CTFontRef newFont = [desc newMatchingFont];
		[attrs setObject:(id)newFont forKey:(id)kCTFontAttributeName];
		CFRelease(newFont);
		
		if (attrRange.location < range.location)
		{
			attrRange.length -= (range.location - attrRange.location);
			attrRange.location = range.location;
		}
		
		if (NSMaxRange(attrRange)>NSMaxRange(range))
		{
			attrRange.length = NSMaxRange(range) - attrRange.location;
		}
		
		[self setAttributes:attrs range:attrRange];
		
        index += attrRange.length;
    }
}

- (void)toggleUnderlineInRange:(NSRange)range
{
	// first character determines current italic status
	NSDictionary *currentAttributes = [self typingAttributesForRange:range];
	
	BOOL isUnderline = [currentAttributes objectForKey:(id)kCTUnderlineStyleAttributeName]!=nil;
	
    NSRange attrRange;
    NSUInteger index=range.location;
    
    while (index < NSMaxRange(range)) 
    {
        NSMutableDictionary *attrs = [[self attributesAtIndex:index effectiveRange:&attrRange] mutableCopy];
		
		if (isUnderline)
		{
			[attrs removeObjectForKey:(id)kCTUnderlineStyleAttributeName];
		}
		else
		{
			[attrs setObject:[NSNumber numberWithBool:YES] forKey:(id)kCTUnderlineStyleAttributeName];
		}
		if (attrRange.location < range.location)
		{
			attrRange.length -= (range.location - attrRange.location);
			attrRange.location = range.location;
		}
		
		if (NSMaxRange(attrRange)>NSMaxRange(range))
		{
			attrRange.length = NSMaxRange(range) - attrRange.location;
		}
		
		[self setAttributes:attrs range:attrRange];
		
        index += attrRange.length;
    }	
}

@end
