//
//  PortfolioDataRepository.swift
//  crypto
//
//  Created by ImDung on 20/7/24.
//

import Foundation
import CoreData

class PortfolioDataRepository {
    private let container : NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities : [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error when loading core data \(error)")
            }
            self.getPortfolio()
        }
        
    }
    
    // MARK: PUBLIC
    
    func updatePortfolio(coin : CoinModel, amount : Double) {
        if let entity = savedEntities.first(where: { portfolio in
            portfolio.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            }
            else {
                remove(entity: entity)
            }
        }
        else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    // MARK: PRIVATE
    
    private func getPortfolio() {
        let request : NSFetchRequest = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        }
        catch {
            print("error when get portfolio_entity \(error)")
        }
    }
    
    private func add(coin : CoinModel, amount : Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        }
        catch {
            print("error when save to core data \(error)")
        }
    }
    
    private func update(entity : PortfolioEntity, amount : Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity : PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
