//
//  SurveyData.swift
//  trailhead
//
//  Created by Robin Götz on 2/24/25.
//
// This is where we define our survey data
struct SurveyData {
    // Likert scale answers (1-5)
    static let likertAnswers: [SurveyPossibleAnswer] = [
        SurveyPossibleAnswer(type: .fixed, value: 1, label: "Strongly Disagree"),
        SurveyPossibleAnswer(type: .fixed, value: 2, label: "Disagree"),
        SurveyPossibleAnswer(type: .fixed, value: 3, label: "Neither agree nor disagree"),
        SurveyPossibleAnswer(type: .fixed, value: 4, label: "Agree"),
        SurveyPossibleAnswer(type: .fixed, value: 5, label: "Strongly Agree")
    ]
    
    // Career Identity Confusion Survey
    static let careerIdentityConfusionSurvey = Survey(
        type: .careerIdentity,
        questions: [
            SurveyQuestion(
                index: 0,
                possibleAnswers: likertAnswers,
                question: "I feel confused as to who I really am when it comes to my career path",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 1,
                possibleAnswers: likertAnswers,
                question: "I am uncertain about the kind of work I could perform well",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 2,
                possibleAnswers: likertAnswers,
                question: "Deciding on a career makes me feel anxious",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 3,
                possibleAnswers: likertAnswers,
                question: "I often feel lost when I think about choosing a career because I don't have enough information and/or experience to make a career decision at this point",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 4,
                possibleAnswers: likertAnswers,
                question: "Trying to find a satisfying career is stressful because there are so many things to consider",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 5,
                possibleAnswers: likertAnswers,
                question: "Being unsure about what kind of career I would enjoy worries me",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 6,
                possibleAnswers: likertAnswers,
                question: "I have doubts that I will be able to find a career that I'm satisfied with",
                type: .multipleChoice,
                direction: .smallerBetter
            ),
            SurveyQuestion(
                index: 7,
                possibleAnswers: likertAnswers,
                question: "I have no clear sense of a career direction that would be meaningful to me",
                type: .multipleChoice,
                direction: .smallerBetter
            )
        ],
        answers: Array(repeating: SurveyActualAnswer(type: .fixed, value: 3, customValue: nil), count: 8)
    )
    
    // Career Exploration Breadth Self Survey
    static let careerExplorationBreadthSelfSurvey = Survey(
        type: .careerExploration,
        questions: [
            SurveyQuestion(
                index: 0,
                possibleAnswers: likertAnswers,
                question: "I like to learn about myself for the purpose of finding a career that meets my needs",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 1,
                possibleAnswers: likertAnswers,
                question: "I reflect on how my past could integrate with various career alternatives",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 2,
                possibleAnswers: likertAnswers,
                question: "I think about which career options would be a good fit with my personality and values",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 3,
                possibleAnswers: likertAnswers,
                question: "I reflect on how my strengths and abilities could be best used in a variety of careers",
                type: .multipleChoice,
                direction: .biggerBetter
            )
        ],
        answers: Array(repeating: SurveyActualAnswer(type: .fixed, value: 3, customValue: nil), count: 4)
    )
    
    // Career Exploration Depth Self Survey
    static let careerExplorationDepthSelfSurvey = Survey(
        type: .careerDepth,
        questions: [
            SurveyQuestion(
                index: 0,
                possibleAnswers: likertAnswers,
                question: "I reflect on how my chosen career path aligns with my past experiences",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 1,
                possibleAnswers: likertAnswers,
                question: "I contemplate what I value most in my desired career",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 2,
                possibleAnswers: likertAnswers,
                question: "I contemplate how the work I want to do is congruent with my interests and personality",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 3,
                possibleAnswers: likertAnswers,
                question: "I reflect on how my strengths and abilities could be best used in my desired career",
                type: .multipleChoice,
                direction: .biggerBetter
            )
        ],
        answers: Array(repeating: SurveyActualAnswer(type: .fixed, value: 3, customValue: nil), count: 4)
    )
    
    // Career Commitment Quality Survey
    static let careerCommitmentQualitySurvey = Survey(
        type: .careerCommitment,
        questions: [
            SurveyQuestion(
                index: 0,
                possibleAnswers: likertAnswers,
                question: "My career of interest is one of the most important aspects of my life",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 1,
                possibleAnswers: likertAnswers,
                question: "I can say that I have found my purpose in life through my career of interest",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 2,
                possibleAnswers: likertAnswers,
                question: "My career of interest gives meaning to my life",
                type: .multipleChoice,
                direction: .biggerBetter
            ),
            SurveyQuestion(
                index: 3,
                possibleAnswers: likertAnswers,
                question: "My career plans match my true interests and values",
                type: .multipleChoice,
                direction: .biggerBetter
            )
        ],
        answers: Array(repeating: SurveyActualAnswer(type: .fixed, value: 3, customValue: nil), count: 4)
    )
}
