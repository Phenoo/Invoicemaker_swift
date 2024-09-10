//
//  AddInvoiceView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import SwiftUI

enum Steps: Int, CaseIterable {
    case one
    case two
    case three
    
    func next() -> Steps? {
         let allCases = Steps.allCases
         guard let currentIndex = allCases.firstIndex(of: self) else { return nil }
         let nextIndex = allCases.index(after: currentIndex)
         return nextIndex < allCases.endIndex ? allCases[nextIndex] : nil
     }
    
    func previous() -> Steps? {
        let allCases = Steps.allCases
        let previousIndex = allCases.firstIndex(of: self)?.advanced(by: -1)
        return previousIndex != nil && previousIndex! >= 0 ? allCases[previousIndex!] : nil
    }
}


struct InvoiceDetails {
   var bankTransfer: Bool = false

    var paypal: Bool = false

    var cash: Bool = false

   var selectedDue : String = "30 days"
    
    var payment: String = ""
    
    var items: [InvoiceItem] = []
    
    var instruction : String = ""
    
    var client : String = ""
    
}

struct AddInvoiceView: View {

    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var context
    
    @State private var step: Steps = .one
    
    @State private var selectedTextTick : CurrencyInfo?

    @State private var newItem: Bool = false

    @State private var selectedCurrency: Bool = false

    @State private var invoiceCreated: Bool = false

    @State private var invoiceFile: Invoice?

    
    @State private var details = InvoiceDetails()

    @State private var taxSelected: String = "10%"
    
    let invoice: Invoice?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func getCurrencyCode() -> String {
        return selectedTextTick?.code ?? "USD"
    }
    
    private func delete(at itemIndex: IndexSet) {
        details.items.remove(atOffsets: itemIndex)
    }
    
    func loadInvoiceDetails() {
          // Load existing invoice details into the view's state
        if let invoice = invoice {
            details.client = invoice.clientName
            details.selectedDue = invoice.paymentDue
            details.items = invoice.items
//            selectedTextTick = CurrencyInfo(code: invoice.currency, symbol: getCurrencySymbol(for: invoice.currency), name: )
        }
          // Assuming you have a function to get the currency symbol based on the code
      }
    
    func generateInvoiceNumber() -> String {
        let numbers = String((0..<5).map { _ in "0123456789".randomElement()! })
        return  numbers
    }

    var body: some View {
        List {
            // Step content based on the current step
            stepContent()
            
            // Next/Generate Invoice Button
            if let nextStep = step.next() {
                nextButton(nextStep: nextStep)
            } else {
                generateInvoiceButton()
            }
        }.overlay(alignment: .bottom) {
            if step == .two {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Subtotal")
                            .font(Font.custom("Manrope-Medium", size: 20))
                        Spacer()
                        Text("$225.50")
                    }
                    .padding(.vertical, 12)
                    Divider()
                    HStack {
                        Text("TAX")
                            .font(Font.custom("Manrope-Medium", size: 20))
                        Spacer()
                        HStack {
                            
                            Picker("tax", selection: $taxSelected) {
                                Text("5%").tag("5%")
                                   Text("10%").tag("10%")
                                   Text("15%").tag("15%")
                                   Text("20%").tag("20%")
                            }.pickerStyle(.menu)
                            
                            Text("$225.50")
                        }
                    }
                    .padding(.vertical, 8)
                    Divider()
                    HStack {
                        Text("Total summary")
                        .font(Font.custom("Manrope-Medium", size: 20))
                        Spacer()
                        Text("$225.50")
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 16)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.white)
            }
        }
        .sheet(isPresented: $invoiceCreated) {
            VStack(alignment: .leading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Done")
                        .padding()
                })
                
                if let invoiceFile = invoiceFile {
                    InvoiceView(invoice: invoiceFile)
                }
            }
        }
        .sheet(isPresented: $selectedCurrency) {
            CurrencyList(selectedTextTick: $selectedTextTick, selectedCurrency: $selectedCurrency)
        }
        .sheet(isPresented: $newItem) {
            NewItemView(items: $details.items)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton()
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("New Invoice")
                        .font(.headline)
                    Text("\(step.rawValue) / 3 Steps")
                        .font(.caption)
                }
            }
        }
        .onAppear(perform: {
            loadInvoiceDetails()
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(invoice != nil ? "Edit Invoice" : "New Invoice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func stepContent() -> some View {
        switch step {
        case .one:
            currencySection()
        case .two:
            itemsSection()
        case .three:
            invoiceDetailsSection()
        }
    }

    private func currencySection() -> some View {
        Section("Currency") {
            TextField("Client Name", text: $details.client)
            HStack {
                Text("Currency")
                Spacer()
                HStack {
                    if let currency = selectedTextTick {
                        Text(currency.code) + Text("(\(currency.symbol))")
                    }
                    Image(systemName: "chevron.right")
                }
            }
            .onTapGesture {
                selectedCurrency = true
            }
        }
    }

    private func itemsSection() -> some View {
        Section("Items") {
            ForEach(details.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name).font(.title2)
                            .font(Font.custom("Manrope-Medium", size: 20))
                        Text("\(item.quantity) x \(item.amount)")
                            .font(.caption)
                    }
                    Spacer()
                    Text("\((Int(item.quantity) * Int(item.amount)), format: .currency(code: "\(getCurrencyCode())"))")
                }
            }
            .onDelete(perform: delete)

            HStack(spacing: 16) {
                Image(systemName: "plus.circle")
                    .font(.title3)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.customGreen))
                Text("Add Item")
            }
            .onTapGesture {
                newItem = true
            }
        }
    }

    private func invoiceDetailsSection() -> some View {
        Group {
            Section {
                HStack {
                    Text("Invoice number")
                    Spacer()
                    
                    if let invoice = invoice {
                        Text(invoice.invoiceNumber)
                    } else {
                        Text("#IN\(generateInvoiceNumber())")
                    }

                }
                HStack {
                    Text("Invoice Date")
                    Spacer()
                    
                    if invoice != nil {
                        Text(dateFormatter.string(from: invoice?.invoiceDate ?? Date()))
                    } else {
                        Text(dateFormatter.string(from: Date()))

                    }
                }
                Picker("Payment Due", selection: $details.selectedDue) {
                    Text("30 days").tag("30 days")
                    Text("60 days").tag("60 days")
                }
                .pickerStyle(.navigationLink)
            }
            
            Section("Billing address") {
                Toggle("Bank Transfer", isOn: $details.bankTransfer)
                    .tint(Color.customGreen)
                Toggle("PayPal", isOn: $details.paypal)
                    .tint(Color.customGreen)
                Toggle("Cash or Check", isOn: $details.cash)
                    .tint(Color.customGreen)
            }
            
            Section("Payment instructions") {
                TextField("Add payment instructions here...", text: $details.instruction)
                    .frame(minWidth: 100, maxWidth: 200, minHeight: 50, maxHeight: .infinity, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .padding(.vertical)
            }
        }
    }

    private func nextButton(nextStep: Steps) -> some View {
        Button(action: {
            step = nextStep
        }, label: {
            Text("Next")
                .padding()
                .foregroundStyle(.white)
                .font(.headline)
                .frame(width: 100)
        })
        .background(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }

    private func generateInvoiceButton() -> some View {
        Button(action: {
            if let invoice = invoice {
                invoice.clientName = details.client
                      invoice.paymentDue = details.selectedDue
                      invoice.items = details.items
                      invoice.currency = selectedTextTick?.code ?? "USD"
            } else {
                let newInvoiceItem = Invoice(invoiceNumber: generateInvoiceNumber(), currency: selectedTextTick?.code ?? "USD", paymentDue: details.selectedDue, clientName: details.client, items: details.items)
                
                invoiceFile = newInvoiceItem
                
                context.insert(newInvoiceItem)
            }
            do {
                try context.save()
                print("done")
                
                if invoice == nil {
                    invoiceCreated = true
                } else {
                    dismiss()
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }, label: {
            Text("\((invoice != nil) ? "Edit" : "Generate") Invoice")
                .padding()
                .foregroundStyle(.white)
                .font(.headline)
        })
        .background(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }

    private func backButton() -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.caption)
            Text("Back")
        }
        .onTapGesture {
            if let previousStep = step.previous() {
                step = previousStep
            } else {
                dismiss()
            }
        }
    }
}

struct NewItemView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var quantity: Double?
    @State private var price: Double?
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var items: [InvoiceItem]
    
    private var isFormValid: Bool {
        !name.isEmpty && quantity != nil && Double(quantity!) > 0 && price != nil && Double(price!) > 0
    }
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    TextField("Name", text: $name)
                        .autocorrectionDisabled()
                    TextField("Description", text: $description)
                        .autocorrectionDisabled()
                    
                }
                
                Section {
                    TextField("Quantity", value: $quantity, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Price", value: $price, format: .number)
                        .keyboardType(.numberPad)
                }
                
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        let newitem = InvoiceItem(name: name, quantity: Int(quantity!), description: description, amount: price!)
                        
                        items.append(newitem)
                        dismiss()
                        
                    } label: {
                        Text("Done")
                    }.disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Text("Close")
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Item Details")
                }
            }
        }
        
    }
}
