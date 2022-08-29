//
//  CoreDataManagerProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 26/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//
import CoreData
import Foundation

typealias CoreDataResult = Result<[NSManagedObject]?, Error>
typealias ChangesBlock = (NSManagedObjectContext) -> Void

protocol CoreDataManagerProtocol {
    func saveAsync(_ changes: @escaping ChangesBlock, completion: @escaping (Bool) -> Void)
    func fetchAsync(fetchRequest: NSFetchRequest<NSFetchRequestResult>, completion: @escaping(CoreDataResult) -> Void)
}
