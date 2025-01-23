struct PromptCategory: Identifiable {
    var id: String { name }
    let name: String
    let options: [PromptOption]
}

let PROMPT_CATEGORIES: [PromptCategory] = [
    PromptCategory(
        name: "Identity & Growth",
        options: [
            PromptOption(prompt: "Recently, I discovered about myself that"),
            PromptOption(prompt: "Outside of my sport, I'm passionate about"),
            PromptOption(prompt: "A skill I'm proud of developing is"),
            PromptOption(prompt: "Something that makes me unique beyond athletics is"),
            PromptOption(prompt: "This year, I want to explore"),
            PromptOption(prompt: "A value that defines me is"),
            PromptOption(prompt: "My definition of success is"),
            PromptOption(prompt: "Something I want to be known for besides athletics is"),
            PromptOption(prompt: "A new interest I'm curious about is"),
            PromptOption(prompt: "The kind of leader I aspire to be is"),
        ]
    ),
    PromptCategory(
        name: "Mental Well-being",
        options: [
            PromptOption(prompt: "When I need to recharge, I"),
            PromptOption(prompt: "A self-care practice that works for me is"),
            PromptOption(prompt: "I feel most balanced when"),
            PromptOption(prompt: "Something I'm learning about my mental health is"),
            PromptOption(prompt: "My go-to stress management technique is"),
            PromptOption(prompt: "A boundary I'm working on setting is"),
            PromptOption(prompt: "I feel most supported when"),
            PromptOption(prompt: "Something I'm proud of overcoming is"),
            PromptOption(prompt: "My strategy for tough days is"),
            PromptOption(prompt: "A mindset shift that helped me was"),
        ]
    ),
    PromptCategory(
        name: "Future Vision",
        options: [
            PromptOption(prompt: "In five years, I see myself"),
            PromptOption(prompt: "A career path I'm curious about is"),
            PromptOption(prompt: "Skills from my sport that will help me succeed are"),
            PromptOption(prompt: "Something I want to learn more about is"),
            PromptOption(prompt: "My biggest dream beyond athletics is"),
            PromptOption(prompt: "A professional goal I'm working toward is"),
            PromptOption(prompt: "An industry I'd like to explore is"),
            PromptOption(prompt: "The impact I want to make is"),
            PromptOption(prompt: "A mentor I'd love to connect with would be"),
            PromptOption(prompt: "My plan for personal growth includes"),
        ]
    ),
    PromptCategory(
        name: "Team & Community",
        options: [
            PromptOption(prompt: "What I value most in my teammates is"),
            PromptOption(prompt: "A way I contribute to my team culture is"),
            PromptOption(prompt: "Something I learned from a teammate is"),
            PromptOption(prompt: "A team experience that shaped me was"),
            PromptOption(prompt: "How I help build team chemistry"),
            PromptOption(prompt: "A leadership lesson I've learned is"),
            PromptOption(prompt: "Ways I want to give back to my community are"),
            PromptOption(prompt: "The type of mentor I hope to become is"),
            PromptOption(prompt: "A tradition I want to start is"),
            PromptOption(prompt: "How I want to inspire others is"),
        ]
    ),
    PromptCategory(
        name: "Life Skills",
        options: [
            PromptOption(prompt: "A time management strategy that works for me is"),
            PromptOption(prompt: "My approach to balancing academics and athletics is"),
            PromptOption(prompt: "A financial goal I'm working toward is"),
            PromptOption(prompt: "Something I'm learning about leadership is"),
            PromptOption(prompt: "A professional skill I'm developing is"),
            PromptOption(prompt: "My strategy for networking is"),
            PromptOption(prompt: "A challenge I'm working to overcome is"),
            PromptOption(prompt: "How I organize my priorities"),
            PromptOption(prompt: "A lesson about resilience I've learned is"),
            PromptOption(prompt: "My approach to problem-solving is"),
        ]
    ),
    PromptCategory(
        name: "Growth Stories",
        options: [
            PromptOption(prompt: "A defining moment in my journey was"),
            PromptOption(prompt: "The biggest risk I took that paid off"),
            PromptOption(prompt: "A failure that taught me something important"),
            PromptOption(prompt: "A time I surprised myself was"),
            PromptOption(prompt: "Something I'm proud of achieving is"),
            PromptOption(prompt: "A challenge that made me stronger"),
            PromptOption(prompt: "An unexpected lesson I learned was"),
            PromptOption(prompt: "A time I stepped out of my comfort zone"),
            PromptOption(prompt: "A moment that changed my perspective"),
            PromptOption(prompt: "The most valuable advice I've received"),
        ]
    ),
    PromptCategory(
        name: "Discussion Starters",
        options: [
            PromptOption(prompt: "I'd love advice about"),
            PromptOption(prompt: "Something I'm trying to figure out is"),
            PromptOption(prompt: "A goal I could use support with is"),
            PromptOption(prompt: "I'm curious to learn more about"),
            PromptOption(prompt: "A challenge I'd like to discuss is"),
            PromptOption(prompt: "Something I'm excited to work on is"),
            PromptOption(prompt: "A decision I'm weighing is"),
            PromptOption(prompt: "An area where I'd like guidance is"),
            PromptOption(prompt: "A skill I want to develop is"),
            PromptOption(prompt: "Something I want to understand better is"),
        ]
    ),
]
