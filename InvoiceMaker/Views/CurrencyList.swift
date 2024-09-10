//
//  CurrencyList.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import SwiftUI

struct CurrencyInfo: Hashable {
    let code: String
    let symbol: String
    let name: String
}

func getAllCurrencies() -> [CurrencyInfo] {
    let locales = Locale.availableIdentifiers
    var currencySet = Set<String>()
    var currencyList = [CurrencyInfo]()
    
    for localeID in locales {
        let locale = Locale(identifier: localeID)
        if let currencyCode = locale.currencyCode, !currencySet.contains(currencyCode) {
            let symbol = locale.currencySymbol ?? ""
            let name = locale.localizedString(forCurrencyCode: currencyCode) ?? ""
            let currencyInfo = CurrencyInfo(code: currencyCode, symbol: symbol, name: name)
            currencySet.insert(currencyCode)
            currencyList.append(currencyInfo)
        }
    }
    
    return currencyList.sorted(by: { $0.code < $1.code }) // Sort by currency code
}


struct CurrencyList: View {
    @State private var searchText : String = ""
    
    @Binding var selectedTextTick : CurrencyInfo?
    @Binding var selectedCurrency : Bool

    let allCurrencies: [CurrencyInfo] = getAllCurrencies()
    
    var filteredCurrencies: [CurrencyInfo] {
            if searchText.isEmpty {
                return allCurrencies
            } else {
                return allCurrencies.filter {
                    $0.code.localizedCaseInsensitiveContains(searchText) ||
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.symbol.localizedCaseInsensitiveContains(searchText)
                }
            }
        }

    
    var body: some View {
        NavigationStack{
        List(filteredCurrencies, id: \.self) { item in
            VStack(alignment: .leading){
                Text(item.code)
                Text("\(item.name) - \(item.symbol)")
            }
            .onTapGesture {
                selectedTextTick = item
                selectedCurrency = false
            }
        }.searchable(text: $searchText)
    }
}
}


