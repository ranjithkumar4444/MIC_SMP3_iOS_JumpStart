//
//  MAFGenericParser.h
//  MAFUIComponents
//
//  Created by Farkas, Zoltan on 04/20/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFParserDelegate.h"

@interface MAFGenericParser : NSObject<NSXMLParserDelegate, MAFParserDelegate> {
	NSMutableString*	m_Path;
	int					m_Level;
	NSMutableString*	m_LastValue;
	BOOL				m_HasBufferedValue;
	NSXMLParser*		m_Parser;
	NSException*		m_Exception;
	NSDictionary*		m_AttributesOfLastElement;
}

@property (nonatomic, retain) NSMutableString* path;
@property (nonatomic, assign) int level;
@property (nonatomic, retain) NSMutableString* lastValue;
@property (nonatomic, assign) BOOL hasBufferedValue;
@property (nonatomic, assign) NSXMLParser* parser; //Must be assign and not retain! cross-reference!
@property (nonatomic, retain) NSException* exception;
@property (nonatomic, assign, readonly) BOOL foundPrefix;
@property (nonatomic, retain, readonly) NSString* prefix;
@property (nonatomic, retain) NSDictionary* attributesOfLastElement;

-(id) init;

#pragma mark -
#pragma mark Public API

/**
  * Parses the passed data as XML
  */
-(void) parse:(NSData* const)content;

/**
  * Parses the data that will be downloaded from the passed URL as XML
  */
-(void) parseContentsOfURL:(NSURL* const)url;

#pragma mark -
#pragma mark Private API
-(void) parserDidStartDocument:(NSXMLParser*)parser;
-(void) parserDidEndDocument:(NSXMLParser*)parser;
-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict;
-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName;
-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string;

//API for the specific parsers>>
-(void) setDoProcessPrefixes:(BOOL)processPrefixes;
-(void) abortParsing;
//Redefine only these methods in the specific parser>>
-(void) startDocument;
-(void) endDocument;
-(void) startElement:(NSString* const)elementName namespaceURI:(NSString* const)namespaceURI attributes:(NSDictionary* const)attributes;
-(void) endElement:(NSString* const)elementName namespaceURI:(NSString* const)namespaceURI;
-(void) characters:(NSString* const)string;

#pragma mark - Deprecated API
-(NSMutableString*)getPath DEPRECATED_ATTRIBUTE;
-(int)getLevel DEPRECATED_ATTRIBUTE;
-(NSMutableString*)getLastValue DEPRECATED_ATTRIBUTE;
-(NSXMLParser*)getParser DEPRECATED_ATTRIBUTE;
-(NSException*)getException DEPRECATED_ATTRIBUTE;
-(BOOL)getFoundPrefix DEPRECATED_ATTRIBUTE;
-(NSString*)getPrefix DEPRECATED_ATTRIBUTE;
-(NSDictionary*)getAttributesOfLastElement DEPRECATED_ATTRIBUTE;
@end
