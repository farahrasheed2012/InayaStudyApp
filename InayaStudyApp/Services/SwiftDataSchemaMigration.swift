import Foundation
import SwiftData
import os

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
    private static let logger = Logger(subsystem: "com.inaya.studyapp", category: "SwiftData")
    private static let storeFileName = "InayaStudy.store"

    static func makeContainer() throws -> ModelContainer {
        let schema = Schema(versionedSchema: InayaSchemaV2.self)

        do {
            return try openPersistentContainer(schema: schema)
        } catch {
            logger.error("Persistent SwiftData store failed to open: \(String(describing: error), privacy: .public)")
            try deleteAllKnownStoreFiles()
            do {
                return try openPersistentContainer(schema: schema)
            } catch {
                logger.error("SwiftData store failed after reset; using in-memory store: \(String(describing: error), privacy: .public)")
                return try inMemoryContainer(schema: schema)
            }
        }
    }

    private static func openPersistentContainer(schema: Schema) throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            url: persistentStoreURL(),
            allowsSave: true
        )
        return try ModelContainer(
            for: schema,
            migrationPlan: InayaSchemaMigrationPlan.self,
            configurations: configuration
        )
    }

    private static func inMemoryContainer(schema: Schema) throws -> ModelContainer {
        try ModelContainer(
            for: schema,
            migrationPlan: InayaSchemaMigrationPlan.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    private static func persistentStoreURL() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent(storeFileName, isDirectory: false)
    }

    /// Removes the current store and legacy unversioned `default.store` files.
    private static func deleteAllKnownStoreFiles() throws {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bases = [
            persistentStoreURL(),
            appSupport.appendingPathComponent("default.store", isDirectory: false),
        ]
        for base in bases {
            try deleteStoreFamily(at: base)
        }
    }

    private static func deleteStoreFamily(at base: URL) throws {
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
