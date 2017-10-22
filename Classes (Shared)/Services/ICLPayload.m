/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

 Copyright (c) 2010 - 2017 Codeux Software, LLC & respective contributors.
        Please see Acknowledgements.pdf for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Textual and/or "Codeux Software, LLC", nor the 
      names of its contributors may be used to endorse or promote products 
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

#import "ICLPayload.h"
#import "ICLPayloadMutable.h"

#import "ICLPayloadInternal.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ICLPayload

ClassWithDesignatedInitializerInitMethod

- (instancetype)_init
{
	return [super init];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
	NSParameterAssert(aDecoder != nil);

	ObjectIsAlreadyInitializedAssert

	if ((self = [super init])) {
		[self decodeWithCoder:aDecoder];

		[self populateDefaultsPostflight];

		return self;
	}

	return nil;
}

- (void)decodeWithCoder:(NSCoder *)aDecoder
{
	NSParameterAssert(aDecoder != nil);

	ObjectIsAlreadyInitializedAssert

	self->_contentLength = [aDecoder decodeUnsignedIntegerForKey:@"contentLength"];
	self->_contentSize = [aDecoder decodeSizeForKey:@"contentSize"];

	self->_styleResources = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [NSURL class]]]
													 forKey:@"styleResources"];

	self->_scriptResources = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [NSURL class]]]
													  forKey:@"scriptResources"];

	self->_html = [aDecoder decodeStringForKey:@"html"];

	self->_entrypoint = [aDecoder decodeStringForKey:@"entrypoint"];
	self->_entrypointPayload = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:@"entrypointPayload"];

	self->_url = [aDecoder decodeObjectOfClass:[NSURL class] forKey:@"url"];

	self->_lineNumber = [aDecoder decodeStringForKey:@"lineNumber"];

	self->_uniqueIdentifier = [aDecoder decodeStringForKey:@"uniqueIdentifier"];
	self->_viewIdentifier = [aDecoder decodeStringForKey:@"viewIdentifier"];

	self->_index = [aDecoder decodeUnsignedIntegerForKey:@"index"];

	[self initializedClassHealthCheck];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeUnsignedInteger:self->_contentLength forKey:@"contentLength"];
	[aCoder encodeSize:self->_contentSize forKey:@"contentSize"];

	[aCoder maybeEncodeObject:self->_styleResources forKey:@"styleResources"];
	[aCoder maybeEncodeObject:self->_scriptResources forKey:@"scriptResources"];

	[aCoder encodeObject:self->_html forKey:@"html"];

	[aCoder maybeEncodeObject:self->_entrypoint forKey:@"entrypoint"];
	[aCoder maybeEncodeObject:self->_entrypointPayload forKey:@"entrypointPayload"];

	[aCoder encodeObject:self->_url forKey:@"url"];

	[aCoder encodeObject:self->_lineNumber forKey:@"lineNumber"];

	[aCoder encodeObject:self->_uniqueIdentifier forKey:@"uniqueIdentifier"];
	[aCoder encodeObject:self->_viewIdentifier forKey:@"viewIdentifier"];

	[aCoder encodeUnsignedInteger:self->_index forKey:@"index"];
}

+ (BOOL)supportsSecureCoding
{
	return YES;
}

- (void)populateDefaultsPostflight
{
	self->_contentSize = NSZeroSize;

	SetVariableIfNil(self->_scriptResources, @[]);

	SetVariableIfNil(self->_html, @"");
}

- (void)initializedClassHealthCheck
{
	ObjectIsAlreadyInitializedAssert

	NSParameterAssert(self->_html != nil);
	NSParameterAssert(self->_url != nil);
	NSParameterAssert(self->_lineNumber != nil);
	NSParameterAssert(self->_uniqueIdentifier != nil);
	NSParameterAssert(self->_viewIdentifier != nil);
}

- (id)copyWithZone:(nullable NSZone *)zone asMutable:(BOOL)copyAsMutable
{
	ICLPayload *object = nil;

	if (copyAsMutable) {
		object = [ICLPayloadMutable allocWithZone:zone];
	} else {
		object = [ICLPayload allocWithZone:zone];
	}

	object->_objectInitializedAsCopy = YES;

	object->_contentLength = self->_contentLength;
	object->_contentSize = self->_contentSize;

	object->_styleResources = self->_styleResources;
	object->_scriptResources = self->_scriptResources;

	object->_html = self->_html;

	object->_entrypoint = self->_entrypoint;
	object->_entrypointPayload = self->_entrypointPayload;

	object->_url = self->_url;

	object->_lineNumber = self->_lineNumber;

	object->_uniqueIdentifier = self->_uniqueIdentifier;
	object->_viewIdentifier = self->_viewIdentifier;

	object->_index = self->_index;

	return [object _init];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
	return [self copyWithZone:zone asMutable:NO];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
	return [self copyWithZone:zone asMutable:YES];
}

- (NSDictionary<NSString *, id<NSCopying>> *)entrypointPayload
{
	NSDictionary *payload = self->_entrypointPayload;

	if (payload == nil) {
		return [self entrypointPayloadDefaultContext];
	}

	return payload;
}

- (NSDictionary<NSString *, id<NSCopying>> *)entrypointPayloadDefaultContext
{
	return @{
		@"html" : self->_html,
		@"url" : self->_url,
		@"lineNumber" : self->_lineNumber,
		@"uniqueIdentifier" : self->_uniqueIdentifier
	};
}

- (void)entrypointPayloadSetContext
{
	/* Set context to payload that module sets. */
	/* The values set in the context don't change so we
	 are safe setting and forgetting. */
	NSDictionary *payload = self->_entrypointPayload;

	if (payload == nil) {
		return;
	}

	NSDictionary *payloadToSet = [self entrypointPayloadDefaultContext];

	self->_entrypointPayload = [payload dictionaryByAddingEntries:payloadToSet];
}

- (NSString *)address
{
	return self->_url.absoluteString;
}

- (BOOL)isMutable
{
	return NO;
}

@end

#pragma mark -

@implementation ICLPayloadMutable

@dynamic contentLength;
@dynamic contentSize;
@dynamic styleResources;
@dynamic scriptResources;
@dynamic html;
@dynamic entrypoint;
@dynamic entrypointPayload;

- (BOOL)isMutable
{
	return YES;
}

- (void)setContentLength:(NSUInteger)contentLength
{
	if (self->_contentLength != contentLength) {
		self->_contentLength = contentLength;
	}
}

- (void)setContentSize:(NSSize)contentSize
{
	self->_contentSize = contentSize;
}

- (void)setStyleResources:(nullable NSArray<NSURL *> *)styleResources
{
	if (self->_styleResources != styleResources) {
		self->_styleResources = styleResources;
	}
}

- (void)setScriptResources:(nullable NSArray<NSURL *> *)scriptResources
{
	if (self->_scriptResources != scriptResources) {
		self->_scriptResources = scriptResources;
	}
}

- (void)setHtml:(NSString *)html
{
	NSParameterAssert(html != nil);

	if (self->_html != html) {
		self->_html = html;
	}
}

- (void)setEntrypoint:(nullable NSString *)entrypoint
{
	if (self->_entrypoint != entrypoint) {
		self->_entrypoint = entrypoint;
	}
}

- (void)setEntrypointPayload:(nullable NSDictionary<NSString *, id<NSCopying>> *)entrypointPayload
{
	if (self->_entrypointPayload != entrypointPayload) {
		self->_entrypointPayload = entrypointPayload;

		[self entrypointPayloadSetContext];
	}
}

@end

NS_ASSUME_NONNULL_END
