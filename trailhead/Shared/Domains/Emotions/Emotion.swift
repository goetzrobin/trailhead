//
//  Emotion.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

struct Emotion: Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: Color

    init(name: String, description: String, hex: String) {
        self.name = name
        self.description = description
        self.color = Color(hex: hex) ?? .gray
    }
}

extension Emotion {
    // Categories as static computed properties
    static var pleasantHighEnergy: [Emotion] {
        pleasantHighEnergyEmotions.flatMap {$0}
    }
    
    static var pleasantLowEnergy: [Emotion] {
        pleasantLowEnergyEmotions.flatMap {$0}
    }
    
    static var unpleasantHighEnergy: [Emotion] {
        unpleasantHighEnergyEmotions.flatMap {$0}
    }
    
    static var unpleasantLowEnergy: [Emotion] {
        unpleasantLowEnergyEmotions.flatMap {$0}
    }
    
    // All emotions combined and sorted by name
    static var all: [Emotion] {
        [
            pleasantHighEnergy,
            pleasantLowEnergy,
            unpleasantHighEnergy,
            unpleasantLowEnergy
        ]
        .flatMap { $0 }
        .sorted { $0.name < $1.name }
    }
}

// MARK: - Pleasant High Energy
let pleasantHighEnergyEmotions: [[Emotion]] = [
    [
        Emotion(
            name: "Surprised",
            description: "caught off guard by something unexpected or unusual",
            hex: "#FFA526"),
        Emotion(
            name: "Excited",
            description: "enthusiastic about something in the future",
            hex: "#FEB134"),
        Emotion(
            name: "Energized",
            description:
                "feeling like you are wide awake and ready to get up and go",
            hex: "#FCBE42"),
        Emotion(
            name: "Cheerful", description: "full of happy feelings",
            hex: "#FBCD51"),
        Emotion(
            name: "Pleasant", description: "feeling mostly positive",
            hex: "#F1D05C"),
        Emotion(
            name: "Pleased",
            description:
                "feeling content and happy about a particular situation or person",
            hex: "#F8E46D"),
    ],
    [
        Emotion(
            name: "Awe",
            description:
                "feeling like you are in the presence of something vast",
            hex: "#FFA91E"),
        Emotion(
            name: "Determined",
            description:
                "knowing what you want and not letting anything stand in the way",
            hex: "#FEB62C"),
        Emotion(
            name: "Eager",
            description: "impatiently waiting to do or get something",
            hex: "#FDC23A"),
        Emotion(
            name: "Curious", description: "interested in learning something",
            hex: "#FCD048"),
        Emotion(
            name: "Focused",
            description: "engaged in only one idea or activity", hex: "#FADC56"),
        Emotion(
            name: "Playful", description: "feeling happy and light hearted",
            hex: "#F9E964"),
    ],
    [
        Emotion(
            name: "Exhilarated",
            description: "in high spirits; cheerful and invigorated",
            hex: "#FFAC17"),
        Emotion(
            name: "Successful",
            description:
                "feeling like you've achieved something important to you",
            hex: "#FEBA24"),
        Emotion(
            name: "Enthusiastic",
            description: "highly interested in an idea or activity",
            hex: "#FDC732"),
        Emotion(
            name: "Upbeat", description: "feeling high energy and bubbly",
            hex: "#FCD340"),
        Emotion(
            name: "Alive", description: "filled with energy and vitality",
            hex: "#FAE04D"),
        Emotion(
            name: "Delighted", description: "feeling lifted by joy",
            hex: "#F9EF74"),
    ],
    [
        Emotion(
            name: "Thrilled",
            description: "feeling very excited all of the sudden",
            hex: "#FFB00F"),
        Emotion(
            name: "Amazed",
            description: "feeling lost in wonder about a particular event",
            hex: "#FFBD1D"),
        Emotion(
            name: "Joyful", description: "feeling pleasure and in high spirits",
            hex: "#FECB2A"),
        Emotion(
            name: "Happy", description: "very pleased and filled with joy",
            hex: "#FDD937"),
        Emotion(
            name: "Confident", description: "feeling sure of yourself",
            hex: "#FCE645"),
        Emotion(
            name: "Wishful", description: "having or showing a wish, longing",
            hex: "#FBF46F"),
    ],
    [
        Emotion(
            name: "Elated", description: "very joyful, proud, or enthusiastic",
            hex: "#FFB308"),
        Emotion(
            name: "Inspired",
            description:
                "affected powerfully by something in a way that motivated you to do something",
            hex: "#FFC115"),
        Emotion(
            name: "Productive",
            description:
                "feeling like you are accomplishing your tasks or achieving your goals",
            hex: "#FED022"),
        Emotion(
            name: "Motivated",
            description: "enthusiastic about doing something", hex: "#FEDD2F"),
        Emotion(
            name: "Engaged",
            description:
                "paying full attention or participating fully in something",
            hex: "#FBED60"),
        Emotion(
            name: "Hopeful",
            description: "optimistic that something good will happen",
            hex: "#FDFA6B"),
    ],
    [
        Emotion(
            name: "Ecstatic",
            description: "feeling the greatest amount of joy or happiness",
            hex: "#FFB700"),
        Emotion(
            name: "Empowered",
            description:
                "feeling stronger or more confident due to someone or something that happened",
            hex: "#FFC50D"),
        Emotion(
            name: "Proud",
            description:
                "pleased with your own achievements or those of someone close to you",
            hex: "#FFD41A"),
        Emotion(
            name: "Optimistic",
            description: "hopeful and confident about the future",
            hex: "#FFE226"),
        Emotion(
            name: "Challenged",
            description: "feeling pushed to reach a higher goal", hex: "#FDF15D"
        ),
        Emotion(
            name: "Accomplished",
            description: "feeling effective and successful", hex: "#FFFF67"),
    ],
]

// MARK: - Pleasant Low Energy

let pleasantLowEnergyEmotions: [[Emotion]] = [
    [
        Emotion(
            name: "Calm",
            description: "feeling free of stress, agitation, and worry",
            hex: "#94FFAD"),
        Emotion(
            name: "Good",
            description: "feeling positive, like things are just fine",
            hex: "#6FEBA8"),
        Emotion(
            name: "Relaxed",
            description: "feeling casual and restful in body and mind",
            hex: "#59F7BB"),
        Emotion(
            name: "Sympathetic",
            description: "feeling sorry or sorrowful for someone else",
            hex: "#3BF3C2"),
        Emotion(
            name: "Mellow", description: "relaxed and laid back; easygoing",
            hex: "#1EEFC9"),
        Emotion(
            name: "Carefree",
            description: "feeling free of worry and lighthearted",
            hex: "#00EBD0"),
    ],
    [
        Emotion(
            name: "At Ease", description: "feeling content and comfortable",
            hex: "#86FFA4"),
        Emotion(
            name: "Thoughtful",
            description:
                "being considerate or reflective about a situation (past, present, or future), oneself, or others",
            hex: "#6BFBA9"),
        Emotion(
            name: "Chill", description: "feeling relaxed and easygoing",
            hex: "#50F7AE"),
        Emotion(
            name: "Comfortable",
            description: "feeling reassured both in mind and body",
            hex: "#35F2B2"),
        Emotion(
            name: "Peaceful",
            description: "quiet and calm; free from disturbance", hex: "#1BEEB7"
        ),
        Emotion(
            name: "Tranquil", description: "peaceful, free from tension",
            hex: "#00EABB"),
    ],
    [
        Emotion(
            name: "Understood", description: "feeling that someone gets you",
            hex: "#78FF9C"),
        Emotion(
            name: "Appreciated", description: "feeling recognized and worthy",
            hex: "#60FB9E"),
        Emotion(
            name: "Compassionate",
            description: "showing care and concern for someone", hex: "#48F6A0"),
        Emotion(
            name: "Empathetic",
            description:
                "understanding and temporarily sharing the feelings of someone else, whether positive or negative (e.g., sharing in happiness or sorrow)",
            hex: "#30F2A2"),
        Emotion(
            name: "Balanced", description: "feeling stable and satisfied",
            hex: "#18EDA4"),
        Emotion(
            name: "Thankful", description: "feeling pleased and appreciative",
            hex: "#00E9A6"),
    ],
    [
        Emotion(
            name: "Respected",
            description: "feeling like people think highly of you",
            hex: "#93FC9D"),
        Emotion(
            name: "Supported",
            description: "feeling like someone is there for you", hex: "#87F79D"
        ),
        Emotion(
            name: "Included",
            description: "feeling like you're part of a group", hex: "#3FF693"),
        Emotion(
            name: "Content",
            description: "feeling complete and like you are enough",
            hex: "#2AF192"),
        Emotion(
            name: "Safe", description: "feeling protected from danger",
            hex: "#15ED92"),
        Emotion(
            name: "Relieved",
            description:
                "feeling at ease after an unpleasant feeling goes away",
            hex: "#05EE9C"),
    ],
    [
        Emotion(
            name: "Fulfilled",
            description:
                "feeling like you have accomplished important personal goals or have become the person you want to be",
            hex: "#8CFC97"),
        Emotion(
            name: "Loved",
            description: "feeling like someone cares deeply for you",
            hex: "#49FA88"),
        Emotion(
            name: "Valued", description: "feeling like you matter",
            hex: "#37F585"),
        Emotion(
            name: "Accepted", description: "feeling acknowledged and seen",
            hex: "#25F182"),
        Emotion(
            name: "Secure", description: "feeling safe and protected",
            hex: "#12EC7F"),
        Emotion(
            name: "Satisfied",
            description: "pleased with what you have or something you did",
            hex: "#00E77D"),
    ],
    [
        Emotion(
            name: "Blissful", description: "feeling full of joy", hex: "#86FB8F"
        ),
        Emotion(
            name: "Connected",
            description: "feeling close to someone or part of a community",
            hex: "#3EFA7D"),
        Emotion(
            name: "Grateful",
            description: "appreciative of something or someone", hex: "#3EFA7D"),
        Emotion(
            name: "Moved",
            description:
                "a sudden feeling that happens after seeing something inspirational or sad",
            hex: "#1FF072"),
        Emotion(
            name: "Blessed",
            description: "feeling thankful and fortunate for what you have",
            hex: "#0FEB6D"),
        Emotion(
            name: "Serene", description: "calm and peaceful; untroubled",
            hex: "#00E668"),
    ],
]
// MARK: - Unpleasant High Energy
let unpleasantHighEnergyEmotions: [[Emotion]] = [
    [
        Emotion(
            name: "Enraged",
            description: "made furious by something filled with extreme anger",
            hex: "#E61942"),
        Emotion(
            name: "Livid",
            description: "feeling furious about something or someone",
            hex: "#EB1E4D"),
        Emotion(
            name: "Furious", description: "full of extreme or wild anger",
            hex: "#F02357"),
        Emotion(
            name: "Jealous",
            description:
                "threatened that you're losing an important relationship to someone else",
            hex: "#F52962"),
        Emotion(
            name: "Envious",
            description:
                "feelings of desire for something that someone else has",
            hex: "#FA2E6C"),
        Emotion(
            name: "Contempt",
            description: "feeling a combination of anger and disgust",
            hex: "#FE3376"),
    ],
    [
        Emotion(
            name: "Terrified", description: "consumed by fear", hex: "#EB223F"),
        Emotion(
            name: "Irate",
            description: "feeling like your anger is almost out of control",
            hex: "#EF284A"),
        Emotion(
            name: "Frightened", description: "afraid or fearful", hex: "#F32F53"
        ),
        Emotion(
            name: "Scared",
            description:
                "perceiving threat or danger, whether physical or physiological",
            hex: "#F7365E"),
        Emotion(
            name: "Repulsed", description: "nauseated by someone or something",
            hex: "#EC3962"),
        Emotion(
            name: "Troubled",
            description: "feeling worried about a problem or conflict",
            hex: "#FF4473"),
    ],
    [
        Emotion(
            name: "Panicked",
            description: "feeling frantic and overcome by fear", hex: "#F02A3C"),
        Emotion(
            name: "Overwhelmed",
            description:
                "feeling like you have been taken over by strong feelings",
            hex: "#F33246"),
        Emotion(
            name: "Anxious",
            description: "worried and uneasy about an uncertain outcome",
            hex: "#F63B50"),
        Emotion(
            name: "Angry",
            description: "strongly bothered about a perceived injustice",
            hex: "#F63B50"),
        Emotion(
            name: "Frustrated",
            description: "upset because you cannot do something you want to do",
            hex: "#F9445A"),
        Emotion(
            name: "Worried",
            description: "troubled about actual or potential problems",
            hex: "#FF546E"),
    ],
    [
        Emotion(
            name: "Shocked",
            description: "experiencing extreme horror, disgust, and surprise",
            hex: "#F53339"),
        Emotion(
            name: "Stressed",
            description:
                "strained mentally or emotionally from too many demands and not enough resources",
            hex: "#F73D43"),
        Emotion(
            name: "Apprehensive",
            description: "unease and worry about something that might happen",
            hex: "#F9464C"),
        Emotion(
            name: "Jittery", description: "feeling on edge and jumpy",
            hex: "#FB5157"),
        Emotion(
            name: "Embarrassed",
            description:
                "self-conscious and uncomfortable about how you think others are perceiving you",
            hex: "#FD5B60"),
        Emotion(
            name: "Nervous",
            description:
                "jumpy and worried about the future or an uncertain event",
            hex: "#FF656A"),
    ],
    [
        Emotion(
            name: "Impassioned", description: "filled with lots of emotion",
            hex: "#FA3B36"),
        Emotion(
            name: "Annoyed",
            description: "bothered by something displeasing or uncomfortable",
            hex: "#FB473F"),
        Emotion(
            name: "Irritated",
            description: "slightly angry with or annoyed by an action or event",
            hex: "#FC5249"),
        Emotion(
            name: "Fomo", description: "fear of missing out", hex: "#FD5F53"),
        Emotion(
            name: "Concerned",
            description: "wondering if someone or something is okay",
            hex: "#FE6A5C"),
        Emotion(
            name: "Peeved", description: "slightly irritated about something",
            hex: "#FF7565"),
    ],
    [
        Emotion(
            name: "Hyper",
            description: "feeling energetic and like you want to move around",
            hex: "#FF4433"),
        Emotion(
            name: "Pressured",
            description: "feeling as if an important outcome depends on you",
            hex: "#FF513C"),
        Emotion(
            name: "Restless",
            description: "unable to relax due to anxiety or boredom",
            hex: "#FF5E45"),
        Emotion(
            name: "Confused",
            description: "feeling unable to make sense of something",
            hex: "#FF6C4F"),
        Emotion(name: "Tense", description: "unable to relax", hex: "#FF7958"),
        Emotion(
            name: "Uneasy", description: "vague sense that something is wrong",
            hex: "#FF8661"),
    ],
]
// MARK: - Unpleasant Low Energy
let unpleasantLowEnergyEmotions: [[Emotion]] = [
    [
        Emotion(
            name: "Disgusted",
            description: "feeling a strong dislike of someone or something",
            hex: "#718FFB"),
        Emotion(
            name: "Humiliated",
            description: "feeling exposed and foolish in front of others",
            hex: "#5A8DFC"),
        Emotion(
            name: "Pessimistic",
            description:
                "having a negative outlook and expecting the worst to happen",
            hex: "#448BFD"),
        Emotion(
            name: "Guilty",
            description: "feeling responsible for a specific wording",
            hex: "#2D89FD"),
        Emotion(
            name: "Depressed", description: "extremely unhappy and dispirited",
            hex: "#1787FE"),
        Emotion(
            name: "Miserable", description: "feeling absolutely awful",
            hex: "#0085FF"),
    ],
    [
        Emotion(
            name: "Trapped", description: "feeling like there's no way out",
            hex: "#749DFC"),
        Emotion(
            name: "Ashamed",
            description:
                "feeling lower self-worth as a result of who you are or what you did",
            hex: "#5C9BFD"),
        Emotion(
            name: "Vulnerable",
            description:
                "feeling like you could easily be emotionally or mentally hurt",
            hex: "#4699FD"),
        Emotion(
            name: "Numb",
            description:
                "dampening or loss of sensitivity of feelings, with a hint of a negative mood",
            hex: "#2E97FD"),
        Emotion(
            name: "Hopeless",
            description:
                "feel completely defeated and in despair about the future",
            hex: "#1895FE"),
        Emotion(
            name: "Despair", description: "a feeling of complete hopelessness",
            hex: "#0092FF"),
    ],
    [
        Emotion(
            name: "Insecure",
            description: "feeling uncertain and unconfident about yourself",
            hex: "#77ABFD"),
        Emotion(
            name: "Lost",
            description: "feeling uncomfortably alone and lacking direction",
            hex: "#5FA9FD"),
        Emotion(
            name: "Disconnected", description: "feeling separate from others",
            hex: "#48A7FE"),
        Emotion(
            name: "Excluded",
            description: "feeling left out and unwanted from a desired group",
            hex: "#2FA4FE"),
        Emotion(
            name: "Alienated",
            description:
                "feeling like you have been made a stranger to others, like they have no feelings or affection towards you",
            hex: "#18A2FE"),
        Emotion(
            name: "Glum",
            description: "feeling displeased; pessimistic about future events",
            hex: "#00A0FF"),
    ],
    [
        Emotion(
            name: "Disheartened",
            description: "loss of resolve or determination", hex: "#7AB9FD"),
        Emotion(
            name: "Disappointed",
            description: "sad because your expectations were not met",
            hex: "#61B6FE"),
        Emotion(
            name: "Forlorn", description: "feeling both sad and alone",
            hex: "#49B4FE"),
        Emotion(
            name: "Spent",
            description: "feeling extremely exhausted, both in body and mind",
            hex: "#31B2FE"),
        Emotion(
            name: "Nostalgic",
            description:
                "a sentimental longing for the happiness felt in former place, time or situation",
            hex: "#19B0FF"),
        Emotion(
            name: "Burned Out",
            description: "feeling exhausted from ongoing stress", hex: "#00ADFF"
        ),
    ],
    [
        Emotion(
            name: "Down",
            description: "feeling sad and like you have little energy",
            hex: "#7DC7FE"),
        Emotion(
            name: "Meh", description: "feeling uninspired or blah",
            hex: "#64C4FE"),
        Emotion(
            name: "Sad", description: "feeling unhappy about something",
            hex: "#4BC2FF"),
        Emotion(
            name: "Discouraged",
            description: "feeling a loss of confidence and enthusiasm",
            hex: "#32BFFF"),
        Emotion(
            name: "Lonely",
            description: "feeling sad because you are alone or disconnected",
            hex: "#19BDFF"),
        Emotion(
            name: "Exhausted", description: "feeling depleted of all energy",
            hex: "#00BBFF"),
    ],
    [
        Emotion(
            name: "Bored",
            description: "lacking interest in something or someone",
            hex: "#80D5FF"),
        Emotion(
            name: "Tired", description: "feeling like you need to rest",
            hex: "#66D2FF"),
        Emotion(
            name: "Fatigued", description: "feeling physically drained",
            hex: "#4DD0FF"),
        Emotion(
            name: "Disengaged",
            description: "feeling like you cannot focus; disinterested",
            hex: "#33CDFF"),
        Emotion(
            name: "Apathetic", description: "lacking enthusiasm or interest",
            hex: "#1ACBFF"),
        Emotion(
            name: "Helpless",
            description: "feeling like there's nothing you can do",
            hex: "#00C8FF"),
    ],
]
