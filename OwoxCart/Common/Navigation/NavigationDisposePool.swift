//
//  NavigationDisposePool.swift
//  Onboarding
//
//  Created by Rumata on 3/30/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation

private struct FlowBucket {
  let flow: DisposableFlow
  var keepers: NSPointerArray
}

private enum NavigationDisposePool {
  
  private static var pool: [FlowBucket] = []
  
  static func add<T: DisposableFlow>(flow: T) {
    let bucket = FlowBucket(flow: flow, keepers: NSPointerArray.weakObjects())
    NavigationDisposePool.pool.append(bucket)
  }
  
  static func linkKeeper<K: DisposableFlowKeeper>(_ keeper: K) {
    guard let currentBucket = NavigationDisposePool.pool.last else {
      print("No more flow in pool!")
      return
    }
    
    let pointer = Unmanaged<K>.passUnretained(keeper).toOpaque()
    currentBucket.keepers.addPointer(pointer)
    print("linked keeper: \(keeper) to flow: \(currentBucket.flow)")
    NavigationDisposePool.pool[NavigationDisposePool.pool.count - 1] = currentBucket
  }
  
  static func unlinkKeeper<K: DisposableFlowKeeper>(_ keeper: K) {
    print("removed keeper: \(keeper)")
    let bucketIndex = NavigationDisposePool.pool.index { (bucket) -> Bool in
      return bucket.keepers.allObjects.isEmpty
    }
    guard let currentIndex = bucketIndex else {
      print("Flow still have keepers!")
      return
    }
    // Dispose flow if we should remove its last keeper
    let bucket = NavigationDisposePool.pool[currentIndex]
    NavigationDisposePool.pool.remove(at: currentIndex)
    print("removed flow: \(bucket.flow)")
  }
  
}

public protocol DisposableFlow: AnyObject {
  
  func addToDisposePool()
  
}

extension DisposableFlow {
  
  public func addToDisposePool() {
    NavigationDisposePool.add(flow: self)
  }
  
}

public protocol DisposableFlowKeeper: AnyObject {
  
  func linkToCurrentFlow()
  func unlinkFromCurrentFlow()
  
}

extension DisposableFlowKeeper {
  
  public func linkToCurrentFlow() {
    NavigationDisposePool.linkKeeper(self)
  }
  
  public func unlinkFromCurrentFlow() {
    NavigationDisposePool.unlinkKeeper(self)
  }
  
}
