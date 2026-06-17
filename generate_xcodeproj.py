#!/usr/bin/env python3
"""Generate InayaStudyApp.xcodeproj/project.pbxproj."""

from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT / "InayaStudyApp.xcodeproj" / "project.pbxproj"
DISPLAY_NAME = "Inaya Study App"

SOURCES = [
    "InayaStudyApp/InayaStudyAppApp.swift",
    "InayaStudyApp/Models/Topic.swift",
    "InayaStudyApp/Models/PersistenceModels.swift",
    "InayaStudyApp/Data/TopicRegistry.swift",
    "InayaStudyApp/Services/ProblemGenerator.swift",
    "InayaStudyApp/Services/ScienceProblemGenerator.swift",
    "InayaStudyApp/Services/ProgressStore.swift",
    "InayaStudyApp/Services/SettingsStore.swift",
    "InayaStudyApp/ViewModels/QuizViewModel.swift",
    "InayaStudyApp/Helpers/Theme.swift",
    "InayaStudyApp/Helpers/Encouragement.swift",
    "InayaStudyApp/Helpers/SoundEffects.swift",
    "InayaStudyApp/Helpers/Haptics.swift",
    "InayaStudyApp/Helpers/KeychainPIN.swift",
    "InayaStudyApp/Views/RootView.swift",
    "InayaStudyApp/Views/HomeView.swift",
    "InayaStudyApp/Views/TopicGridView.swift",
    "InayaStudyApp/Views/SessionSetupView.swift",
    "InayaStudyApp/Views/QuizView.swift",
    "InayaStudyApp/Views/ResultsView.swift",
    "InayaStudyApp/Views/ProgressView.swift",
    "InayaStudyApp/Views/SettingsView.swift",
    "InayaStudyApp/Views/Components/NumericKeypadView.swift",
    "InayaStudyApp/Views/Components/SharedComponents.swift",
    "InayaStudyApp/Views/Components/QuizKeyboardShortcuts.swift",
    "InayaStudyApp/Views/Visuals/ClockFaceView.swift",
    "InayaStudyApp/Views/Visuals/CoinRowView.swift",
    "InayaStudyApp/Views/Visuals/NumberLineView.swift",
    "InayaStudyApp/Views/Visuals/ArrayGridView.swift",
    "InayaStudyApp/Views/Visuals/FractionCircleView.swift",
    "InayaStudyApp/Views/Visuals/BarGraphView.swift",
    "InayaStudyApp/Views/Visuals/ProblemVisualView.swift",
    "InayaStudyApp/Views/Visuals/MatterStateView.swift",
    "InayaStudyApp/Views/Visuals/FoodChainView.swift",
    "InayaStudyApp/Views/Visuals/LifeCycleView.swift",
    "InayaStudyApp/Views/Visuals/ScienceToolView.swift",
]

TESTS = ["InayaStudyAppTests/ProblemGeneratorTests.swift"]
RESOURCES = ["InayaStudyApp/Assets.xcassets"]


def uid(prefix: str, index: int) -> str:
    return f"MP{prefix}{index:03d}"


PROJECT_ID = "MPP000"
CONTAINER_PROXY_ID = "MPX001"


def main() -> None:
    lines = [
        "// !$*UTF8*$!",
        "{",
        "\tarchiveVersion = 1;",
        "\tclasses = {};",
        "\tobjectVersion = 56;",
        "\tobjects = {",
        "",
        "/* Begin PBXBuildFile section */",
    ]

    build_files = []
    file_refs = []
    source_phase = []
    resource_phase = []
    test_build_files = []
    test_sources = []

    idx = 1
    for path in SOURCES:
        name = Path(path).name
        bf, fr = uid("B", idx), uid("F", idx)
        idx += 1
        build_files.append(
            f"\t\t{bf} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr} /* {name} */; }};"
        )
        file_refs.append(
            f"\t\t{fr} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {name}; sourceTree = \"<group>\"; }};"
        )
        source_phase.append(f"\t\t\t{bf} /* {name} in Sources */,")

    idx_r = 100
    for path in RESOURCES:
        name = Path(path).name
        bf, fr = uid("B", idx_r), uid("F", idx_r)
        idx_r += 1
        build_files.append(
            f"\t\t{bf} /* {name} in Resources */ = {{isa = PBXBuildFile; fileRef = {fr} /* {name} */; }};"
        )
        file_refs.append(
            f"\t\t{fr} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = {name}; sourceTree = \"<group>\"; }};"
        )
        resource_phase.append(f"\t\t\t{bf} /* {name} in Resources */,")

    idx_t = 200
    for path in TESTS:
        name = Path(path).name
        bf, fr = uid("B", idx_t), uid("F", idx_t)
        idx_t += 1
        test_build_files.append(
            f"\t\t{bf} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr} /* {name} */; }};"
        )
        file_refs.append(
            f"\t\t{fr} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {name}; sourceTree = \"<group>\"; }};"
        )
        test_sources.append(f"\t\t\t{bf} /* {name} in Sources */,")

    lines.extend(build_files)
    lines.extend(test_build_files)
    lines.extend(
        [
            "/* End PBXBuildFile section */",
            "",
            "/* Begin PBXFileReference section */",
            f"\t\t{uid('F', 900)} /* InayaStudyApp.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = InayaStudyApp.app; sourceTree = BUILT_PRODUCTS_DIR; }};",
            f"\t\t{uid('F', 901)} /* InayaStudyAppTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = InayaStudyAppTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};",
        ]
    )
    lines.extend(file_refs)
    lines.extend(
        [
            "/* End PBXFileReference section */",
            "",
            "/* Begin PBXFrameworksBuildPhase section */",
            f"\t\t{uid('P', 1)} /* Frameworks */ = {{isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};",
            f"\t\t{uid('P', 2)} /* Frameworks */ = {{isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};",
            "/* End PBXFrameworksBuildPhase section */",
            "",
            "/* Begin PBXGroup section */",
            f"\t\t{uid('G', 1)} = {{isa = PBXGroup; children = ({uid('G', 2)} /* InayaStudyApp */, {uid('G', 3)} /* InayaStudyAppTests */, {uid('G', 4)} /* Products */); sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 2)} /* InayaStudyApp */ = {{isa = PBXGroup; children = ({uid('F', 1)}, {uid('G', 10)}, {uid('G', 11)}, {uid('G', 12)}, {uid('G', 13)}, {uid('G', 14)}, {uid('G', 16)}, {uid('F', 100)}); path = InayaStudyApp; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 3)} /* InayaStudyAppTests */ = {{isa = PBXGroup; children = ({uid('F', 200)}); path = InayaStudyAppTests; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 4)} /* Products */ = {{isa = PBXGroup; children = ({uid('F', 900)}, {uid('F', 901)}); name = Products; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 10)} /* Models */ = {{isa = PBXGroup; children = ({uid('F', 2)}, {uid('F', 3)}); path = Models; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 11)} /* Data */ = {{isa = PBXGroup; children = ({uid('F', 4)}); path = Data; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 12)} /* Services */ = {{isa = PBXGroup; children = ({uid('F', 5)}, {uid('F', 6)}, {uid('F', 7)}, {uid('F', 8)}); path = Services; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 13)} /* ViewModels */ = {{isa = PBXGroup; children = ({uid('F', 9)}); path = ViewModels; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 14)} /* Helpers */ = {{isa = PBXGroup; children = ({uid('F', 10)}, {uid('F', 11)}, {uid('F', 12)}, {uid('F', 13)}, {uid('F', 14)}); path = Helpers; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 16)} /* Views */ = {{isa = PBXGroup; children = ({uid('G', 17)}, {uid('G', 18)}, {uid('F', 15)}, {uid('F', 16)}, {uid('F', 17)}, {uid('F', 18)}, {uid('F', 19)}, {uid('F', 20)}, {uid('F', 21)}, {uid('F', 22)}); path = Views; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 17)} /* Components */ = {{isa = PBXGroup; children = ({uid('F', 23)}, {uid('F', 24)}, {uid('F', 25)}); path = Components; sourceTree = \"<group>\"; }};",
            f"\t\t{uid('G', 18)} /* Visuals */ = {{isa = PBXGroup; children = ({uid('F', 26)}, {uid('F', 27)}, {uid('F', 28)}, {uid('F', 29)}, {uid('F', 30)}, {uid('F', 31)}, {uid('F', 32)}, {uid('F', 33)}, {uid('F', 34)}, {uid('F', 35)}, {uid('F', 36)}); path = Visuals; sourceTree = \"<group>\"; }};",
            "/* End PBXGroup section */",
            "",
            "/* Begin PBXNativeTarget section */",
            f"\t\t{uid('T', 1)} /* InayaStudyApp */ = {{isa = PBXNativeTarget; buildConfigurationList = {uid('C', 3)}; buildPhases = ({uid('E', 1)} /* Sources */, {uid('P', 1)} /* Frameworks */, {uid('E', 2)} /* Resources */); buildRules = (); dependencies = (); name = InayaStudyApp; productName = InayaStudyApp; productReference = {uid('F', 900)}; productType = \"com.apple.product-type.application\"; }};",
            f"\t\t{uid('T', 2)} /* InayaStudyAppTests */ = {{isa = PBXNativeTarget; buildConfigurationList = {uid('C', 4)}; buildPhases = ({uid('E', 3)} /* Sources */, {uid('P', 2)} /* Frameworks */, {uid('E', 4)} /* Resources */); buildRules = (); dependencies = ({uid('D', 1)}); name = InayaStudyAppTests; productName = InayaStudyAppTests; productReference = {uid('F', 901)}; productType = \"com.apple.product-type.bundle.unit-test\"; }};",
            "/* End PBXNativeTarget section */",
            "",
            "/* Begin PBXContainerItemProxy section */",
            f"\t\t{CONTAINER_PROXY_ID} /* PBXContainerItemProxy */ = {{isa = PBXContainerItemProxy; containerPortal = {PROJECT_ID}; proxyType = 1; remoteGlobalIDString = {uid('T', 1)}; remoteInfo = InayaStudyApp; }};",
            "/* End PBXContainerItemProxy section */",
            "",
            "/* Begin PBXTargetDependency section */",
            f"\t\t{uid('D', 1)} /* PBXTargetDependency */ = {{isa = PBXTargetDependency; target = {uid('T', 1)}; targetProxy = {CONTAINER_PROXY_ID}; }};",
            "/* End PBXTargetDependency section */",
            "",
            "/* Begin PBXProject section */",
            f"\t\t{PROJECT_ID} /* Project object */ = {{isa = PBXProject; attributes = {{BuildIndependentTargetsInParallel = 1; LastSwiftUpdateCheck = 1500; LastUpgradeCheck = 1500; TargetAttributes = {{{uid('T', 2)} = {{CreatedOnToolsVersion = 15.0; TestTargetID = {uid('T', 1)}; }}; }}; }}; buildConfigurationList = {uid('C', 1)}; compatibilityVersion = \"Xcode 14.0\"; developmentRegion = en; hasScannedForEncodings = 0; knownRegions = (en, Base); mainGroup = {uid('G', 1)}; productRefGroup = {uid('G', 4)}; projectDirPath = \"\"; projectRoot = \"\"; targets = ({uid('T', 1)}, {uid('T', 2)}); }};",
            "/* End PBXProject section */",
            "",
            "/* Begin PBXResourcesBuildPhase section */",
            f"\t\t{uid('E', 2)} /* Resources */ = {{isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (",
            *resource_phase,
            "\t\t); runOnlyForDeploymentPostprocessing = 0; };",
            f"\t\t{uid('E', 4)} /* Resources */ = {{isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};",
            "/* End PBXResourcesBuildPhase section */",
            "",
            "/* Begin PBXSourcesBuildPhase section */",
            f"\t\t{uid('E', 1)} /* Sources */ = {{isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (",
            *source_phase,
            "\t\t); runOnlyForDeploymentPostprocessing = 0; };",
            f"\t\t{uid('E', 3)} /* Sources */ = {{isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (",
            *test_sources,
            "\t\t); runOnlyForDeploymentPostprocessing = 0; };",
            "/* End PBXSourcesBuildPhase section */",
            "",
            "/* Begin XCBuildConfiguration section */",
            f"\t\t{uid('C', 5)} /* Debug */ = {{isa = XCBuildConfiguration; buildSettings = {{ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = dwarf; ENABLE_TESTABILITY = YES; GCC_OPTIMIZATION_LEVEL = 0; IPHONEOS_DEPLOYMENT_TARGET = 16.0; MACOSX_DEPLOYMENT_TARGET = 13.0; ONLY_ACTIVE_ARCH = YES; SDKROOT = iphoneos; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; SWIFT_OPTIMIZATION_LEVEL = \"-Onone\"; }}; name = Debug; }};",
            f"\t\t{uid('C', 6)} /* Release */ = {{isa = XCBuildConfiguration; buildSettings = {{ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\"; ENABLE_NS_ASSERTIONS = NO; GCC_OPTIMIZATION_LEVEL = s; IPHONEOS_DEPLOYMENT_TARGET = 16.0; MACOSX_DEPLOYMENT_TARGET = 13.0; SDKROOT = iphoneos; SWIFT_COMPILATION_MODE = wholemodule; VALIDATE_PRODUCT = YES; }}; name = Release; }};",
            f"\t\t{uid('C', 7)} /* Debug */ = {{isa = XCBuildConfiguration; buildSettings = {{ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER = YES; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_CFBundleDisplayName = \"{DISPLAY_NAME}\"; INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES; IPHONEOS_DEPLOYMENT_TARGET = 16.0; LD_RUNPATH_SEARCH_PATHS = (\"$(inherited)\", \"@executable_path/Frameworks\"); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.inaya.studyapp; PRODUCT_NAME = \"$(TARGET_NAME)\"; SUPPORTS_MACCATALYST = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = \"1,2\"; }}; name = Debug; }};",
            f"\t\t{uid('C', 8)} /* Release */ = {{isa = XCBuildConfiguration; buildSettings = {{ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER = YES; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_CFBundleDisplayName = \"{DISPLAY_NAME}\"; INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES; IPHONEOS_DEPLOYMENT_TARGET = 16.0; LD_RUNPATH_SEARCH_PATHS = (\"$(inherited)\", \"@executable_path/Frameworks\"); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.inaya.studyapp; PRODUCT_NAME = \"$(TARGET_NAME)\"; SUPPORTS_MACCATALYST = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = \"1,2\"; }}; name = Release; }};",
            f"\t\t{uid('C', 9)} /* Debug */ = {{isa = XCBuildConfiguration; buildSettings = {{BUNDLE_LOADER = \"$(TEST_HOST)\"; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; GENERATE_INFOPLIST_FILE = YES; IPHONEOS_DEPLOYMENT_TARGET = 16.0; MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.inaya.studyapp.tests; PRODUCT_NAME = \"$(TARGET_NAME)\"; SWIFT_VERSION = 5.0; TEST_HOST = \"$(BUILT_PRODUCTS_DIR)/InayaStudyApp.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/InayaStudyApp\"; }}; name = Debug; }};",
            f"\t\t{uid('C', 10)} /* Release */ = {{isa = XCBuildConfiguration; buildSettings = {{BUNDLE_LOADER = \"$(TEST_HOST)\"; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; GENERATE_INFOPLIST_FILE = YES; IPHONEOS_DEPLOYMENT_TARGET = 16.0; MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.inaya.studyapp.tests; PRODUCT_NAME = \"$(TARGET_NAME)\"; SWIFT_VERSION = 5.0; TEST_HOST = \"$(BUILT_PRODUCTS_DIR)/InayaStudyApp.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/InayaStudyApp\"; }}; name = Release; }};",
            "/* End XCBuildConfiguration section */",
            "",
            "/* Begin XCConfigurationList section */",
            f"\t\t{uid('C', 1)} /* Build configuration list for PBXProject */ = {{isa = XCConfigurationList; buildConfigurations = ({uid('C', 5)}, {uid('C', 6)}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};",
            f"\t\t{uid('C', 3)} /* Build configuration list for PBXNativeTarget InayaStudyApp */ = {{isa = XCConfigurationList; buildConfigurations = ({uid('C', 7)}, {uid('C', 8)}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};",
            f"\t\t{uid('C', 4)} /* Build configuration list for PBXNativeTarget InayaStudyAppTests */ = {{isa = XCConfigurationList; buildConfigurations = ({uid('C', 9)}, {uid('C', 10)}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};",
            "/* End XCConfigurationList section */",
            "\t};",
            f"\trootObject = {PROJECT_ID} /* Project object */;",
            "}",
        ]
    )

    PROJECT.parent.mkdir(parents=True, exist_ok=True)
    PROJECT.write_text("\n".join(lines) + "\n")
    print(f"Wrote {PROJECT}")


if __name__ == "__main__":
    main()
