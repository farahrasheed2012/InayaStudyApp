import Foundation
import SwiftData

@MainActor
final class BuilderStore: ObservableObject {
    private let modelContext: ModelContext

    @Published private(set) var revision = 0

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Town

    func townState(grade: Grade) -> TownBuildState {
        let key = "town-\(grade.rawValue)"
        if let existing = fetchTown(key: key) { return existing }
        let row = TownBuildState(key: key)
        modelContext.insert(row)
        save()
        return row
    }

    func addTownMaterials(grade: Grade, lumber: Int, bricks: Int, glass: Int) {
        let state = townState(grade: grade)
        state.lumber += lumber
        state.bricks += bricks
        state.glass += glass
        state.lastUpdated = .now
        save()
    }

    func placeTownBuilding(grade: Grade, buildingID: String) -> Bool {
        guard let building = GameContent.townBuildings.first(where: { $0.id == buildingID }) else { return false }
        let state = townState(grade: grade)
        guard state.lumber >= building.lumber,
              state.bricks >= building.bricks,
              state.glass >= building.glass else { return false }
        state.lumber -= building.lumber
        state.bricks -= building.bricks
        state.glass -= building.glass
        var placed = state.placedBuildings
        placed.append(buildingID)
        state.placedBuildings = placed
        state.lastUpdated = .now
        save()
        return true
    }

    // MARK: - Terrarium

    func terrariumState(grade: Grade) -> TerrariumBuildState {
        let key = "terrarium-\(grade.rawValue)"
        if let existing = fetchTerrarium(key: key) { return existing }
        let row = TerrariumBuildState(key: key)
        modelContext.insert(row)
        save()
        return row
    }

    func addTerrariumInventory(grade: Grade, plants: Int, animals: Int, terrain: Int) {
        let state = terrariumState(grade: grade)
        state.plants += plants
        state.animals += animals
        state.terrain += terrain
        state.lastUpdated = .now
        save()
    }

    func placeTerrariumItem(grade: Grade, pieceID: String) -> Bool {
        guard let piece = GameContent.terrariumPieces.first(where: { $0.id == pieceID }) else { return false }
        let state = terrariumState(grade: grade)
        switch piece.kind {
        case "producer":
            guard state.plants > 0 else { return false }
            state.plants -= 1
        case "consumer":
            guard state.animals > 0 else { return false }
            state.animals -= 1
        default:
            guard state.terrain > 0 else { return false }
            state.terrain -= 1
        }
        var placed = state.placedItems
        placed.append(pieceID)
        state.placedItems = placed
        state.lastUpdated = .now
        save()
        return true
    }

    func terrariumIsBalanced(grade: Grade) -> Bool {
        let state = terrariumState(grade: grade)
        let items = state.placedItems
        guard items.count >= 3 else { return false }
        let producers = items.filter { id in GameContent.terrariumPieces.first { $0.id == id }?.kind == "producer" }.count
        let consumers = items.filter { id in GameContent.terrariumPieces.first { $0.id == id }?.kind == "consumer" }.count
        let terrain = items.filter { id in GameContent.terrariumPieces.first { $0.id == id }?.kind == "terrain" }.count
        return producers >= 1 && consumers >= 1 && terrain >= 1 && producers >= consumers
    }

    // MARK: - Private

    private func fetchTown(key: String) -> TownBuildState? {
        var descriptor = FetchDescriptor<TownBuildState>(predicate: #Predicate { $0.key == key })
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }

    private func fetchTerrarium(key: String) -> TerrariumBuildState? {
        var descriptor = FetchDescriptor<TerrariumBuildState>(predicate: #Predicate { $0.key == key })
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }

    private func save() {
        try? modelContext.save()
        revision += 1
    }
}
