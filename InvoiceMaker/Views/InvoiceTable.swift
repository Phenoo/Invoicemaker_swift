import SwiftUI

struct Purchase: Identifiable {
    let price: Decimal
    let id = UUID()
}

struct InvoiceTable: View {
    let currencyStyle = Decimal.FormatStyle.Currency(code: "USD")

    var body: some View {
        Table(of: Purchase.self) {
            TableColumn("Base price") { purchase in
                Text(purchase.price, format: currencyStyle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(100)
            TableColumn("With 15% tip") { purchase in
                Text(purchase.price * 1.15, format: currencyStyle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(100)
            TableColumn("With 20% tip") { purchase in
                Text(purchase.price * 1.2, format: currencyStyle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(100)
            TableColumn("With 25% tip") { purchase in
                Text(purchase.price * 1.25, format: currencyStyle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(100)
        } rows: {
            TableRow(Purchase(price: 20))
            TableRow(Purchase(price: 50))
            TableRow(Purchase(price: 75))
        }
    }
}

#Preview {
    InvoiceTable()
}
