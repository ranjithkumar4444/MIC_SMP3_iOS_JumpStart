//
//  DBHelper.h
//  Cache
//
//  Created by i061647 on 7/30/13.
//  Copyright (c) 2013 M, Pramod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBHelper : NSObject

+ (id)sharedInstance;

- (id)init;

- (void)insertRequest:(NSData*)encodedData withGuid:(double)uuid intoQueue:(NSString*)tableName;

- (void)deleteRequest:(double)uuid fromQueue:(NSString*)tableName;

- (NSArray*)getAllTableNames;

- (NSArray*)getAllEntriesFromTable:(NSString*)tableName;

- (void)clearTable:(NSString*)tableName;

- (void)closeConnection;

- (void)updateStatusOfRequest:(double)requestId inTable:(NSString*)tableName;

@end

