//
//  SurveyTask.swift
//  Mathys
//
//  Created by ingeborg ødegård oftedal on 15/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    // INSTRUCTION STEP
    let instructionStep = ORKInstructionStep(identifier: Identifier.IntroStep.rawValue)
    instructionStep.title = "SURVEYINSTRUCTIONSTEP_TITLE".localized
    instructionStep.text = "SURVEYINSTRUCTIONSTEP_TEXT".localized
    steps += [instructionStep]

    return ORKOrderedTask(identifier: Identifier.SurveyTask.rawValue, steps: steps)

}
