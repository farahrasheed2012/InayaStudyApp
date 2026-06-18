import Foundation
import SwiftData

// MARK: - Schema versions

/// Pre–Town/Terrarium builder schema (through Tier 1 games + compendium).
enum InayaSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            SessionRecord.self,
            TopicAccuracy.self,
            PracticeStreakData.self,
            DifficultyNudgeRecord.self,
            GameSession.self,
            GameBadge.self,
            DailyChallengeStreak.self,
            BossBattleState.self,
            CollectedCreature.self,
        ]
    }
}

/// Current schema — adds persistent builder state for Town / Terrarium games.
enum InayaSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        SwiftDataSchema.models
    }
}

enum InayaSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [InayaSchemaV1.self, InayaSchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: InayaSchemaV1.self,
        toVersion: InayaSchemaV2.self
    )
}

// MARK: - Container factory

enum SwiftDataStoreFactory {
    private static let recoveryAttemptedKey = "swiftdata.store.recoveryAttempted"

    static func makeContainer() throws -> ModelContainer {
        let schema = Schema(versionedSchema: InayaSchemaV2.self)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: InayaSchemaMigrationPlan.self,
                configurations: configuration
            )
        } catch {
            guard !UserDefaults.standard.bool(forKey: recoveryAttemptedKey) else {
                throw error
            }
            UserDefaults.standard.set(true, forKey: recoveryAttemptedKey)
            try deleteStoreFiles(for: configuration)
            return try ModelContainer(
                for: schema,
                migrationPlan: InayaSchemaMigrationPlan.self,
                configurations: configuration
            )
        }
    }

    private static func deleteStoreFiles(for configuration: ModelConfiguration) throws {
        let base = configuration.url
        let urls = [
            base,
            URL(fileURLWithPath: base.path + "-wal"),
            URL(fileURLWithPath: base.path + "-shm"),
        ]
        for url in urls where FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
