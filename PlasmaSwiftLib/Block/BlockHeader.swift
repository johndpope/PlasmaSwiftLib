//
//  BlockHeader.swift
//  PlasmaSwiftLib
//
//  Created by Anton Grigorev on 18.10.2018.
//  Copyright © 2018 The Matter. All rights reserved.
//

import Foundation
import SwiftRLP
import BigInt

class BlockHeader {
    
    private let helpers = BlockHelpers()
    
    public var blockNumber: BigUInt
    public var numberOfTxInBlock: BigUInt
    public var parentHash: BigUInt
    public var merkleRootOfTheTxTree: BigUInt
    public var v: BigUInt
    public var r: BigUInt
    public var s: BigUInt
    public var data: Data
    public var blockHeader: [AnyObject]
    
    public init?(blockNumber: BigUInt, numberOfTxInBlock: BigUInt, parentHash: BigUInt, merkleRootOfTheTxTree: BigUInt, v: BigUInt, r: BigUInt, s: BigUInt){
        guard blockNumber.bitWidth <= Constants.blockNumberMaxWidth else {return nil}
        guard numberOfTxInBlock.bitWidth <= Constants.numberOfTxInBlockMaxWidth else {return nil}
        guard parentHash.bitWidth <= Constants.parentHashMaxWidth else {return nil}
        guard merkleRootOfTheTxTree.bitWidth <= Constants.merkleRootOfTheTxTreeMaxWidth else {return nil}
        guard v.bitWidth <= Constants.vMaxWidth else {return nil}
        guard r.bitWidth <= Constants.rMaxWidth else {return nil}
        guard s.bitWidth <= Constants.sMaxWidth else {return nil}
        
        guard v == 27 || v == 28 else {return nil}
        
        self.blockNumber = blockNumber
        self.numberOfTxInBlock = numberOfTxInBlock
        self.parentHash = parentHash
        self.merkleRootOfTheTxTree = merkleRootOfTheTxTree
        self.v = v
        self.r = r
        self.s = s
        
        let blockHeader = [blockNumber,
                           numberOfTxInBlock,
                           parentHash,
                           merkleRootOfTheTxTree,
                           v, r, s] as [AnyObject]
        self.blockHeader = blockHeader
        guard let data = RLP.encode(blockHeader) else {return nil}
        self.data = data
    }
    
    public init?(data: Data) {
        guard let item = RLP.decode(data) else {return nil}
        guard let dataArray = item[0] else {return nil}
        
        guard let blockHeader = helpers.serializeBlockHeader(dataArray: dataArray) else {return nil}
        
        self.data = blockHeader.data
        self.blockNumber = blockHeader.blockNumber
        self.numberOfTxInBlock = blockHeader.numberOfTxInBlock
        self.parentHash = blockHeader.parentHash
        self.merkleRootOfTheTxTree = blockHeader.merkleRootOfTheTxTree
        self.v = blockHeader.v
        self.r = blockHeader.r
        self.s = blockHeader.s
        self.blockHeader = [blockHeader.blockNumber,
                            blockHeader.numberOfTxInBlock,
                            blockHeader.parentHash,
                            blockHeader.merkleRootOfTheTxTree,
                            blockHeader.v,
                            blockHeader.r,
                            blockHeader.s] as [AnyObject]
    }
}

extension BlockHeader: Equatable {
    public static func ==(lhs: BlockHeader, rhs: BlockHeader) -> Bool {
        return lhs.blockNumber == rhs.blockNumber &&
            lhs.numberOfTxInBlock == rhs.numberOfTxInBlock &&
            lhs.parentHash == rhs.parentHash &&
            lhs.merkleRootOfTheTxTree == rhs.merkleRootOfTheTxTree &&
            lhs.v == rhs.v &&
            lhs.r == rhs.r &&
            lhs.s == rhs.s
    }
}
