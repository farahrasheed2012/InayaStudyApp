import SwiftUI

struct ProblemVisualView: View {
    let visual: ProblemVisual

    var body: some View {
        switch visual {
        case .clockFace(let hour, let minute):
            ClockFaceView(hour: hour, minute: minute)
        case .coins(let coins):
            CoinRowView(coins: coins)
        case .numberLine(let min, let max, let marked):
            NumberLineView(rangeMin: min, rangeMax: max, marked: marked)
        case .array(let rows, let cols):
            ArrayGridView(rows: rows, cols: cols)
        case .fractionCircle(let num, let denom):
            FractionCircleView(numerator: num, denominator: denom)
        case .barGraph(let data):
            BarGraphView(data: data)
        case .rectangle(let width, let height):
            RectangleDiagramView(width: width, height: height)
        case .matterState(let state):
            MatterStateView(highlighted: state)
        case .foodChain(let producer, let herbivore, let carnivore):
            FoodChainView(producer: producer, herbivore: herbivore, carnivore: carnivore)
        case .lifeCycle(let kind, let stages):
            LifeCycleView(kind: kind, stages: stages)
        case .scienceTool(let name, let symbol):
            ScienceToolView(name: name, symbol: symbol)
        }
    }
}
