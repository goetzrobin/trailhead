import Foundation

struct PromptCategory: Identifiable {
    let id: UUID
    let name: String
    let options: [PromptOption]
}

let PROMPT_CATEGORIES: [PromptCategory] = [
    PromptCategory(
        id: UUID(uuidString: "01234567-89ab-cdef-0123-456789abcdef")!,
        name: "Identity & Growth",
        options: [
            PromptOption(id: UUID(uuidString: "53d235ad-484e-41b1-8234-d739dc98267a")!, prompt: "Recently, I discovered about myself that"),
            PromptOption(id: UUID(uuidString: "efb96550-f418-4adb-965b-0f11cb898cbd")!, prompt: "Outside of my sport, I'm passionate about"),
            PromptOption(id: UUID(uuidString: "5621c89d-d345-4a08-8278-f5378e41ccae")!, prompt: "A skill I'm proud of developing is"),
            PromptOption(id: UUID(uuidString: "7c019048-08e0-4568-a79b-77d46a512cfa")!, prompt: "Something that makes me unique beyond athletics is"),
            PromptOption(id: UUID(uuidString: "1730b92e-fc01-4ed0-ae4b-ecd5535add46")!, prompt: "This year, I want to explore"),
            PromptOption(id: UUID(uuidString: "7bfbfc52-380a-4d9d-b2aa-e0770880e52a")!, prompt: "A value that defines me is"),
            PromptOption(id: UUID(uuidString: "11d0e1ef-92b9-4f33-ba19-91eec543991f")!, prompt: "My definition of success is"),
            PromptOption(id: UUID(uuidString: "43a56010-50cf-4e70-9d59-2a17b633b92e")!, prompt: "Something I want to be known for besides athletics is"),
            PromptOption(id: UUID(uuidString: "5f0fba6e-04b2-406b-afe0-8ecc514aca2e")!, prompt: "A new interest I'm curious about is"),
            PromptOption(id: UUID(uuidString: "886c1ba3-fdf1-4a73-a8ba-75a5028a6be8")!, prompt: "The kind of leader I aspire to be is"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "11234567-89ab-cdef-0123-456789abcdef")!,
        name: "Mental Well-being",
        options: [
            PromptOption(id: UUID(uuidString: "4fcc3d09-47c2-4d02-b60c-d5e41da12bcb")!, prompt: "When I need to recharge, I"),
            PromptOption(id: UUID(uuidString: "dde0a570-8f77-47ac-beff-d0b9a42085aa")!, prompt: "A self-care practice that works for me is"),
            PromptOption(id: UUID(uuidString: "054d45a3-fc09-46f6-b88a-df833ede0af7")!, prompt: "I feel most balanced when"),
            PromptOption(id: UUID(uuidString: "e5d44b1a-a7d8-44a3-8dbb-06018eeeb888")!, prompt: "Something I'm learning about my mental health is"),
            PromptOption(id: UUID(uuidString: "95199fcb-08f5-4574-b642-ed903e7b3152")!, prompt: "My go-to stress management technique is"),
            PromptOption(id: UUID(uuidString: "cd19b602-666c-4dc8-9ec9-ad0d52a370e0")!, prompt: "A boundary I'm working on setting is"),
            PromptOption(id: UUID(uuidString: "5a9fcc13-2835-410a-99c9-df02e6ed2a80")!, prompt: "I feel most supported when"),
            PromptOption(id: UUID(uuidString: "331c9620-f506-478f-93e5-87e385ca2f33")!, prompt: "Something I'm proud of overcoming is"),
            PromptOption(id: UUID(uuidString: "f4d25107-2283-48d0-95b1-f7a74fdcaf12")!, prompt: "My strategy for tough days is"),
            PromptOption(id: UUID(uuidString: "380b1422-91c8-4f55-842f-9f31503215b5")!, prompt: "A mindset shift that helped me was"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "21234567-89ab-cdef-0123-456789abcdef")!,
        name: "Future Vision",
        options: [
            PromptOption(id: UUID(uuidString: "ba65c386-54c6-4b0f-81e5-43395e4cf57d")!, prompt: "In five years, I see myself"),
            PromptOption(id: UUID(uuidString: "ddfa1981-6483-4d2e-829f-69a9d6adafd2")!, prompt: "A career path I'm curious about is"),
            PromptOption(id: UUID(uuidString: "7ecd9e4a-9680-4973-84c0-ba2e37010d95")!, prompt: "Skills from my sport that will help me succeed are"),
            PromptOption(id: UUID(uuidString: "a337eda1-bdb0-4a58-8b74-6280894ca0af")!, prompt: "Something I want to learn more about is"),
            PromptOption(id: UUID(uuidString: "60bfe4aa-1c8d-4c05-89d0-efd0d73a5471")!, prompt: "My biggest dream beyond athletics is"),
            PromptOption(id: UUID(uuidString: "4c501f4b-efa6-46d5-87d5-f7ca1b87688b")!, prompt: "A professional goal I'm working toward is"),
            PromptOption(id: UUID(uuidString: "e1b69998-2ae9-4b1c-a30b-6125cf1b9f2c")!, prompt: "An industry I'd like to explore is"),
            PromptOption(id: UUID(uuidString: "5bba9d9e-5820-4a5e-884d-570115bf7371")!, prompt: "The impact I want to make is"),
            PromptOption(id: UUID(uuidString: "f755b50b-6dd6-4a32-818f-08e0f11bb6af")!, prompt: "A mentor I'd love to connect with would be"),
            PromptOption(id: UUID(uuidString: "e9af8b1f-66ae-4018-85bb-91aa53c81bc9")!, prompt: "My plan for personal growth includes"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "31234567-89ab-cdef-0123-456789abcdef")!,
        name: "Team & Community",
        options: [
            PromptOption(id: UUID(uuidString: "17b27d9f-1332-4431-a5bc-8d1ec348f832")!, prompt: "What I value most in my teammates is"),
            PromptOption(id: UUID(uuidString: "e21402bf-4f6f-40f0-a313-8f72b049b09a")!, prompt: "A way I contribute to my team culture is"),
            PromptOption(id: UUID(uuidString: "05cbf4bd-bcb7-4e62-a0b7-5081253deb28")!, prompt: "Something I learned from a teammate is"),
            PromptOption(id: UUID(uuidString: "19b503dc-ef4b-4656-97cd-ff8bee96fc96")!, prompt: "A team experience that shaped me was"),
            PromptOption(id: UUID(uuidString: "1694926e-f7b8-4e76-ada9-c2d5c05a270c")!, prompt: "How I help build team chemistry"),
            PromptOption(id: UUID(uuidString: "d0735567-13d6-47c9-946a-9be7a720c36f")!, prompt: "A leadership lesson I've learned is"),
            PromptOption(id: UUID(uuidString: "2699ddf7-9293-4d37-84f4-280b191e93e2")!, prompt: "Ways I want to give back to my community are"),
            PromptOption(id: UUID(uuidString: "e65b887e-38ba-43b6-9971-38f2aa7df9e9")!, prompt: "The type of mentor I hope to become is"),
            PromptOption(id: UUID(uuidString: "be2390b2-af2c-4753-9e04-6c7272839f86")!, prompt: "A tradition I want to start is"),
            PromptOption(id: UUID(uuidString: "c1e2f3b0-b238-46e0-9dc1-d0bbcad97df8")!, prompt: "How I want to inspire others is"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "41234567-89ab-cdef-0123-456789abcdef")!,
        name: "Life Skills",
        options: [
            PromptOption(id: UUID(uuidString: "2baa27a2-fd27-47e2-af21-63b62f812759")!, prompt: "A time management strategy that works for me is"),
            PromptOption(id: UUID(uuidString: "6faf72f5-7985-4f2c-956d-771e595ba8ff")!, prompt: "My approach to balancing academics and athletics is"),
            PromptOption(id: UUID(uuidString: "1ee80fef-fb40-4d08-aec7-2240e1638c46")!, prompt: "A financial goal I'm working toward is"),
            PromptOption(id: UUID(uuidString: "b5f1de20-07e8-4d53-84ed-9fa755631976")!, prompt: "Something I'm learning about leadership is"),
            PromptOption(id: UUID(uuidString: "b797ceda-cf87-41a8-a21c-2f07fcd06fa7")!, prompt: "A professional skill I'm developing is"),
            PromptOption(id: UUID(uuidString: "1287a9af-a43d-4fee-8551-7773b3d43e2e")!, prompt: "My strategy for networking is"),
            PromptOption(id: UUID(uuidString: "6f69ff2a-c6dc-4abe-a98c-1b3ed8ca7ef9")!, prompt: "A challenge I'm working to overcome is"),
            PromptOption(id: UUID(uuidString: "bbccf5c0-bba4-480a-ac54-8de1b5f24de2")!, prompt: "How I organize my priorities"),
            PromptOption(id: UUID(uuidString: "8452fea2-ce7d-4cb2-a303-c13f3a858126")!, prompt: "A lesson about resilience I've learned is"),
            PromptOption(id: UUID(uuidString: "21ee3349-eeee-4ab7-85f0-ce7061f8ff28")!, prompt: "My approach to problem-solving is"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "51234567-89ab-cdef-0123-456789abcdef")!,
        name: "Growth Stories",
        options: [
            PromptOption(id: UUID(uuidString: "3d9913ed-5250-4448-af3a-71ade7483e1f")!, prompt: "A defining moment in my journey was"),
            PromptOption(id: UUID(uuidString: "0684d909-08e2-4d63-b78a-167350914dea")!, prompt: "The biggest risk I took that paid off"),
            PromptOption(id: UUID(uuidString: "e2924828-1015-4acb-9e46-ae97c3876b41")!, prompt: "A failure that taught me something important"),
            PromptOption(id: UUID(uuidString: "a96514d7-0969-466c-a74e-5c092df2bc0d")!, prompt: "A time I surprised myself was"),
            PromptOption(id: UUID(uuidString: "0403c88f-1a5e-4092-a308-b14a469645b7")!, prompt: "Something I'm proud of achieving is"),
            PromptOption(id: UUID(uuidString: "0e71236e-98a3-4361-aba9-6383ec54b522")!, prompt: "A challenge that made me stronger"),
            PromptOption(id: UUID(uuidString: "9540c0bc-ac71-48a2-b668-e96f5d677b60")!, prompt: "An unexpected lesson I learned was"),
            PromptOption(id: UUID(uuidString: "0d5b7c3b-b37f-4fb5-b4ca-7564a525d062")!, prompt: "A time I stepped out of my comfort zone"),
            PromptOption(id: UUID(uuidString: "669345a7-4359-4c5d-a58a-6cbfc5e8cac9")!, prompt: "A moment that changed my perspective"),
            PromptOption(id: UUID(uuidString: "d57b7f61-cb86-48a1-a86c-5e486112f272")!, prompt: "The most valuable advice I've received"),
        ]
    ),
    PromptCategory(
        id: UUID(uuidString: "61234567-89ab-cdef-0123-456789abcdef")!,
        name: "Discussion Starters",
        options: [
            PromptOption(id: UUID(uuidString: "5d544c16-adf6-40a3-a8fc-417cfb269aee")!, prompt: "I'd love advice about"),
            PromptOption(id: UUID(uuidString: "0d6fd9cc-bf6d-498b-bdca-317e5e158196")!, prompt: "Something I'm trying to figure out is"),
            PromptOption(id: UUID(uuidString: "c841a61a-54ab-4007-b16f-b426988e472f")!, prompt: "A goal I could use support with is"),
            PromptOption(id: UUID(uuidString: "87c780d0-5414-4ada-a3a6-93ab7b619abd")!, prompt: "I'm curious to learn more about"),
            PromptOption(id: UUID(uuidString: "00a91314-39b9-470a-938b-f1fdee8efc44")!, prompt: "A challenge I'd like to discuss is"),
            PromptOption(id: UUID(uuidString: "231e3baa-4f74-4c4a-83e8-28532be85f81")!, prompt: "Something I'm excited to work on is"),
            PromptOption(id: UUID(uuidString: "f870bcf6-253c-4c0e-b59c-33d15ed62548")!, prompt: "A decision I'm weighing is"),
            PromptOption(id: UUID(uuidString: "afcf4b9b-7abd-4970-a61b-497c6106fd20")!, prompt: "An area where I'd like guidance is"),
            PromptOption(id: UUID(uuidString: "65f5e135-a76a-45e8-b5cc-3cfcc55407ee")!, prompt: "A skill I want to develop is"),
            PromptOption(id: UUID(uuidString: "7801f969-2561-4b4c-85e7-9128a1069f5b")!, prompt: "Something I want to understand better is"),
        ]
    ),
]
