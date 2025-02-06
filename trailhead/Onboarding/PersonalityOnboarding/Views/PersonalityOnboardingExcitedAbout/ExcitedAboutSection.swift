//
//  ExcitedAboutOption.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//
struct ExcitedAboutSection: Identifiable {
    var id: String { name }
    let name: String
    let iconName: String
    let options: [ExcitedAboutOption]
}

let SECTIONS: [ExcitedAboutSection] = [
    ExcitedAboutSection(
        name: "At home",
        iconName: "house.fill",
        options: [
            ExcitedAboutOption(name: "Creativity"),
            ExcitedAboutOption(name: "Making music"),
            ExcitedAboutOption(name: "Spying on my neighbors"),
            ExcitedAboutOption(name: "Netflix & Chill"),
            ExcitedAboutOption(name: "Plant parent"),
            ExcitedAboutOption(name: "Gardening"),
            ExcitedAboutOption(name: "Cozy"),
            ExcitedAboutOption(name: "Cooking"),
            ExcitedAboutOption(name: "Board games"),
            ExcitedAboutOption(name: "Sleeping in"),
            ExcitedAboutOption(name: "Staying in a bathrobe"),
            ExcitedAboutOption(name: "Ikea hacks"),
            ExcitedAboutOption(name: "Ceramics"),
            ExcitedAboutOption(name: "Petting my cat"),
            ExcitedAboutOption(name: "Fashion"),
            ExcitedAboutOption(name: "Dyson addict"),
            ExcitedAboutOption(name: "Afternoon nap"),
            ExcitedAboutOption(name: "Singing in the shower"),
            ExcitedAboutOption(name: "Marie Kondo"),
            ExcitedAboutOption(name: "Meditation")
        ]
    ),
    ExcitedAboutSection(
        name: "Food & Drinks",
        iconName: "fork.knife",
        options: [
            ExcitedAboutOption(name: "Pizza lover"),
            ExcitedAboutOption(name: "Snack break"),
            ExcitedAboutOption(name: "The more cheese the better"),
            ExcitedAboutOption(name: "Chocolate addict"),
            ExcitedAboutOption(name: "Alcohol-free"),
            ExcitedAboutOption(name: "BBQ sauce"),
            ExcitedAboutOption(name: "Chicken addict"),
            ExcitedAboutOption(name: "Cocktails"),
            ExcitedAboutOption(name: "Hummus is the new caviar"),
            ExcitedAboutOption(name: "Brunch"),
            ExcitedAboutOption(name: "BBQ"),
            ExcitedAboutOption(name: "Street food"),
            ExcitedAboutOption(name: "Pasta or nothing"),
            ExcitedAboutOption(name: "Wine and more wine"),
            ExcitedAboutOption(name: "Craft beer"),
            ExcitedAboutOption(name: "Spicy food"),
            ExcitedAboutOption(name: "French fries"),
            ExcitedAboutOption(name: "Ramen"),
            ExcitedAboutOption(name: "Cheese"),
            ExcitedAboutOption(name: "Healthy"),
            ExcitedAboutOption(name: "Caffeine"),
            ExcitedAboutOption(name: "Foodie")
        ]
    ),
    ExcitedAboutSection(
        name: "Geek",
        iconName: "gamecontroller.fill",
        options: [
            ExcitedAboutOption(name: "Gaming"),
            ExcitedAboutOption(name: "Puzzle"),
            ExcitedAboutOption(name: "Harry Potter"),
            ExcitedAboutOption(name: "Retro Gaming"),
            ExcitedAboutOption(name: "Manga & Anime"),
            ExcitedAboutOption(name: "Heroic Fantasy"),
            ExcitedAboutOption(name: "Chess mastermind"),
            ExcitedAboutOption(name: "YouTube"),
            ExcitedAboutOption(name: "Twitch"),
            ExcitedAboutOption(name: "Escape games"),
            ExcitedAboutOption(name: "Tamagotchi"),
            ExcitedAboutOption(name: "Comics lover"),
            ExcitedAboutOption(name: "Board games"),
            ExcitedAboutOption(name: "Cosplay"),
            ExcitedAboutOption(name: "Japanese Culture")
        ]
    ),
    ExcitedAboutSection(
        name: "Unspoken habits",
        iconName: "person.fill.questionmark",
        options: [
            ExcitedAboutOption(name: "Losing things"),
            ExcitedAboutOption(name: "Astral projecting"),
            ExcitedAboutOption(name: "Avoiding the news"),
            ExcitedAboutOption(name: "Road rage"),
            ExcitedAboutOption(name: "Small talk with strangers"),
            ExcitedAboutOption(name: "Reading one-star reviews"),
            ExcitedAboutOption(name: "Enjoying the smell of gas"),
            ExcitedAboutOption(name: "Wikipedia random articles"),
            ExcitedAboutOption(name: "Starting books I'll never finish"),
            ExcitedAboutOption(name: "TikTok trends specialist"),
            ExcitedAboutOption(name: "Forgetting peoples' names"),
            ExcitedAboutOption(name: "Overthinking"),
            ExcitedAboutOption(name: "Making lists"),
            ExcitedAboutOption(name: "Me, a hypochondriac?"),
            ExcitedAboutOption(name: "Opening too many tabs"),
            ExcitedAboutOption(name: "Looking at houses I can't afford"),
            ExcitedAboutOption(name: "Panic fear of spiders"),
            ExcitedAboutOption(name: "Sleeping on my stomach"),
            ExcitedAboutOption(name: "Uncontrollable cravings"),
            ExcitedAboutOption(name: "Internet rabbit holes")
        ]
    ),
    ExcitedAboutSection(
        name: "Movies & TV Shows",
        iconName: "tv.fill",
        options: [
            ExcitedAboutOption(name: "Re-runs of Friends"),
            ExcitedAboutOption(name: "Going to the movies solo"),
            ExcitedAboutOption(name: "Cinema outdoor"),
            ExcitedAboutOption(name: "Cooking shows"),
            ExcitedAboutOption(name: "Guessing the plot in 3s"),
            ExcitedAboutOption(name: "Reality shows"),
            ExcitedAboutOption(name: "Talking during the film"),
            ExcitedAboutOption(name: "Watching a series to fall asleep"),
            ExcitedAboutOption(name: "Documentaries fanatic"),
            ExcitedAboutOption(name: "Tell spoilers by accident"),
            ExcitedAboutOption(name: "HBO series"),
            ExcitedAboutOption(name: "Peer-to-peer"),
            ExcitedAboutOption(name: "Salty popcorn"),
            ExcitedAboutOption(name: "No trailers policy"),
            ExcitedAboutOption(name: "True crime"),
            ExcitedAboutOption(name: "Sweet popcorn"),
            ExcitedAboutOption(name: "Quoting movies"),
            ExcitedAboutOption(name: "Indie movies")
        ]
    ),
    ExcitedAboutSection(
        name: "Sport",
        iconName: "figure.run",
        options: [
            ExcitedAboutOption(name: "Bike rides"),
            ExcitedAboutOption(name: "Quidditch"),
            ExcitedAboutOption(name: "Skateboard"),
            ExcitedAboutOption(name: "Running"),
            ExcitedAboutOption(name: "Football"),
            ExcitedAboutOption(name: "Surf"),
            ExcitedAboutOption(name: "Swimming"),
            ExcitedAboutOption(name: "Climbing"),
            ExcitedAboutOption(name: "Yoga"),
            ExcitedAboutOption(name: "Formula 1"),
            ExcitedAboutOption(name: "Boxing"),
            ExcitedAboutOption(name: "Tennis"),
            ExcitedAboutOption(name: "Basketball"),
            ExcitedAboutOption(name: "Rugby"),
            ExcitedAboutOption(name: "Horse riding"),
            ExcitedAboutOption(name: "Gym clothes, no sport"),
            ExcitedAboutOption(name: "Dance"),
            ExcitedAboutOption(name: "Padel"),
            ExcitedAboutOption(name: "Hitting the gym"),
            ExcitedAboutOption(name: "Ski")
        ]
    ),
    ExcitedAboutSection(
       name: "Travel",
       iconName: "airplane",
       options: [
           ExcitedAboutOption(name: "Ecotourism"),
           ExcitedAboutOption(name: "Lost luggage"),
           ExcitedAboutOption(name: "1st in the boarding queue"),
           ExcitedAboutOption(name: "Hiking"),
           ExcitedAboutOption(name: "Hardcore vacation planner"),
           ExcitedAboutOption(name: "Backpacking"),
           ExcitedAboutOption(name: "Naturism"),
           ExcitedAboutOption(name: "City trip"),
           ExcitedAboutOption(name: "Van life"),
           ExcitedAboutOption(name: "Airport sprinter"),
           ExcitedAboutOption(name: "5-star-hotel"),
           ExcitedAboutOption(name: "Camping"),
           ExcitedAboutOption(name: "Viva Italia"),
           ExcitedAboutOption(name: "All-inclusive"),
           ExcitedAboutOption(name: "Road trip"),
           ExcitedAboutOption(name: "Staycation")
       ]
    ),
    ExcitedAboutSection(
       name: "In the city",
       iconName: "building.2.fill",
       options: [
           ExcitedAboutOption(name: "Architecture"),
           ExcitedAboutOption(name: "Always late"),
           ExcitedAboutOption(name: "Hosting dinner parties"),
           ExcitedAboutOption(name: "Movie theater"),
           ExcitedAboutOption(name: "Gigs"),
           ExcitedAboutOption(name: "Karaoke"),
           ExcitedAboutOption(name: "Funfair"),
           ExcitedAboutOption(name: "Costume parties"),
           ExcitedAboutOption(name: "Thrift stores"),
           ExcitedAboutOption(name: "Casino"),
           ExcitedAboutOption(name: "Photo"),
           ExcitedAboutOption(name: "Theater"),
           ExcitedAboutOption(name: "Rooftop"),
           ExcitedAboutOption(name: "Speakeasy"),
           ExcitedAboutOption(name: "Nightclub"),
           ExcitedAboutOption(name: "Sunday market"),
           ExcitedAboutOption(name: "Rave party"),
           ExcitedAboutOption(name: "Music festivals"),
           ExcitedAboutOption(name: "Museum"),
           ExcitedAboutOption(name: "Flea market"),
           ExcitedAboutOption(name: "Street art"),
           ExcitedAboutOption(name: "Exhibitions")
       ]
    )
]
