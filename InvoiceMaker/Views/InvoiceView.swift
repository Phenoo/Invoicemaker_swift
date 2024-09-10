//
//  InvoiceView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 04/09/2024.
//

import SwiftUI

struct InvoiceView: View {
    
    let invoice: Invoice
    
    @MainActor func render() -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(content: currencySection())

        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "invoice.pdf")

        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)
            
            // 7: Render the SwiftUI view data onto the page
            context(pdf)
            
            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }

    var body: some View {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        currencySection()
                        HStack {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Label("Email", systemImage: "mail")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(
                                        .black)
                                    .padding()
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            }).background {
                                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1)
                            }
                            ShareLink("Export PDF", item: render())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    .white)
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background {
                                    RoundedRectangle(cornerRadius: 12).fill(.black)
                                }
                        }
                    }
                }.padding()
                   
    }
    
    private func currencySection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                Text("IN\(invoice.invoiceNumber)")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                VStack(alignment: .leading) {
                    Text("To")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Client Name")
                        .fontWeight(.semibold)
                    Text("Cupernito,")
                    Text("West Virginia, CA")
                    Text("United States.")
                }
                .font(.caption)
            }
            .padding()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("To")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Client Name")
                        .fontWeight(.semibold)
                    Text("Cupernito,")
                    Text("West Virginia, CA")
                    Text("United States.")
                }
                .font(.caption)
                
                Spacer()
                
                Text(DateFormatter.sharedDateTimeFormatter.string(from: invoice.invoiceDate))
                    .font(Font.custom("Manrope-Medium", size: 12))
                    .fontWeight(.semibold)
               
            }
            .padding(.horizontal)

         

            
            VStack {
                HStack {
                    Text("Item")
                    Spacer()
                    Text("Quantity")
                    Text("Unit Price")
                    Text("Total")
                }
                .foregroundStyle(.gray)
                .font(.caption)
                
                ForEach(invoice.items) { item in
                    HStack {
                        Text("Macbook")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Text("\(item.quantity)")
                        Text(item.amount,  format: .currency(code: invoice.currency))
                        Text("$1500")
                    }
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.1))
                    .font(.caption)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2) ,lineWidth: 1)
            }
            .padding(8)

            
            HStack {
                
                Spacer()
                VStack(spacing: 8){
                    HStack {
                        Spacer()
                        Text("Subtotal")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("$100")
                    }
                    HStack {
                        Spacer()
                        Text("Discount")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("$100")
                    }
                    HStack {
                        Spacer()
                        Text("Tax")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("$100")
                    }
                    HStack {
                        Spacer()
                        Text("Total")
                            .font(.subheadline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Text(invoice.totalAmount, format: .currency(code: invoice.currency))

                            .font(.subheadline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }.font(.caption)
                    .padding(.horizontal)

            }
         
            HStack {
             Text("09019703844")
                Spacer()
                Text("09019703844")
                Spacer()
                Text("email@gmail,com")

            }
            .font(.caption2)
            .fontWeight(.medium)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.customGreen)
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 12,
                    bottomTrailingRadius: 12,
                    topTrailingRadius: 0
                )
            )
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background {
            RoundedRectangle(cornerRadius: 12).stroke( .gray.opacity(0.2),lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        }
    }
}

//#Preview {
//    InvoiceView()
//}
