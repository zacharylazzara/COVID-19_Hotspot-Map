//
//  LeaderboardView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//


// TODO: display a list view showing which cities per province have the highest COVID-19 cases (group by province, maybe implement some filtering functionality too

import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        Text("This will be the leaderboard view; it needs to display a list of cities grouped into provinces, with the city with the most cases at the top of the list. There's a lot of cities though so you might wanna do something so they're not all displayed at once; maybe just the top 5 or 10 of each province (and the user's current province should be first probably)").padding()
        Spacer()
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
