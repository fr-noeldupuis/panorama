//
//  EditTransactionView+ViewModel.swift
//  panorama
//
//  Created by Noel Dupuis on 28/11/2024.
//
import SwiftUI
import SwiftData

extension EditTransactionView {
    
    @Observable
    class ViewModel {
        
        var modelContext: ModelContext
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
    }
}
