//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 27/1/21.
//

import SwiftUI

struct ItemRowView: View {

    @ObservedObject var item: Item

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}
