import Foundation

enum ScienceProblemGenerator {
    static func generate(topic: Topic, difficulty: Difficulty) -> Problem {
        if topic.id == "sci3-mixed-review" {
            let pool = TopicRegistry.scienceThirdGradePracticeTopics
            let randomTopic = pool.randomElement() ?? topic
            return generate(topic: randomTopic, difficulty: difficulty)
        }

        if topic.id == "sci2-mixed-review" {
            let pool = TopicRegistry.scienceSecondGradePracticeTopics
            let randomTopic = pool.randomElement() ?? topic
            return generate(topic: randomTopic, difficulty: difficulty)
        }

        switch topic.id {
        case "sci-matter-properties": return matterProperties(topic: topic, difficulty: difficulty)
        case "sci-matter-changes": return matterChanges(topic: topic, difficulty: difficulty)
        case "sci-mixtures": return mixtures(topic: topic, difficulty: difficulty)
        case "sci-force-motion": return forceMotion(topic: topic, difficulty: difficulty)
        case "sci-energy-forms": return energyForms(topic: topic, difficulty: difficulty)
        case "sci-sound-light": return soundLight(topic: topic, difficulty: difficulty)
        case "sci-earth-materials": return earthMaterials(topic: topic, difficulty: difficulty)
        case "sci-sky-patterns": return skyPatterns(topic: topic, difficulty: difficulty)
        case "sci-weather-seasons": return weatherSeasons(topic: topic, difficulty: difficulty)
        case "sci-conservation": return conservation(topic: topic, difficulty: difficulty)
        case "sci-plant-structures": return plantStructures(topic: topic, difficulty: difficulty)
        case "sci-animal-needs": return animalNeeds(topic: topic, difficulty: difficulty)
        case "sci-life-cycles": return lifeCycles(topic: topic, difficulty: difficulty)
        case "sci-food-chains": return foodChains(topic: topic, difficulty: difficulty)
        case "sci-habitats": return habitats(topic: topic, difficulty: difficulty)
        case "sci-science-tools": return scienceTools(topic: topic, difficulty: difficulty)
        case "sci-scientific-method": return scientificMethod(topic: topic, difficulty: difficulty)
        case "sci-scientists-work": return scientistsWork(topic: topic, difficulty: difficulty)
        case "sci-vibration-sound": return vibrationSound(topic: topic, difficulty: difficulty)
        case "sci-severe-weather": return severeWeather(topic: topic, difficulty: difficulty)
        case "sci3-investigation": return sci3Investigation(topic: topic, difficulty: difficulty)
        case "sci3-science-practices": return sci3SciencePractices(topic: topic, difficulty: difficulty)
        case "sci3-matter-states": return sci3MatterStates(topic: topic, difficulty: difficulty)
        case "sci3-force-magnets": return sci3ForceMagnets(topic: topic, difficulty: difficulty)
        case "sci3-mechanical-energy": return sci3MechanicalEnergy(topic: topic, difficulty: difficulty)
        case "sci3-everyday-energy": return sci3EverydayEnergy(topic: topic, difficulty: difficulty)
        case "sci3-energy-circuits": return sci3EnergyCircuits(topic: topic, difficulty: difficulty)
        case "sci3-earth-soil": return sci3EarthSoil(topic: topic, difficulty: difficulty)
        case "sci3-conservation": return sci3Conservation(topic: topic, difficulty: difficulty)
        case "sci3-sun-moon": return sci3SunMoon(topic: topic, difficulty: difficulty)
        case "sci3-weather-climate": return sci3WeatherClimate(topic: topic, difficulty: difficulty)
        case "sci3-ecosystems": return sci3Ecosystems(topic: topic, difficulty: difficulty)
        case "sci3-fossils-changes": return sci3FossilsChanges(topic: topic, difficulty: difficulty)
        case "sci3-growth-behavior": return sci3GrowthBehavior(topic: topic, difficulty: difficulty)
        case "sci3-inherited-traits": return sci3InheritedTraits(topic: topic, difficulty: difficulty)
        case "sci3-life-cycles": return sci3LifeCycles(topic: topic, difficulty: difficulty)
        default:
            return matterProperties(topic: topic, difficulty: difficulty)
        }
    }

    /// Builds a quiz session with varied questions, cycling difficulties when a topic has a small bank.
    static func generateSession(topic: Topic, difficulty: Difficulty, count: Int) -> [Problem] {
        var unique: [String: Problem] = [:]
        for level in Difficulty.allCases {
            for _ in 0..<30 {
                let problem = generate(topic: topic, difficulty: level)
                unique[problem.questionText] = problem
            }
        }

        var pool = Array(unique.values).shuffled()
        if pool.isEmpty {
            pool = [generate(topic: topic, difficulty: difficulty)]
        }

        return (0..<count).map { index in
            freshCopy(pool[index % pool.count])
        }
    }

    private static func freshCopy(_ problem: Problem) -> Problem {
        let reshuffledChoices: [String]?
        if let choices = problem.choices {
            let wrong = choices.filter { $0 != problem.correctAnswer }
            reshuffledChoices = ProblemGenerator.multipleChoiceOptions(
                correct: problem.correctAnswer,
                distractors: wrong
            )
        } else {
            reshuffledChoices = nil
        }

        return Problem(
            questionText: problem.questionText,
            visual: problem.visual,
            answerType: problem.answerType,
            correctAnswer: problem.correctAnswer,
            choices: reshuffledChoices,
            hint: problem.hint,
            teksId: problem.teksId,
            tapOptions: problem.tapOptions,
            funFact: problem.funFact
        )
    }

    // MARK: - Matter & Properties

    private static func matterProperties(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            let items: [(String, String, String)] = [
                ("ice", "solid", "Ice is frozen water — a solid!"),
                ("water", "liquid", "Water flows and takes the shape of its container."),
                ("steam", "gas", "Steam is water vapor — a gas you can see rising from hot water."),
                ("rock", "solid", "Rocks hold their shape. They are solids."),
                ("juice", "liquid", "Juice pours and flows like a liquid."),
            ]
            let item = items.randomElement()!
            return mc(
                topic: topic,
                question: "What state of matter is \(item.0)?",
                correct: item.1,
                wrong: ["liquid", "gas", "solid"].filter { $0 != item.1 },
                visual: .matterState(item.1),
                funFact: item.2
            )
        case .medium:
            let textures: [(String, String, String)] = [
                ("rough sandpaper", "rough", "Rough means it feels bumpy, not smooth."),
                ("smooth glass", "smooth", "Smooth surfaces feel flat and even."),
                ("soft cotton", "soft", "Soft things are gentle to touch, like a pillow."),
                ("hard rock", "hard", "Hard things are tough and difficult to scratch."),
            ]
            let t = textures.randomElement()!
            return mc(
                topic: topic,
                question: "Which property describes how \(t.0) feels?",
                correct: t.1,
                wrong: ["rough", "smooth", "soft", "hard"].filter { $0 != t.1 },
                funFact: t.2
            )
        case .hard:
            let floats: [(String, String, String)] = [
                ("wooden block", "float", "Wood is less dense than water, so it floats."),
                ("metal coin", "sink", "Metal is heavy and dense, so it sinks."),
                ("plastic bottle cap", "float", "Many plastics are light enough to float."),
                ("paper clip", "sink", "A metal paper clip is small but still sinks."),
            ]
            let f = floats.randomElement()!
            return mc(
                topic: topic,
                question: "A \(f.0) is placed in water. Will it sink or float?",
                correct: f.1,
                wrong: ["sink", "float"].filter { $0 != f.1 } + ["dissolve"],
                funFact: f.2
            )
        }
    }

    // MARK: - Matter Changes

    private static func matterChanges(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Ice cream melts on a hot day. This is matter being ___",
                   correct: "heated", wrong: ["cooled", "cut", "folded"],
                   funFact: "Heat makes ice cream melt into a liquid."),
                mc(topic: topic, question: "Putting water in the freezer makes ice. The water is being ___",
                   correct: "cooled", wrong: ["heated", "folded", "stretched"],
                   funFact: "Cooling water below 32°F turns it into solid ice."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Folding a piece of paper is a ___ change.",
                   correct: "reversible", wrong: ["irreversible", "chemical", "magnetic"],
                   funFact: "You can unfold paper and it looks almost the same again!"),
                mc(topic: topic, question: "Burning a piece of wood is a ___ change.",
                   correct: "irreversible", wrong: ["reversible", "folding", "bending"],
                   funFact: "Once wood burns to ash, you cannot turn it back into wood."),
            ])
        case .hard:
            return mc(
                topic: topic,
                question: "Which change CANNOT be undone?",
                correct: "cutting clay into pieces",
                wrong: ["folding paper", "melting ice", "bending a wire"],
                funFact: "Cutting changes the shape permanently, even if you push pieces back together."
            )
        }
    }

    // MARK: - Force & Motion

    private static func forceMotion(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "A child kicks a ball. The foot applies a ___ to the ball.",
                   correct: "push", wrong: ["pull", "gravity", "magnet"],
                   funFact: "A kick pushes the ball away from your foot."),
                mc(topic: topic, question: "You tug a wagon toward you. That is a ___",
                   correct: "pull", wrong: ["push", "spin", "float"],
                   funFact: "Pulling brings something closer to you."),
            ])
        case .medium:
            return mc(
                topic: topic,
                question: "If you push a toy car harder, it will move ___",
                correct: "faster",
                wrong: ["slower", "backward only", "without moving"],
                funFact: "A bigger push gives the car more speed!"
            )
        case .hard:
            return mc(
                topic: topic,
                question: "Which force pulls objects toward the ground?",
                correct: "gravity",
                wrong: ["magnetism", "friction", "electricity"],
                funFact: "Gravity is the force that keeps your feet on the ground."
            )
        }
    }

    // MARK: - Energy Forms

    private static func energyForms(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "A lamp uses ___ energy to make light.",
                   correct: "electrical", wrong: ["sound", "mechanical", "magnetic"],
                   funFact: "Electricity flows through the lamp to light the bulb."),
                mc(topic: topic, question: "When you clap your hands, you make ___ energy.",
                   correct: "sound", wrong: ["light", "gravity", "electrical"],
                   funFact: "Clapping makes vibrations that travel as sound waves."),
            ])
        case .medium:
            return mc(
                topic: topic,
                question: "The Sun gives Earth ___",
                correct: "heat and light",
                wrong: ["sound and gravity", "electricity and heat", "magnetism and light"],
                funFact: "Sunlight warms Earth and helps plants grow."
            )
        case .hard:
            return mc(
                topic: topic,
                question: "A fan blowing air uses ___ energy to move the blades.",
                correct: "electrical",
                wrong: ["chemical", "sound", "nuclear"],
                funFact: "Electricity spins the fan blades to create a breeze."
            )
        }
    }

    // MARK: - Sound & Light

    private static func soundLight(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(
                topic: topic,
                question: "Sound is caused by ___",
                correct: "vibrations",
                wrong: ["light", "gravity", "magnetism"],
                funFact: "When something vibrates, it pushes air and makes sound."
            )
        case .medium:
            return pick([
                mc(topic: topic, question: "A clear window lets light pass through. It is ___",
                   correct: "transparent", wrong: ["opaque", "reflective", "magnetic"],
                   funFact: "Transparent means you can see clearly through it."),
                mc(topic: topic, question: "A drum with a tight skin makes a ___ pitch than a loose skin.",
                   correct: "higher", wrong: ["lower", "silent", "slower"],
                   funFact: "Tight drum skins vibrate faster and make higher sounds."),
            ])
        case .hard:
            return mc(
                topic: topic,
                question: "Which material would block the MOST light?",
                correct: "cardboard",
                wrong: ["clear glass", "wax paper", "water"],
                funFact: "Cardboard is opaque — no light shines through it."
            )
        }
    }

    // MARK: - Earth Materials

    private static func earthMaterials(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(
                topic: topic,
                question: "Which is a natural material?",
                correct: "rock",
                wrong: ["plastic bottle", "aluminum foil", "styrofoam cup"],
                funFact: "Rocks are found in nature, not made in a factory."
            )
        case .medium:
            return mc(
                topic: topic,
                question: "Soil is made of ___",
                correct: "tiny rock pieces, dead plants, and water",
                wrong: ["only sand", "only plastic", "only clay"],
                funFact: "Healthy soil has bits of rock, rotting leaves, and moisture."
            )
        case .hard:
            return mc(
                topic: topic,
                question: "Which earth material is used to make glass?",
                correct: "sand",
                wrong: ["clay", "coal", "gravel"],
                funFact: "Heated sand melts and can be shaped into glass."
            )
        }
    }

    // MARK: - Sky Patterns

    private static func skyPatterns(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "The Sun appears to move across the sky from ___",
                   correct: "east to west", wrong: ["west to east", "north to south", "south to north"],
                   funFact: "The Sun rises in the east and sets in the west."),
                mc(topic: topic, question: "Which object gives off its own light?",
                   correct: "Sun", wrong: ["Moon", "Earth", "Mars"],
                   funFact: "The Sun is a star that makes its own light and heat."),
            ])
        case .medium:
            return mc(
                topic: topic,
                question: "Stars are visible at night because ___",
                correct: "the Sun is on the other side of Earth",
                wrong: ["stars turn on at night", "clouds make stars", "the Moon creates stars"],
                funFact: "When our side of Earth faces away from the Sun, the sky is dark enough to see stars."
            )
        case .hard:
            return mc(
                topic: topic,
                question: "In Texas, which season is usually the hottest?",
                correct: "Summer",
                wrong: ["Winter", "Spring", "Fall"],
                funFact: "Texas summers are hot because the Sun is higher in the sky for longer."
            )
        }
    }

    // MARK: - Plant Structures

    private static func plantStructures(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Which part of a plant absorbs water from the soil?",
                   correct: "roots", wrong: ["leaves", "flowers", "fruit"],
                   funFact: "Roots soak up water from the soil like a sponge!"),
                mc(topic: topic, question: "Green leaves help a plant make ___",
                   correct: "food", wrong: ["rocks", "metal", "magnets"],
                   funFact: "Leaves use sunlight to make food."),
                mc(topic: topic, question: "Flowers often help a plant make ___",
                   correct: "seeds", wrong: ["soil", "water", "wind only"],
                   funFact: "Many flowers lead to seeds."),
                mc(topic: topic, question: "The stem supports the plant and moves ___",
                   correct: "water", wrong: ["only sound", "only magnets", "only shadows"],
                   funFact: "Stems carry water to leaves."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Leaves use sunlight, water, and air to make ___ for the plant.",
                   correct: "food", wrong: ["seeds", "soil", "rocks"],
                   funFact: "Leaves are like tiny food factories for the plant."),
                mc(topic: topic, question: "Which plant part takes in carbon dioxide from the air?",
                   correct: "leaves", wrong: ["roots", "rocks", "magnets"],
                   funFact: "Leaves have tiny openings for gases."),
                mc(topic: topic, question: "Seeds grow into new ___",
                   correct: "plants", wrong: ["rocks", "circuits", "magnets"],
                   funFact: "A seed contains a tiny new plant."),
                mc(topic: topic, question: "Roots anchor the plant in the ___",
                   correct: "soil", wrong: ["sky", "Sun", "Moon"],
                   funFact: "Roots hold plants steady."),
            ])
        case .hard:
            return pick([
                mc(topic: topic, question: "If a plant's roots were removed, what would most likely happen?",
                   correct: "It could not get water", wrong: ["It would grow faster", "It would make more flowers", "It would grow taller"],
                   funFact: "Without roots, a plant cannot drink water from the soil."),
                mc(topic: topic, question: "If a plant gets no sunlight, it cannot make enough ___",
                   correct: "food", wrong: ["gravity", "magnetism", "sound"],
                   funFact: "Sunlight powers photosynthesis."),
                mc(topic: topic, question: "Cutting all the leaves off would reduce the plant's ability to ___",
                   correct: "make food", wrong: ["orbit Earth", "become metal", "create magnets"],
                   funFact: "Leaves are the main food-making part."),
                mc(topic: topic, question: "A fruit often protects the plant's ___",
                   correct: "seeds", wrong: ["roots", "soil", "circuit"],
                   funFact: "Fruits help spread seeds."),
            ])
        }
    }

    // MARK: - Animal Needs

    private static func animalNeeds(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "All animals need ___",
                   correct: "food, water, air, and shelter", wrong: ["only food and water", "sunlight and soil", "only air"],
                   funFact: "Animals need food, water, air, and a safe place to live."),
                mc(topic: topic, question: "Fish breathe underwater using ___",
                   correct: "gills", wrong: ["roots", "wings", "magnets"],
                   funFact: "Gills take oxygen from water."),
                mc(topic: topic, question: "Birds use ___ to fly.",
                   correct: "wings", wrong: ["gills", "roots", "petals"],
                   funFact: "Wings help birds move through air."),
                mc(topic: topic, question: "A safe place to live is called ___",
                   correct: "shelter", wrong: ["a fraction", "a magnet", "a circuit"],
                   funFact: "Shelter protects animals from weather and predators."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "A polar bear has thick white fur. The white fur helps it ___",
                   correct: "hide in snow", wrong: ["stay cool in heat", "fly", "breathe underwater"],
                   funFact: "White fur camouflages polar bears in the snowy Arctic."),
                mc(topic: topic, question: "A camel stores fat in its hump for energy in the ___",
                   correct: "desert", wrong: ["ocean", "rainforest", "Arctic ice"],
                   funFact: "Camels survive long trips without much water."),
                mc(topic: topic, question: "Sharp teeth help a lion ___",
                   correct: "eat meat", wrong: ["photosynthesize", "fly", "breathe underwater"],
                   funFact: "Body parts match what animals eat."),
                mc(topic: topic, question: "Blubber helps whales stay warm in cold ___",
                   correct: "water", wrong: ["desert sand", "outer space", "caves only"],
                   funFact: "Fat layers insulate animals."),
            ])
        case .hard:
            return pick([
                mc(topic: topic, question: "Which body part helps a duck swim in water?",
                   correct: "webbed feet", wrong: ["sharp claws", "long tail", "antlers"],
                   funFact: "Webbed feet work like paddles to push ducks through water."),
                mc(topic: topic, question: "If an animal loses its habitat, it may not find enough ___",
                   correct: "food and shelter", wrong: ["gravity", "magnetism", "fractions"],
                   funFact: "Habitat loss threatens survival."),
                mc(topic: topic, question: "Migration helps some animals find better ___",
                   correct: "food and weather", wrong: ["magnet", "circuit", "shadow only"],
                   funFact: "Moving to new areas can help animals survive."),
                mc(topic: topic, question: "Camouflage helps an animal avoid ___",
                   correct: "predators", wrong: ["sunlight", "roots", "circuits"],
                   funFact: "Blending in is a survival adaptation."),
            ])
        }
    }

    // MARK: - Life Cycles

    private static func lifeCycles(topic: Topic, difficulty: Difficulty) -> Problem {
        let butterfly = ["egg", "caterpillar", "chrysalis", "butterfly"]
        let frog = ["egg", "tadpole", "frog"]
        let plant = ["seed", "seedling", "plant", "flower"]

        switch difficulty {
        case .easy:
            return mc(
                topic: topic,
                question: "What comes after the egg in a butterfly's life cycle?",
                correct: "caterpillar",
                wrong: ["chrysalis", "butterfly", "tadpole"],
                visual: .lifeCycle(kind: "butterfly", stages: butterfly),
                funFact: "A caterpillar hatches from a butterfly egg."
            )
        case .medium:
            return pick([
                mc(topic: topic, question: "A tadpole will grow into a ___",
                   correct: "frog", wrong: ["butterfly", "fish", "bird"],
                   visual: .lifeCycle(kind: "frog", stages: frog),
                   funFact: "Tadpoles live in water and slowly grow legs to become frogs."),
                mc(topic: topic, question: "A seed grows into a ___ first.",
                   correct: "seedling", wrong: ["flower", "fruit", "root only"],
                   visual: .lifeCycle(kind: "plant", stages: plant),
                   funFact: "A seedling is a young, tiny plant."),
            ])
        case .hard:
            return mc(
                topic: topic,
                question: "Which shows the correct life cycle of a plant?",
                correct: "seed → seedling → plant → flower",
                wrong: [
                    "flower → seed → plant → seedling",
                    "plant → seed → flower → seedling",
                    "seedling → flower → plant → seed",
                ],
                visual: .lifeCycle(kind: "plant", stages: plant),
                funFact: "Plants start as seeds, sprout, grow, then make flowers."
            )
        }
    }

    // MARK: - Habitats

    private static func habitats(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "A cactus stores water. It is most likely found in a ___",
                   correct: "desert", wrong: ["ocean", "rainforest", "wetland"],
                   funFact: "Desert plants like cacti save water because rain is rare."),
                mc(topic: topic, question: "A polar bear lives in the cold ___",
                   correct: "Arctic", wrong: ["desert", "rainforest", "coral reef"],
                   funFact: "Arctic animals need thick fur and blubber."),
                mc(topic: topic, question: "Fish are best adapted to live in the ___",
                   correct: "ocean", wrong: ["desert", "cave", "mountain top"],
                   funFact: "Fish have gills for underwater life."),
                mc(topic: topic, question: "Many monkeys live in a ___",
                   correct: "rainforest", wrong: ["desert", "Arctic", "deep cave"],
                   funFact: "Rainforests have tall trees and lots of rain."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Which animal is best adapted to live in the ocean?",
                   correct: "fish", wrong: ["eagle", "rabbit", "deer"],
                   funFact: "Fish have gills to breathe underwater."),
                mc(topic: topic, question: "A frog is most at home near ___",
                   correct: "water", wrong: ["desert sand", "Arctic ice", "deep space"],
                   funFact: "Frogs need moist places."),
                mc(topic: topic, question: "A deer lives in a forest where it finds ___",
                   correct: "plants to eat", wrong: ["only salt water", "only lava", "only metal"],
                   funFact: "Forest habitats provide food and shelter."),
                mc(topic: topic, question: "Penguins are adapted to cold ___ habitats.",
                   correct: "Antarctic", wrong: ["desert", "rainforest", "cave"],
                   funFact: "Thick feathers keep penguins warm."),
            ])
        case .hard:
            return pick([
                mc(topic: topic, question: "In a food chain: grass → rabbit → fox, the grass is the ___",
                   correct: "producer", wrong: ["consumer", "predator", "decomposer"],
                   visual: .foodChain(producer: "Grass", herbivore: "Rabbit", carnivore: "Fox"),
                   funFact: "Plants are producers because they make their own food from sunlight."),
                mc(topic: topic, question: "If a forest is cut down, animals may lose ___",
                   correct: "shelter and food", wrong: ["gravity", "magnetism", "the Moon"],
                   funFact: "Habitat change affects survival."),
                mc(topic: topic, question: "Wetlands are habitats with lots of ___",
                   correct: "water", wrong: ["sand only", "metal", "magnets"],
                   funFact: "Wetlands support many plants and animals."),
                mc(topic: topic, question: "An oasis in a desert has ___ that helps animals survive.",
                   correct: "water", wrong: ["ice only", "magnets", "shadows"],
                   funFact: "Water is essential in every habitat."),
            ])
        }
    }

    // MARK: - Science Tools

    private static func scienceTools(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Which tool measures how long a pencil is?",
                   correct: "ruler", wrong: ["thermometer", "hand lens", "balance"],
                   visual: .scienceTool(name: "Ruler", symbol: "ruler"),
                   funFact: "A ruler measures length in inches or centimeters."),
                mc(topic: topic, question: "Which tool measures temperature?",
                   correct: "thermometer", wrong: ["ruler", "balance", "measuring cup"],
                   visual: .scienceTool(name: "Thermometer", symbol: "thermometer.medium"),
                   funFact: "A thermometer tells you how hot or cold something is."),
            ])
        case .medium:
            return mc(
                topic: topic,
                question: "A scientist wants to see tiny details on a leaf. Which tool should she use?",
                correct: "hand lens",
                wrong: ["ruler", "measuring cup", "thermometer"],
                visual: .scienceTool(name: "Hand Lens", symbol: "magnifyingglass"),
                funFact: "A hand lens magnifies small things so you can see details."
            )
        case .hard:
            return mc(
                topic: topic,
                question: "Which safety rule is most important in a science experiment?",
                correct: "wear safety goggles",
                wrong: ["eat your lunch first", "work as fast as possible", "skip the instructions"],
                visual: .scienceTool(name: "Safety Goggles", symbol: "eyeglasses"),
                funFact: "Safety goggles protect your eyes from splashes and spills."
            )
        }
    }

    // MARK: - Helpers

    // MARK: - New 2nd Grade Science

    private static func mixtures(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Salt dissolved in water makes a ___",
                   correct: "solution", wrong: ["mixture only", "solid", "gas"],
                   funFact: "When salt dissolves, it spreads evenly in the water."),
                mc(topic: topic, question: "Sugar stirred into tea is a ___",
                   correct: "solution", wrong: ["solid rock", "gas only", "magnet"],
                   funFact: "Dissolved sugar spreads through the liquid."),
                mc(topic: topic, question: "When something dissolves, it ___ in the liquid.",
                   correct: "spreads out", wrong: ["turns into wood", "freezes always", "disappears forever"],
                   funFact: "Dissolving means particles mix evenly into a liquid."),
                mc(topic: topic, question: "Which is a liquid we drink that can dissolve sugar?",
                   correct: "water", wrong: ["sand", "rock", "metal"],
                   funFact: "Water is often called the universal solvent."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Sand stirred into water is a ___",
                   correct: "mixture", wrong: ["solution", "compound", "element"],
                   funFact: "Sand does not dissolve — you can still see the grains."),
                mc(topic: topic, question: "Oil floating on water is a ___",
                   correct: "mixture", wrong: ["solution", "single element", "magnet"],
                   funFact: "Oil and water stay separate."),
                mc(topic: topic, question: "Trail mix with nuts and raisins is a ___",
                   correct: "mixture", wrong: ["solution", "gas", "circuit"],
                   funFact: "You can still see each part in a mixture."),
                mc(topic: topic, question: "Which pair is a mixture, not a solution?",
                   correct: "cereal and milk", wrong: ["salt water", "sugar water", "powdered drink mix"],
                   funFact: "In a mixture the parts stay easy to see or separate."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "Which can be separated by a filter?",
                   correct: "sand and water", wrong: ["salt water", "sugar water", "juice"],
                   funFact: "A filter catches solids but lets liquid through."),
                mc(topic: topic, question: "Which mixture can be separated by evaporation?",
                   correct: "salt water", wrong: ["sand and pebbles", "wood and nails", "paper clips only"],
                   funFact: "Heating can leave the salt behind when water evaporates."),
                mc(topic: topic, question: "A magnet best separates ___",
                   correct: "iron filings and sand", wrong: ["salt and water", "sugar and tea", "juice and water"],
                   funFact: "Magnets attract some metals but not sand."),
                mc(topic: topic, question: "Which tool separates pasta from boiling water?",
                   correct: "strainer", wrong: ["thermometer", "magnet", "ruler"],
                   funFact: "A strainer keeps solids and lets liquid pass through."),
            ])
        }
    }

    private static func weatherSeasons(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "What do we wear when it is very cold?",
                   correct: "coat", wrong: ["swimsuit", "sandals", "shorts"],
                   funFact: "Weather changes what clothes we need."),
                mc(topic: topic, question: "Umbrellas help when the weather is ___",
                   correct: "rainy", wrong: ["sunny only", "windless always", "frozen metal"],
                   funFact: "Rain gear keeps us dry."),
                mc(topic: topic, question: "Shorts and sandals fit ___ weather best.",
                   correct: "hot", wrong: ["snowy", "freezing", "icy"],
                   funFact: "Hot weather means we need less clothing."),
                mc(topic: topic, question: "Clouds often bring ___",
                   correct: "rain", wrong: ["rocks", "magnets", "roots"],
                   funFact: "Rain falls from clouds."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Which season usually has the hottest weather in Texas?",
                   correct: "summer", wrong: ["winter", "fall", "spring"],
                   funFact: "Summer has longer, hotter days."),
                mc(topic: topic, question: "Leaves often fall from trees in ___",
                   correct: "fall", wrong: ["summer", "spring only", "winter only"],
                   funFact: "Some trees lose leaves in autumn."),
                mc(topic: topic, question: "Flowers often bloom in ___",
                   correct: "spring", wrong: ["winter", "deep ocean", "outer space"],
                   funFact: "Spring brings warmer days and new plant growth."),
                mc(topic: topic, question: "Which season is coldest in many places?",
                   correct: "winter", wrong: ["summer", "spring", "fall"],
                   funFact: "Winter days are shorter and colder."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "Rain, snow, and sunshine are examples of ___",
                   correct: "weather", wrong: ["seasons", "habitats", "food chains"],
                   funFact: "Weather is what happens in the sky day to day."),
                mc(topic: topic, question: "A pattern of weather over many years is called ___",
                   correct: "climate", wrong: ["a shadow", "a magnet", "a fraction"],
                   funFact: "Climate describes long-term weather trends."),
                mc(topic: topic, question: "Thermometers measure ___",
                   correct: "temperature", wrong: ["length", "weight only", "sound pitch"],
                   funFact: "Temperature tells how hot or cold it is."),
                mc(topic: topic, question: "Wind is moving ___",
                   correct: "air", wrong: ["water only", "rock", "soil only"],
                   funFact: "Air moves from place to place as wind."),
            ])
        }
    }

    private static func foodChains(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Grass → Rabbit → Fox. What is the rabbit?",
                   correct: "consumer", wrong: ["producer", "decomposer", "sun"],
                   visual: .foodChain(producer: "Grass", herbivore: "Rabbit", carnivore: "Fox"),
                   funFact: "Animals that eat plants are consumers."),
                mc(topic: topic, question: "Sun → Grass → Deer. What is the grass?",
                   correct: "producer", wrong: ["carnivore", "decomposer", "predator"],
                   visual: .foodChain(producer: "Grass", herbivore: "Deer", carnivore: "Wolf"),
                   funFact: "Plants make food using sunlight."),
                mc(topic: topic, question: "What gives energy to most food chains?",
                   correct: "the Sun", wrong: ["the Moon", "rocks", "soil only"],
                   funFact: "Sunlight powers producers."),
                mc(topic: topic, question: "A mushroom that breaks down dead leaves is a ___",
                   correct: "decomposer", wrong: ["producer", "Sun", "herbivore"],
                   funFact: "Decomposers recycle nutrients."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "What do all food chains start with?",
                   correct: "the Sun", wrong: ["a fox", "rocks", "water only"],
                   funFact: "The Sun gives energy to plants."),
                mc(topic: topic, question: "An animal that eats only plants is a ___",
                   correct: "herbivore", wrong: ["carnivore", "producer", "Sun"],
                   funFact: "Herbivores eat producers."),
                mc(topic: topic, question: "An animal that eats other animals is a ___",
                   correct: "carnivore", wrong: ["producer", "decomposer", "root"],
                   funFact: "Carnivores eat meat."),
                mc(topic: topic, question: "Algae → Minnow → Heron. The minnow is a ___",
                   correct: "consumer", wrong: ["producer", "Sun", "decomposer"],
                   funFact: "Consumers get energy by eating other living things."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "In a food chain, a plant is a ___",
                   correct: "producer", wrong: ["carnivore", "decomposer", "predator"],
                   visual: .foodChain(producer: "Grass", herbivore: "Deer", carnivore: "Wolf"),
                   funFact: "Producers make food using sunlight."),
                mc(topic: topic, question: "If rabbits eat too much grass, the grass population may ___",
                   correct: "decrease", wrong: ["turn into rocks", "become the Sun", "stop needing water"],
                   funFact: "Consumers affect producer populations."),
                mc(topic: topic, question: "Energy flows from producers to ___",
                   correct: "consumers", wrong: ["the Moon", "only rocks", "only air"],
                   funFact: "Consumers eat producers or other consumers."),
                mc(topic: topic, question: "Which is at the top of this chain: grass → mouse → owl?",
                   correct: "owl", wrong: ["grass", "mouse", "Sun"],
                   funFact: "Top predators eat other consumers."),
            ])
        }
    }

    private static func scientificMethod(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "A scientist asks a question first. What comes next?",
                   correct: "make a prediction", wrong: ["write the answer", "ignore data", "stop"],
                   funFact: "Scientists predict what they think will happen."),
                mc(topic: topic, question: "Before testing, a scientist often makes a ___",
                   correct: "hypothesis", wrong: ["song", "joke", "map only"],
                   funFact: "A hypothesis is an educated guess."),
                mc(topic: topic, question: "Scientists use their ___ to learn about the world.",
                   correct: "senses", wrong: ["only guesses", "only dreams", "only art"],
                   funFact: "Observations start with seeing, hearing, and measuring."),
                mc(topic: topic, question: "Which step comes first in the scientific method?",
                   correct: "ask a question", wrong: ["ignore results", "skip testing", "hide data"],
                   funFact: "Science begins with curiosity."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Recording what you see in an experiment is called ___",
                   correct: "observing", wrong: ["guessing", "sleeping", "skipping"],
                   funFact: "Good scientists write down their observations."),
                mc(topic: topic, question: "A test to answer a question is called an ___",
                   correct: "experiment", wrong: ["opinion", "story", "song"],
                   funFact: "Experiments provide evidence."),
                mc(topic: topic, question: "Numbers collected during an experiment are called ___",
                   correct: "data", wrong: ["fiction", "weather only", "habitats"],
                   funFact: "Data helps support conclusions."),
                mc(topic: topic, question: "Changing only one thing in a test keeps the experiment ___",
                   correct: "fair", wrong: ["invisible", "magnetic", "frozen"],
                   funFact: "Fair tests change one variable at a time."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "After an experiment, a scientist draws a ___",
                   correct: "conclusion", wrong: ["song", "joke", "map only"],
                   funFact: "A conclusion explains what the results mean."),
                mc(topic: topic, question: "If results do not match the hypothesis, a scientist should ___",
                   correct: "learn from the evidence", wrong: ["change the data", "ignore it", "stop asking questions"],
                   funFact: "Unexpected results can teach us something new."),
                mc(topic: topic, question: "Sharing results helps other scientists ___",
                   correct: "check the work", wrong: ["hide evidence", "skip safety", "avoid thinking"],
                   funFact: "Science builds on shared evidence."),
                mc(topic: topic, question: "Repeating an experiment helps show results are ___",
                   correct: "reliable", wrong: ["magical", "invisible", "unimportant"],
                   funFact: "Repeat tests increase confidence in evidence."),
            ])
        }
    }

    private static func scientistsWork(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Scientists ask questions about the natural world. Is that science or a guess?",
                   correct: "science", wrong: ["just a guess", "only art", "only history"],
                   funFact: "Science uses evidence, not just opinions."),
                mc(topic: topic, question: "Who studies stars and planets?",
                   correct: "astronomer", wrong: ["chef", "pilot", "farmer only"],
                   funFact: "Scientists specialize in different fields."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Why should scientists write down their data?",
                   correct: "to use evidence", wrong: ["to forget it", "to hide results", "to skip thinking"],
                   funFact: "Records help others check and learn from experiments."),
                mc(topic: topic, question: "Is it okay to change your answer when new evidence appears?",
                   correct: "yes", wrong: ["no, never", "only on Fridays", "only if you are wrong on purpose"],
                   funFact: "Good scientists update ideas when evidence changes."),
            ])
        default:
            return mc(topic: topic, question: "Which choice follows safe and honest science?",
                      correct: "report what you actually observed", wrong: ["change data to win", "skip safety goggles", "ignore unexpected results"],
                      funFact: "Ethical science means being honest about what happened.")
        }
    }

    private static func vibrationSound(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "When you pluck a guitar string, it ___ and makes sound.",
                   correct: "vibrates", wrong: ["melts", "freezes", "dissolves"],
                   funFact: "Vibration is a fast back-and-forth motion."),
                mc(topic: topic, question: "A tuning fork makes sound because it ___",
                   correct: "vibrates", wrong: ["reflects light", "absorbs water", "grows"],
                   funFact: "Touch a ringing tuning fork gently — you can feel it buzz!"),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Tighter drum skin vibrates faster and makes a ___ sound.",
                   correct: "higher", wrong: ["lower", "silent", "slower"],
                   funFact: "Faster vibrations usually mean higher pitch."),
                mc(topic: topic, question: "Sound travels through ___ to reach your ears.",
                   correct: "air", wrong: ["empty space with no matter", "only rocks", "only water always"],
                   funFact: "Sound needs matter to travel — air works great!"),
            ])
        default:
            return mc(topic: topic, question: "If an object stops vibrating, the sound will ___",
                      correct: "stop", wrong: ["get louder forever", "turn into light", "become a magnet"],
                      funFact: "No vibration → no sound.")
        }
    }

    private static func severeWeather(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "A spinning column of air that can damage buildings is a ___",
                   correct: "tornado", wrong: ["rainbow", "breeze", "fog"],
                   funFact: "Tornadoes are severe weather — go to a safe indoor room."),
                mc(topic: topic, question: "Weather data can be shown on a ___",
                   correct: "graph", wrong: ["recipe", "puzzle only", "song"],
                   funFact: "Graphs help us see patterns in temperature and rain."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Which severe storm has very strong winds and heavy rain near the ocean?",
                   correct: "hurricane", wrong: ["blizzard in summer", "light drizzle", "morning dew"],
                   funFact: "Hurricanes form over warm ocean water."),
                mc(topic: topic, question: "On a weather graph, the tallest bar means the ___ value.",
                   correct: "greatest", wrong: ["smallest", "zero always", "oldest"],
                   funFact: "Compare bar heights to read data quickly."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "Heavy snow and very cold wind for a long time is a ___",
                   correct: "blizzard", wrong: ["heat wave", "drought", "sunny day"],
                   funFact: "Severe weather looks different in different regions."),
                mc(topic: topic, question: "Why do scientists measure and record daily weather?",
                   correct: "to find patterns", wrong: ["to ignore seasons", "to stop rain", "to change the Sun"],
                   funFact: "Patterns over time help predict weather."),
            ])
        }
    }

    private static func conservation(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Recycling paper helps ___",
                   correct: "save trees", wrong: ["waste water", "pollute air", "use more oil"],
                   funFact: "Recycling gives materials a new life."),
                mc(topic: topic, question: "Turning off unused lights saves ___",
                   correct: "energy", wrong: ["gravity", "magnetism", "shadows"],
                   funFact: "Using less electricity helps conserve resources."),
                mc(topic: topic, question: "Reusing a water bottle helps reduce ___",
                   correct: "trash", wrong: ["sunlight", "gravity", "sound"],
                   funFact: "Reusing means less waste in landfills."),
                mc(topic: topic, question: "Planting trees can help clean the ___",
                   correct: "air", wrong: ["Moon", "magnet", "circuit"],
                   funFact: "Trees take in carbon dioxide and release oxygen."),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Which is a natural resource?",
                   correct: "water", wrong: ["plastic toy", "metal spoon from factory", "paper cup"],
                   funFact: "Natural resources come from Earth."),
                mc(topic: topic, question: "Which resource comes from living trees?",
                   correct: "wood", wrong: ["plastic", "glass", "steel"],
                   funFact: "Wood is renewable when forests are managed well."),
                mc(topic: topic, question: "Oil and coal are ___ resources.",
                   correct: "nonrenewable", wrong: ["invisible", "magnetic", "liquid only"],
                   funFact: "They take a very long time to form."),
                mc(topic: topic, question: "Solar panels use energy from the ___",
                   correct: "Sun", wrong: ["Moon", "soil", "magnet"],
                   funFact: "Sunlight is a renewable energy source."),
            ])
        default:
            return pick([
                mc(topic: topic, question: "Turning off lights when you leave saves ___",
                   correct: "energy", wrong: ["gravity", "soil", "wind only"],
                   funFact: "Saving energy helps the environment."),
                mc(topic: topic, question: "Composting food scraps returns nutrients to ___",
                   correct: "soil", wrong: ["the Moon", "magnet", "circuit"],
                   funFact: "Compost helps gardens grow."),
                mc(topic: topic, question: "Pollution can harm animals by dirtying their ___",
                   correct: "habitat", wrong: ["birthday", "fraction", "number line"],
                   funFact: "Clean habitats help ecosystems stay healthy."),
                mc(topic: topic, question: "Using both sides of paper reduces ___",
                   correct: "waste", wrong: ["gravity", "magnetism", "sound waves"],
                   funFact: "Less waste means fewer resources used."),
            ])
        }
    }

    // MARK: - 3rd Grade Science

    private static func sci3Investigation(topic: Topic, difficulty: Difficulty) -> Problem {
        pick([
            mc(topic: topic, question: "In a fair test, you change only one ___",
               correct: "variable", wrong: ["color of your shoes", "friend", "lunch"],
               funFact: "Change one thing at a time to learn what causes the result."),
            mc(topic: topic, question: "Scientists write down measurements in a ___",
               correct: "data table", wrong: ["song", "joke", "map only"],
               funFact: "Tables organize evidence clearly."),
            mc(topic: topic, question: "A testable idea before experimenting is a ___",
               correct: "hypothesis", wrong: ["habitat", "magnet", "shadow"],
               funFact: "Hypotheses guide fair tests."),
            mc(topic: topic, question: "Repeating a test helps show the results are ___",
               correct: "reliable", wrong: ["magical", "invisible", "unimportant"],
               funFact: "Repeat tests increase confidence in evidence."),
            mc(topic: topic, question: "Which keeps an experiment safe and fair?",
               correct: "follow the plan and wear goggles", wrong: ["change many things at once", "ignore results", "skip records"],
               funFact: "Safety and careful records are part of investigation."),
        ])
    }

    private static func sci3SciencePractices(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "Which tool measures length in science?",
                   correct: "ruler", wrong: ["thermometer", "balance only", "stopwatch only"],
                   funFact: "Scientists pick tools that match what they measure."),
                mc(topic: topic, question: "Scientists share honest results so others can ___",
                   correct: "learn from evidence", wrong: ["win a race", "ignore data", "skip safety"],
                   funFact: "Science builds on evidence everyone can check."),
            ])
        case .medium:
            return scientistsWork(topic: topic, difficulty: difficulty)
        default:
            return mc(topic: topic, question: "Why wear goggles during an experiment?",
                      correct: "protect your eyes", wrong: ["look fashionable", "work slower", "hide results"],
                      funFact: "Safety is part of good science.")
        }
    }

    private static func sci3MechanicalEnergy(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "A rolling ball has ___ energy because it is moving.",
                      correct: "mechanical", wrong: ["sound only", "light only", "magnetic"],
                      funFact: "Moving objects have mechanical energy.")
        case .medium:
            return pick([
                mc(topic: topic, question: "A bigger push usually makes a toy car move ___",
                   correct: "farther", wrong: ["backward only", "slower always", "sideways only"],
                   funFact: "More force can mean more speed and distance."),
                mc(topic: topic, question: "A ramp helps a ball roll because of ___",
                   correct: "gravity", wrong: ["magnetism", "sound", "light"],
                   funFact: "Gravity pulls objects downhill."),
            ])
        default:
            return mc(topic: topic, question: "If you stop pushing a scooter, it slows down because of ___",
                      correct: "friction", wrong: ["photosynthesis", "evaporation", "magnetism"],
                      funFact: "Friction opposes motion.")
        }
    }

    private static func sci3EverydayEnergy(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return pick([
                mc(topic: topic, question: "The Sun gives Earth ___ and light.",
                   correct: "heat", wrong: ["gravity only", "magnetism", "sound"],
                   funFact: "Thermal energy from the Sun warms our planet."),
                soundLight(topic: topic, difficulty: .easy),
            ])
        case .medium:
            return pick([
                mc(topic: topic, question: "Touching a warm sidewalk shows ___ energy.",
                   correct: "thermal", wrong: ["magnetic", "sound", "electrical only"],
                   funFact: "Thermal energy is heat you can feel."),
                energyForms(topic: topic, difficulty: .medium),
            ])
        default:
            return soundLight(topic: topic, difficulty: .hard)
        }
    }

    private static func sci3Conservation(topic: Topic, difficulty: Difficulty) -> Problem {
        conservation(topic: topic, difficulty: difficulty)
    }

    private static func sci3FossilsChanges(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "A fossil is evidence of a living thing from the ___",
                      correct: "past", wrong: ["future", "Moon", "kitchen"],
                      funFact: "Fossils form over a very long time in rock.")
        case .medium:
            return pick([
                mc(topic: topic, question: "A flood can ___ an ecosystem by adding water and moving soil.",
                   correct: "change", wrong: ["freeze time", "stop the Sun", "remove gravity"],
                   funFact: "Natural events can change habitats quickly."),
                foodChains(topic: topic, difficulty: .medium),
            ])
        default:
            return mc(topic: topic, question: "Scientists study fossils to learn how living things ___",
                      correct: "changed over time", wrong: ["never lived", "only eat rocks", "live on the Moon"],
                      funFact: "Fossils are clues about Earth's history.")
        }
    }

    private static func sci3GrowthBehavior(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "Plants grow best with sunlight, water, and the right ___",
                      correct: "temperature", wrong: ["television", "shoes", "magnet"],
                      funFact: "Temperature affects how plants and animals grow.")
        case .medium:
            return pick([
                mc(topic: topic, question: "Less rain in a region can cause plants to ___",
                   correct: "grow slowly or die", wrong: ["grow instantly taller", "turn into metal", "stop needing roots"],
                   funFact: "Precipitation affects plant survival."),
                plantStructures(topic: topic, difficulty: .medium),
            ])
        default:
            return mc(topic: topic, question: "Animals may migrate when seasons change because ___ changes.",
                      correct: "temperature", wrong: ["the Moon's color", "gravity stops", "rocks melt"],
                      funFact: "Behavior helps animals survive changing conditions.")
        }
    }

    private static func sci3MatterStates(topic: Topic, difficulty: Difficulty) -> Problem {
        matterProperties(topic: topic, difficulty: difficulty)
    }

    private static func sci3ForceMagnets(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "A magnet attracts ___",
                      correct: "iron", wrong: ["wood", "plastic", "paper"],
                      funFact: "Magnets stick to some metals like iron.")
        default:
            return forceMotion(topic: topic, difficulty: difficulty)
        }
    }

    private static func sci3EnergyCircuits(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "A complete path for electricity is called a ___",
                      correct: "circuit", wrong: ["magnet", "shadow", "habitat"],
                      funFact: "Electricity flows through a closed circuit.")
        default:
            return energyForms(topic: topic, difficulty: difficulty)
        }
    }

    private static func sci3EarthSoil(topic: Topic, difficulty: Difficulty) -> Problem {
        earthMaterials(topic: topic, difficulty: difficulty)
    }

    private static func sci3SunMoon(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "Earth orbits around the ___",
                      correct: "Sun", wrong: ["Moon", "Mars", "Jupiter"],
                      funFact: "One year is one trip around the Sun.")
        default:
            return skyPatterns(topic: topic, difficulty: difficulty)
        }
    }

    private static func sci3WeatherClimate(topic: Topic, difficulty: Difficulty) -> Problem {
        weatherSeasons(topic: topic, difficulty: difficulty)
    }

    private static func sci3Ecosystems(topic: Topic, difficulty: Difficulty) -> Problem {
        habitats(topic: topic, difficulty: difficulty)
    }

    private static func sci3InheritedTraits(topic: Topic, difficulty: Difficulty) -> Problem {
        switch difficulty {
        case .easy:
            return mc(topic: topic, question: "Eye color passed from parents to child is a ___",
                      correct: "inherited trait", wrong: ["learned skill", "weather pattern", "habitat"],
                      funFact: "Traits you are born with are inherited.")
        default:
            return animalNeeds(topic: topic, difficulty: difficulty)
        }
    }

    private static func sci3LifeCycles(topic: Topic, difficulty: Difficulty) -> Problem {
        lifeCycles(topic: topic, difficulty: difficulty)
    }

    private static func mc(
        topic: Topic,
        question: String,
        correct: String,
        wrong: [String],
        visual: ProblemVisual? = nil,
        funFact: String? = nil
    ) -> Problem {
        var distractors = Array(Set(wrong.filter { $0 != correct })).prefix(3)
        let fillers = ["None of these", "Not sure", "All of them", "Something else"]
        var fillerIndex = 0
        var list = Array(distractors)
        while list.count < 3 && fillerIndex < fillers.count {
            let f = fillers[fillerIndex]
            fillerIndex += 1
            if f != correct && !list.contains(f) { list.append(f) }
        }
        let choices = ProblemGenerator.multipleChoiceOptions(correct: correct, distractors: list)
        return Problem(
            questionText: question,
            visual: visual,
            answerType: .multipleChoice,
            correctAnswer: correct,
            choices: choices,
            teksId: topic.teks,
            funFact: funFact
        )
    }

    private static func pick(_ problems: [Problem]) -> Problem {
        problems.randomElement()!
    }
}

struct ScienceProblemGeneratorEngine: ProblemGenerating {
    let topic: Topic

    var subject: Subject { .science }

    func generate(difficulty: Difficulty) -> Problem {
        ScienceProblemGenerator.generate(topic: topic, difficulty: difficulty)
    }

    func generateSession(difficulty: Difficulty, count: Int) -> [Problem] {
        ScienceProblemGenerator.generateSession(topic: topic, difficulty: difficulty, count: count)
    }
}
