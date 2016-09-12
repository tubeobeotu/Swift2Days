//
//  Countries.swift
//  DemoTable
//
//  Created by cuong minh on 2/26/15.
//  Copyright (c) 2015 Techmaster. All rights reserved.
//

import Foundation
class Countries {
    var countries : [String:[Country]]!
    func initData(){
        countries = [String:[Country]]()
        countries["Asia"] = [
            Country(name: "Laos", capital: "Vientiane", population: 6803699),
            Country(name: "Vietnam", capital: "Hanoi", population: 90730000),
            Country(name: "Thailand", capital: "Bangkok", population: 90730000)
        ]
        countries["Africa"] = [
            Country(name: "Egypt", capital: "Cairo", population: 88000000),
            Country(name: "Sudan", capital: "Khartoum", population: 37289406),
            Country(name: "South Africa", capital: "Pretoria", population: 54002000)
        ]
        countries["America"] = [
            Country(name: "Cuba", capital: "Havana", population: 11210064),
            Country(name: "United States", capital: "Washington", population: 320206000),
            Country(name: "Colombia", capital: "Bogotá", population: 48014026)
        ]
        countries["Europe"] = [
            Country(name: "France", capital: "Paris", population: 66616416),
            Country(name: "United Kingdom", capital: "London", population: 64100000),
            Country(name: "Germany", capital: "Berlin", population: 80716000)
        ]        
    }
}

class Country {
    var name: String
    var capital: String
    var population: Int
    init(name: String, capital: String, population: Int) {
        self.name = name
        self.capital = capital
        self.population = population
    }
}
