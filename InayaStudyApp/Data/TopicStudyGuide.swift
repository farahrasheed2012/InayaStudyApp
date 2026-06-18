import Foundation

struct TopicGuideContent {
    let keyIdea: String
    let vocabulary: [String]
    let workedExampleQuestion: String
    let workedExampleSteps: [String]
    let workedExampleAnswer: String
    let studyTip: String
}

enum TopicStudyGuide {
    private static let guides: [String: TopicGuideContent] = [
        "place-value-1200": TopicGuideContent(
            keyIdea: "Each digit in a number has a place. From right to left: ones, tens, hundreds.",
            vocabulary: ["digit", "ones place", "tens place", "hundreds place", "value"],
            workedExampleQuestion: "What is the value of the 7 in 472?",
            workedExampleSteps: [
                "Find the 7 — it is in the tens place.",
                "Tens place means each digit is worth 10.",
                "7 × 10 = 70, so the 7 is worth 70.",
            ],
            workedExampleAnswer: "70",
            studyTip: "Ask: which place is this digit in? Then multiply by 1, 10, or 100."
        ),
        "compare-order": TopicGuideContent(
            keyIdea: "Compare numbers by looking at the greatest place value first, then move right if needed.",
            vocabulary: ["greater than", "less than", "equal", "order"],
            workedExampleQuestion: "Which is greater: 358 or 385?",
            workedExampleSteps: [
                "Both have 3 hundreds — tie at hundreds.",
                "Compare tens: 5 tens vs 8 tens.",
                "8 tens is more, so 385 is greater.",
            ],
            workedExampleAnswer: "385",
            studyTip: "Line up numbers by place value. Compare from left to right."
        ),
        "add-sub-1000": TopicGuideContent(
            keyIdea: "Add or subtract by lining up ones, tens, and hundreds. Regroup when a column is 10 or more.",
            vocabulary: ["sum", "difference", "regroup", "borrow"],
            workedExampleQuestion: "What is 247 + 156?",
            workedExampleSteps: [
                "Add ones: 7 + 6 = 13. Write 3, carry 1.",
                "Add tens: 4 + 5 + 1 = 10. Write 0, carry 1.",
                "Add hundreds: 2 + 1 + 1 = 4.",
            ],
            workedExampleAnswer: "403",
            studyTip: "Always start with the ones column. Regroup 10 ones as 1 ten."
        ),
        "skip-counting": TopicGuideContent(
            keyIdea: "Skip counting means adding the same number again and again to make a pattern.",
            vocabulary: ["skip count", "pattern", "interval"],
            workedExampleQuestion: "Skip count by 5s starting at 10. What comes next after 20?",
            workedExampleSteps: [
                "The pattern is +5 each time.",
                "After 20, add 5.",
                "20 + 5 = 25.",
            ],
            workedExampleAnswer: "25",
            studyTip: "Say the pattern out loud: 10, 15, 20, 25…"
        ),
        "even-odd": TopicGuideContent(
            keyIdea: "Even numbers can be split into two equal groups. Odd numbers always have one left over.",
            vocabulary: ["even", "odd", "pair"],
            workedExampleQuestion: "Is 14 even or odd?",
            workedExampleSteps: [
                "Look at the ones digit: 4.",
                "4 can make pairs (2 + 2).",
                "So 14 is even.",
            ],
            workedExampleAnswer: "even",
            studyTip: "Check the last digit: 0, 2, 4, 6, 8 are even."
        ),
        "fractions-basic": TopicGuideContent(
            keyIdea: "A fraction shows equal parts of a whole. The bottom number tells how many parts; the top tells how many you have.",
            vocabulary: ["numerator", "denominator", "equal parts", "whole"],
            workedExampleQuestion: "A pizza is cut into 4 equal slices. You eat 1. What fraction did you eat?",
            workedExampleSteps: [
                "4 equal parts means denominator 4.",
                "You ate 1 slice — numerator 1.",
                "The fraction is ¼.",
            ],
            workedExampleAnswer: "1/4",
            studyTip: "Denominator = total equal parts. Numerator = parts you are talking about."
        ),
        "time-minutes": TopicGuideContent(
            keyIdea: "The short hand shows the hour. The long hand shows minutes. Each number on the clock is 5 minutes.",
            vocabulary: ["hour hand", "minute hand", "o'clock", "half past"],
            workedExampleQuestion: "The hour hand is on 3 and the minute hand is on 6. What time is it?",
            workedExampleSteps: [
                "Hour hand near 3 → 3 o'clock hour.",
                "Minute hand on 6 → 6 × 5 = 30 minutes.",
                "Time is 3:30.",
            ],
            workedExampleAnswer: "3:30",
            studyTip: "Count by 5s around the clock for the minute hand."
        ),
        "money-coins": TopicGuideContent(
            keyIdea: "Add coin values: penny = 1¢, nickel = 5¢, dime = 10¢, quarter = 25¢.",
            vocabulary: ["cent", "penny", "nickel", "dime", "quarter"],
            workedExampleQuestion: "You have 2 dimes and 1 nickel. How much money?",
            workedExampleSteps: [
                "2 dimes = 10 + 10 = 20¢.",
                "1 nickel = 5¢.",
                "20 + 5 = 25¢.",
            ],
            workedExampleAnswer: "25",
            studyTip: "Group dimes first (easy tens), then nickels and pennies."
        ),
        "measurement-length": TopicGuideContent(
            keyIdea: "Use a ruler to measure from 0 to the end of the object. Know inches and centimeters.",
            vocabulary: ["length", "inch", "centimeter", "ruler", "estimate"],
            workedExampleQuestion: "A pencil starts at 0 in and ends at 5 in on a ruler. How long is it?",
            workedExampleSteps: [
                "Start at 0, not the edge of the ruler.",
                "End is at the 5 inch mark.",
                "Length = 5 inches.",
            ],
            workedExampleAnswer: "5 inches",
            studyTip: "Always align one end of the object with 0 on the ruler."
        ),
        "multiplication": TopicGuideContent(
            keyIdea: "Multiplication is repeated addition. 4 × 3 means 4 groups of 3.",
            vocabulary: ["factor", "product", "times", "groups of"],
            workedExampleQuestion: "What is 4 × 3?",
            workedExampleSteps: [
                "Think: 4 groups of 3.",
                "3 + 3 + 3 + 3 = 12.",
                "Or count by 3 four times.",
            ],
            workedExampleAnswer: "12",
            studyTip: "Use arrays: rows × columns = total."
        ),
        "division": TopicGuideContent(
            keyIdea: "Division splits a total into equal groups. It is the opposite of multiplication.",
            vocabulary: ["divide", "quotient", "equal groups", "remainder"],
            workedExampleQuestion: "12 ÷ 3 = ?",
            workedExampleSteps: [
                "How many groups of 3 make 12?",
                "3, 6, 9, 12 — that's 4 groups.",
                "12 ÷ 3 = 4.",
            ],
            workedExampleAnswer: "4",
            studyTip: "Ask: 3 times what equals 12?"
        ),
        "arrays-area-model": TopicGuideContent(
            keyIdea: "An array is rows and columns of dots. Rows × columns equals the total.",
            vocabulary: ["array", "rows", "columns", "area model"],
            workedExampleQuestion: "A array has 3 rows and 4 columns. How many in all?",
            workedExampleSteps: [
                "Count rows: 3.",
                "Count columns: 4.",
                "3 × 4 = 12.",
            ],
            workedExampleAnswer: "12",
            studyTip: "Draw the array and count, or multiply rows × columns."
        ),
        "fractions-number-line": TopicGuideContent(
            keyIdea: "Fractions live between 0 and 1 on a number line. Denominator tells how many equal parts from 0 to 1.",
            vocabulary: ["number line", "benchmark", "equivalent"],
            workedExampleQuestion: "Place ½ on a line from 0 to 1 split into 2 parts.",
            workedExampleSteps: [
                "Split 0 to 1 into 2 equal parts.",
                "½ is exactly halfway.",
                "It is on the middle tick.",
            ],
            workedExampleAnswer: "middle",
            studyTip: "More denominator parts = smaller each part."
        ),
        "compare-fractions": TopicGuideContent(
            keyIdea: "Same denominator → compare numerators. Same numerator → bigger denominator means smaller fraction.",
            vocabulary: ["greater", "less", "equivalent", "common denominator"],
            workedExampleQuestion: "Which is larger: 3/8 or 5/8?",
            workedExampleSteps: [
                "Same denominator 8.",
                "Compare numerators: 5 > 3.",
                "5/8 is larger.",
            ],
            workedExampleAnswer: "5/8",
            studyTip: "Think of pizza slices — more slices of the same size means more."
        ),
        "elapsed-time": TopicGuideContent(
            keyIdea: "Elapsed time is how long from a start time to an end time. Count forward on a clock or number line.",
            vocabulary: ["elapsed", "start time", "end time", "duration"],
            workedExampleQuestion: "Start 2:00, end 2:45. How many minutes passed?",
            workedExampleSteps: [
                "From 2:00 to 2:45 is within the same hour.",
                "45 minutes on the clock.",
                "Elapsed time = 45 minutes.",
            ],
            workedExampleAnswer: "45 minutes",
            studyTip: "Break it up: jump to the next hour, then add leftover minutes."
        ),
        "perimeter-area": TopicGuideContent(
            keyIdea: "Perimeter is distance around a shape (add all sides). Area is space inside (length × width for rectangles).",
            vocabulary: ["perimeter", "area", "length", "width", "square units"],
            workedExampleQuestion: "A rectangle is 4 cm by 3 cm. What is the area?",
            workedExampleSteps: [
                "Area = length × width.",
                "4 × 3 = 12.",
                "Area = 12 square cm.",
            ],
            workedExampleAnswer: "12",
            studyTip: "Perimeter = add sides. Area = multiply for rectangles."
        ),
        "data-graphs": TopicGuideContent(
            keyIdea: "Bar graphs show how many in each category. Tally the height of each bar to read the data.",
            vocabulary: ["bar graph", "category", "scale", "tally"],
            workedExampleQuestion: "A bar for apples reaches 6 on the graph. How many apples?",
            workedExampleSteps: [
                "Read the top of the bar.",
                "Match it to the scale on the side.",
                "The answer is 6.",
            ],
            workedExampleAnswer: "6",
            studyTip: "Check the scale — sometimes each line is 1, sometimes 2 or 5."
        ),
        "money-word-problems": TopicGuideContent(
            keyIdea: "Read carefully: are you adding money, subtracting change, or comparing?",
            vocabulary: ["total", "change", "cost", "difference"],
            workedExampleQuestion: "A toy costs $3 and you pay $5. How much change?",
            workedExampleSteps: [
                "You pay more than the cost.",
                "Subtract: 5 − 3 = 2.",
                "Change is $2.",
            ],
            workedExampleAnswer: "2",
            studyTip: "Underline what the question asks: total, change, or left over?"
        ),
        "staar-mixed": TopicGuideContent(
            keyIdea: "STAAR review mixes many 3rd grade skills. Read each question twice and decide which skill it uses.",
            vocabulary: ["multi-step", "estimate", "reasonableness"],
            workedExampleQuestion: "Mixed practice — use the skill each question reminds you of.",
            workedExampleSteps: [
                "Read the whole question.",
                "Identify: add, multiply, fractions, or time?",
                "Solve step by step.",
            ],
            workedExampleAnswer: "varies",
            studyTip: "If stuck, eliminate wrong answers and check your work."
        ),
        "sci-matter-properties": TopicGuideContent(
            keyIdea: "Matter is anything that takes up space. Properties describe how it looks, feels, and behaves.",
            vocabulary: ["solid", "liquid", "gas", "mass", "volume"],
            workedExampleQuestion: "Is a rock a solid, liquid, or gas?",
            workedExampleSteps: [
                "A rock keeps its shape.",
                "It does not flow like a liquid.",
                "It is a solid.",
            ],
            workedExampleAnswer: "solid",
            studyTip: "Solid = fixed shape. Liquid = takes container shape. Gas = spreads out."
        ),
        "sci-matter-changes": TopicGuideContent(
            keyIdea: "Heating or cooling can change matter. Some changes can reverse (ice ↔ water); some cannot (burning wood).",
            vocabulary: ["physical change", "chemical change", "reversible", "irreversible"],
            workedExampleQuestion: "Ice melting into water — reversible or not?",
            workedExampleSteps: [
                "Ice can freeze again.",
                "The water is still H₂O.",
                "It is a reversible physical change.",
            ],
            workedExampleAnswer: "reversible",
            studyTip: "Reversible = can change back. Burning is usually not reversible."
        ),
        "sci-force-motion": TopicGuideContent(
            keyIdea: "A push or pull is a force. Forces can start, stop, or change the direction of motion.",
            vocabulary: ["force", "push", "pull", "motion", "speed"],
            workedExampleQuestion: "You kick a ball. Is that a push or pull?",
            workedExampleSteps: [
                "Your foot moves the ball away.",
                "Away from you = push.",
                "A kick is a push.",
            ],
            workedExampleAnswer: "push",
            studyTip: "Push moves away. Pull brings closer."
        ),
        "sci-energy-forms": TopicGuideContent(
            keyIdea: "Energy makes things happen. Forms include light, heat, sound, and electrical energy.",
            vocabulary: ["energy", "light", "heat", "sound", "electricity"],
            workedExampleQuestion: "A lamp glows. What form of energy do you see?",
            workedExampleSteps: [
                "The bulb gives off light.",
                "You can see it light up the room.",
                "Light energy.",
            ],
            workedExampleAnswer: "light",
            studyTip: "Match what you observe: bright = light, warm = heat, noise = sound."
        ),
        "sci-sound-light": TopicGuideContent(
            keyIdea: "Sound travels through vibrations. Light can pass through transparent materials but not opaque ones.",
            vocabulary: ["vibration", "transparent", "opaque", "volume", "pitch"],
            workedExampleQuestion: "Can you see through a window?",
            workedExampleSteps: [
                "Glass lets light pass through.",
                "That means it is transparent.",
                "Yes, you can see through it.",
            ],
            workedExampleAnswer: "yes",
            studyTip: "Transparent = see through. Opaque = blocks light."
        ),
        "sci-earth-materials": TopicGuideContent(
            keyIdea: "Rocks, soil, and water are natural earth materials. They come from nature, not factories.",
            vocabulary: ["rock", "soil", "clay", "sand", "natural"],
            workedExampleQuestion: "Is a river rock a natural material?",
            workedExampleSteps: [
                "Rocks form in nature over time.",
                "No factory makes river rocks.",
                "Yes, it is natural.",
            ],
            workedExampleAnswer: "yes",
            studyTip: "Natural = found in nature. Manufactured = made by people."
        ),
        "sci-sky-patterns": TopicGuideContent(
            keyIdea: "The Sun, Moon, and stars follow patterns. The Sun appears to move across the sky during the day.",
            vocabulary: ["Sun", "Moon", "stars", "day", "night"],
            workedExampleQuestion: "When do we usually see the Sun?",
            workedExampleSteps: [
                "The Sun gives daylight.",
                "It is up during daytime.",
                "We see it during the day.",
            ],
            workedExampleAnswer: "day",
            studyTip: "Sun = day sky. Stars = night sky (plus the Moon)."
        ),
        "sci-plant-structures": TopicGuideContent(
            keyIdea: "Plants have roots, stems, and leaves. Roots take in water; leaves make food using sunlight.",
            vocabulary: ["roots", "stem", "leaves", "photosynthesis"],
            workedExampleQuestion: "Which part takes in water from soil?",
            workedExampleSteps: [
                "Roots grow underground.",
                "They soak up water and nutrients.",
                "Roots take in water.",
            ],
            workedExampleAnswer: "roots",
            studyTip: "Roots = below ground. Leaves = food factories."
        ),
        "sci-animal-needs": TopicGuideContent(
            keyIdea: "Animals need food, water, air, and shelter to survive. Body parts help them live in their habitat.",
            vocabulary: ["habitat", "adaptation", "survive", "shelter"],
            workedExampleQuestion: "Why do fish have gills?",
            workedExampleSteps: [
                "Fish live underwater.",
                "Gills take oxygen from water.",
                "Gills help them breathe in water.",
            ],
            workedExampleAnswer: "breathe underwater",
            studyTip: "Match the body part to what the animal needs in its home."
        ),
        "sci-life-cycles": TopicGuideContent(
            keyIdea: "Living things grow and change in stages: egg → young → adult, or seed → plant.",
            vocabulary: ["life cycle", "egg", "larva", "adult", "seed"],
            workedExampleQuestion: "What comes first in a butterfly life cycle?",
            workedExampleSteps: [
                "Butterflies start as eggs on a leaf.",
                "Then caterpillar, then chrysalis, then butterfly.",
                "Egg comes first.",
            ],
            workedExampleAnswer: "egg",
            studyTip: "Draw the cycle in a circle — order matters!"
        ),
        "sci-habitats": TopicGuideContent(
            keyIdea: "A habitat is where a plant or animal lives. It must have everything they need to survive.",
            vocabulary: ["habitat", "desert", "forest", "ocean", "environment"],
            workedExampleQuestion: "Where would a cactus live best?",
            workedExampleSteps: ["Cacti store water for dry places.", "Deserts are hot and dry.", "Desert habitat."],
            workedExampleAnswer: "desert",
            studyTip: "Think about what food, water, and shelter exist in each place."
        ),
        "compose-decompose": TopicGuideContent(
            keyIdea: "Numbers can be written in standard form (352) or expanded form (300 + 50 + 2).",
            vocabulary: ["standard form", "expanded form", "hundreds", "tens", "ones"],
            workedExampleQuestion: "What is 247 in expanded form?",
            workedExampleSteps: ["2 hundreds = 200", "4 tens = 40", "7 ones = 7", "200 + 40 + 7"],
            workedExampleAnswer: "200 + 40 + 7",
            studyTip: "Each digit has a place value — multiply by 100, 10, or 1."
        ),
        "word-problems-addsub-2": TopicGuideContent(
            keyIdea: "Read the story. Decide: are you putting together (add) or taking away (subtract)?",
            vocabulary: ["total", "difference", "more", "left"],
            workedExampleQuestion: "Maya has 12 stickers. She gets 5 more. How many now?",
            workedExampleSteps: ["Key words: gets more → add", "12 + 5", "17 stickers"],
            workedExampleAnswer: "17",
            studyTip: "Underline the numbers and circle the action word."
        ),
        "fraction-models": TopicGuideContent(
            keyIdea: "Fractions show equal parts of a whole. The bottom number tells how many parts; the top tells how many are shaded.",
            vocabulary: ["numerator", "denominator", "equal parts", "whole"],
            workedExampleQuestion: "A pizza is cut into 4 equal slices. You eat 1. What fraction?",
            workedExampleSteps: ["4 equal parts total", "1 part eaten", "1/4"],
            workedExampleAnswer: "1/4",
            studyTip: "Count the shaded parts, then count all parts."
        ),
        "arrays-groups-2": TopicGuideContent(
            keyIdea: "Equal groups can be shown in rows and columns. Rows × columns = total.",
            vocabulary: ["array", "rows", "columns", "equal groups"],
            workedExampleQuestion: "3 rows of 4 stars. How many stars?",
            workedExampleSteps: ["Count rows: 3", "Each row has 4", "3 × 4 = 12"],
            workedExampleAnswer: "12",
            studyTip: "Picture equal groups before you multiply."
        ),
        "shapes-2d-3d": TopicGuideContent(
            keyIdea: "2D shapes are flat. 3D shapes take up space — like cubes and spheres.",
            vocabulary: ["triangle", "rectangle", "cube", "sphere", "faces", "sides"],
            workedExampleQuestion: "How many faces does a cube have?",
            workedExampleSteps: ["A cube is like a box", "Top, bottom, front, back, two sides", "6 square faces"],
            workedExampleAnswer: "6",
            studyTip: "2D = flat drawing. 3D = you could hold it."
        ),
        "graphs-data-2": TopicGuideContent(
            keyIdea: "Graphs show information. Tally how many, then compare categories.",
            vocabulary: ["bar graph", "pictograph", "category", "data"],
            workedExampleQuestion: "A bar graph shows Red=5, Blue=3. Which has more?",
            workedExampleSteps: ["Compare bar heights", "5 is greater than 3", "Red has more"],
            workedExampleAnswer: "Red",
            studyTip: "Look at the tallest bar for 'most.'"
        ),
        "measurement-wct": TopicGuideContent(
            keyIdea: "Length uses inches/cm. Weight uses pounds. Capacity uses cups/liters. Temperature uses degrees.",
            vocabulary: ["weight", "capacity", "temperature", "pounds", "degrees"],
            workedExampleQuestion: "What tool measures how hot soup is?",
            workedExampleSteps: ["Hot soup = temperature", "Use a thermometer", "Read degrees"],
            workedExampleAnswer: "thermometer",
            studyTip: "Match the tool to what you're measuring."
        ),
        "staar-mixed-2": TopicGuideContent(
            keyIdea: "STAAR review mixes many 2nd-grade skills. Read carefully and use pictures.",
            vocabulary: ["review", "place value", "fractions", "word problem"],
            workedExampleQuestion: "Practice many skills in one session.",
            workedExampleSteps: ["Read the whole question", "Use your study guide if stuck", "Check your answer"],
            workedExampleAnswer: "—",
            studyTip: "Take your time — you've practiced each skill on the map!"
        ),
        "place-value-100k": TopicGuideContent(
            keyIdea: "Digits have place value: ones, tens, hundreds, thousands, ten-thousands up to 100,000.",
            vocabulary: ["ten-thousands", "thousands", "digit", "value"],
            workedExampleQuestion: "What is the value of 7 in 47,250?",
            workedExampleSteps: ["7 is in the thousands place", "7 × 1,000", "7,000"],
            workedExampleAnswer: "7000",
            studyTip: "Name the place, then multiply by its value."
        ),
        "estimation-rounding": TopicGuideContent(
            keyIdea: "Rounding makes numbers easier. Look at the digit to the right to decide up or down.",
            vocabulary: ["round", "estimate", "nearest ten", "nearest hundred"],
            workedExampleQuestion: "Round 63 to the nearest ten.",
            workedExampleSteps: ["Look at ones digit: 3", "3 < 5, round down", "60"],
            workedExampleAnswer: "60",
            studyTip: "5 or more → round up. 4 or less → round down."
        ),
        "add-sub-1000-3": TopicGuideContent(
            keyIdea: "Add and subtract within 1,000 using place value and regrouping.",
            vocabulary: ["regroup", "sum", "difference"],
            workedExampleQuestion: "What is 456 + 278?",
            workedExampleSteps: ["Add ones: 6+8=14, write 4 carry 1", "Add tens: 5+7+1=13, write 3 carry 1", "Add hundreds: 4+2+1=7", "734"],
            workedExampleAnswer: "734",
            studyTip: "Line up place values before you add or subtract."
        ),
        "two-step-word-problems": TopicGuideContent(
            keyIdea: "Some stories need two steps: add then subtract, or add twice, etc.",
            vocabulary: ["two-step", "first", "then", "total"],
            workedExampleQuestion: "Sam has 20 marbles. He finds 8, then loses 5. How many now?",
            workedExampleSteps: ["First: 20 + 8 = 28", "Then: 28 − 5 = 23", "23 marbles"],
            workedExampleAnswer: "23",
            studyTip: "Solve step by step — don't skip the middle!"
        ),
        "unit-fractions": TopicGuideContent(
            keyIdea: "A unit fraction has 1 on top: 1/2, 1/3, 1/4. It means one equal part.",
            vocabulary: ["unit fraction", "numerator", "denominator"],
            workedExampleQuestion: "A bar is split into 6 equal parts. One part is what fraction?",
            workedExampleSteps: ["6 equal parts", "One part shaded", "1/6"],
            workedExampleAnswer: "1/6",
            studyTip: "Unit = one. Top number is 1."
        ),
        "equivalent-fractions": TopicGuideContent(
            keyIdea: "Equivalent fractions are equal amounts: 1/2 = 2/4 = 4/8.",
            vocabulary: ["equivalent", "equal", "multiply"],
            workedExampleQuestion: "What fraction equals 1/2?",
            workedExampleSteps: ["Multiply top and bottom by 2", "1×2=2, 2×2=4", "2/4"],
            workedExampleAnswer: "2/4",
            studyTip: "Multiply or divide top and bottom by the same number."
        ),
        "shapes-quadrilaterals": TopicGuideContent(
            keyIdea: "Quadrilaterals have 4 sides: squares, rectangles, rhombuses, trapezoids.",
            vocabulary: ["quadrilateral", "parallel", "rhombus", "trapezoid"],
            workedExampleQuestion: "Which shape has 4 equal sides and 4 right angles?",
            workedExampleSteps: ["4 sides", "All equal", "All right angles", "Square"],
            workedExampleAnswer: "square",
            studyTip: "Quad = 4. Count the sides!"
        ),
        "even-odd-3": TopicGuideContent(
            keyIdea: "Even numbers are divisible by 2 with no remainder. Odd numbers are not.",
            vocabulary: ["even", "odd", "divisible", "remainder"],
            workedExampleQuestion: "Is 84 even or odd?",
            workedExampleSteps: ["Look at the ones digit: 4", "4 is even", "84 is even"],
            workedExampleAnswer: "even",
            studyTip: "Ones digit 0, 2, 4, 6, 8 → even."
        ),
        "number-patterns-3": TopicGuideContent(
            keyIdea: "Tables and lists show rules like +5 or ×2 between numbers.",
            vocabulary: ["pattern", "rule", "input", "output"],
            workedExampleQuestion: "3, 8, 13, 18 — what is the rule?",
            workedExampleSteps: ["8 − 3 = 5", "13 − 8 = 5", "Add 5 each time"],
            workedExampleAnswer: "add 5",
            studyTip: "Find what changes from one number to the next."
        ),
        "shapes-3d-3": TopicGuideContent(
            keyIdea: "3D solids have faces, edges, and vertices. Examples: cube, sphere, cylinder, cone.",
            vocabulary: ["face", "edge", "vertex", "solid"],
            workedExampleQuestion: "Which solid has 6 square faces?",
            workedExampleSteps: ["6 faces", "All squares", "Cube"],
            workedExampleAnswer: "cube",
            studyTip: "A sphere rolls; a cube stacks."
        ),
        "geo-measure-word-problems-3": TopicGuideContent(
            keyIdea: "Perimeter is distance around. Area is space inside. Read carefully which one is asked.",
            vocabulary: ["perimeter", "area", "length", "width"],
            workedExampleQuestion: "A room is 5 m by 4 m. What is the perimeter?",
            workedExampleSteps: ["Perimeter = add all sides", "5 + 4 + 5 + 4", "18 meters"],
            workedExampleAnswer: "18",
            studyTip: "Perimeter = around. Area = inside."
        ),
        "measurement-units-3": TopicGuideContent(
            keyIdea: "Customary: inches, feet, pounds, cups. Metric: cm, m, grams, liters.",
            vocabulary: ["metric", "customary", "gram", "liter"],
            workedExampleQuestion: "How many centimeters in 2 meters?",
            workedExampleSteps: ["1 m = 100 cm", "2 × 100", "200 cm"],
            workedExampleAnswer: "200",
            studyTip: "Match the unit to what you measure."
        ),
        "financial-literacy-3": TopicGuideContent(
            keyIdea: "Earn income, choose to save, spend, or donate. Credit is borrowing to pay later.",
            vocabulary: ["income", "save", "donate", "credit"],
            workedExampleQuestion: "You earn $10 and save $3. How much is left to spend?",
            workedExampleSteps: ["10 − 3", "7 dollars left"],
            workedExampleAnswer: "7",
            studyTip: "Plan needs first, then wants."
        ),
        "sci3-science-practices": TopicGuideContent(
            keyIdea: "Scientists use tools safely, record data, and share honest evidence.",
            vocabulary: ["evidence", "safety", "investigate", "record"],
            workedExampleQuestion: "Why write down observations?",
            workedExampleSteps: ["Data supports conclusions", "Others can check your work", "Evidence"],
            workedExampleAnswer: "to use evidence",
            studyTip: "Good science is safe and honest."
        ),
        "sci3-mechanical-energy": TopicGuideContent(
            keyIdea: "Moving objects have mechanical energy. Forces and friction change speed.",
            vocabulary: ["mechanical energy", "motion", "friction", "gravity"],
            workedExampleQuestion: "Why does a ball roll downhill?",
            workedExampleSteps: ["Gravity pulls down", "Ball moves", "Mechanical energy"],
            workedExampleAnswer: "gravity",
            studyTip: "Push harder → often moves faster."
        ),
        "sci3-everyday-energy": TopicGuideContent(
            keyIdea: "Energy appears as light, sound, and heat (thermal) in daily life.",
            vocabulary: ["thermal", "light", "sound", "energy"],
            workedExampleQuestion: "What energy do you feel from a warm oven?",
            workedExampleSteps: ["Oven is hot", "Heat energy", "Thermal"],
            workedExampleAnswer: "thermal",
            studyTip: "Sun = light + heat. Drum = sound."
        ),
        "sci3-conservation": TopicGuideContent(
            keyIdea: "We protect soil, water, and other resources by conserving and recycling.",
            vocabulary: ["conserve", "recycle", "resource", "reduce"],
            workedExampleQuestion: "Why protect soil?",
            workedExampleSteps: ["Plants need soil", "Soil forms slowly", "Conservation helps"],
            workedExampleAnswer: "for plants and farming",
            studyTip: "Reduce, reuse, recycle!"
        ),
        "sci3-fossils-changes": TopicGuideContent(
            keyIdea: "Fossils show past life. Floods and other events change ecosystems.",
            vocabulary: ["fossil", "ecosystem", "flood", "change"],
            workedExampleQuestion: "What is a fossil?",
            workedExampleSteps: ["Remains of ancient life", "Preserved in rock", "Evidence from the past"],
            workedExampleAnswer: "evidence from the past",
            studyTip: "Fossils are nature's history book."
        ),
        "sci3-growth-behavior": TopicGuideContent(
            keyIdea: "Temperature and rain affect how plants and animals grow and behave.",
            vocabulary: ["precipitation", "temperature", "migrate", "grow"],
            workedExampleQuestion: "Why do birds fly south in winter?",
            workedExampleSteps: ["Colder temperatures", "Less food", "Migrate for survival"],
            workedExampleAnswer: "warmer place with food",
            studyTip: "Climate affects survival strategies."
        ),
        "sci-mixtures": TopicGuideContent(
            keyIdea: "A mixture combines materials. A solution forms when something dissolves.",
            vocabulary: ["mixture", "solution", "dissolve", "filter"],
            workedExampleQuestion: "Salt in water — mixture or solution?",
            workedExampleSteps: ["Salt disappears in water", "It dissolves evenly", "Solution"],
            workedExampleAnswer: "solution",
            studyTip: "Can you still see the pieces? If not, it may be a solution."
        ),
        "sci-weather-seasons": TopicGuideContent(
            keyIdea: "Weather is day to day. Seasons repeat each year: spring, summer, fall, winter.",
            vocabulary: ["weather", "season", "temperature", "precipitation"],
            workedExampleQuestion: "What season is coldest in Texas?",
            workedExampleSteps: ["Winter is coldest", "December–February", "Winter"],
            workedExampleAnswer: "winter",
            studyTip: "Weather = today. Season = time of year."
        ),
        "sci-food-chains": TopicGuideContent(
            keyIdea: "Energy flows: Sun → producer → consumer. A food chain shows who eats whom.",
            vocabulary: ["producer", "consumer", "decomposer", "energy"],
            workedExampleQuestion: "Grass → Grasshopper → Bird. What is grass?",
            workedExampleSteps: ["Grass makes food from Sun", "Plants are producers", "Producer"],
            workedExampleAnswer: "producer",
            studyTip: "All chains start with the Sun and a plant."
        ),
        "sci-scientific-method": TopicGuideContent(
            keyIdea: "Scientists ask questions, predict, test, observe, and conclude.",
            vocabulary: ["hypothesis", "observe", "experiment", "conclusion"],
            workedExampleQuestion: "What do you do after making a prediction?",
            workedExampleSteps: ["Ask a question", "Predict", "Test with an experiment", "Observe results"],
            workedExampleAnswer: "experiment",
            studyTip: "Question → predict → test → conclude."
        ),
        "sci-conservation": TopicGuideContent(
            keyIdea: "We can protect Earth's resources by reducing, reusing, and recycling.",
            vocabulary: ["recycle", "natural resource", "conserve", "reduce"],
            workedExampleQuestion: "Why recycle paper?",
            workedExampleSteps: ["Paper comes from trees", "Recycling saves trees", "Protects forests"],
            workedExampleAnswer: "save trees",
            studyTip: "Small actions add up — turn off lights, recycle, save water."
        ),
        "sci3-investigation": TopicGuideContent(
            keyIdea: "Fair tests change only one variable. Record data and use evidence.",
            vocabulary: ["variable", "control", "data", "evidence"],
            workedExampleQuestion: "Why change only one thing in an experiment?",
            workedExampleSteps: ["So you know what caused the result", "Other things stay the same", "Fair test"],
            workedExampleAnswer: "fair test",
            studyTip: "One change at a time!"
        ),
        "sci3-matter-states": TopicGuideContent(
            keyIdea: "Matter can be solid, liquid, or gas. Heating and cooling can change states.",
            vocabulary: ["solid", "liquid", "gas", "matter"],
            workedExampleQuestion: "Ice melts into water. What state change?",
            workedExampleSteps: ["Ice is solid", "Water is liquid", "Melting"],
            workedExampleAnswer: "melting",
            studyTip: "Heat often melts; cold often freezes."
        ),
        "sci3-force-magnets": TopicGuideContent(
            keyIdea: "Forces push and pull. Magnets attract some metals like iron.",
            vocabulary: ["force", "magnet", "attract", "repel", "gravity"],
            workedExampleQuestion: "What does a magnet attract?",
            workedExampleSteps: ["Magnets pull some metals", "Iron is attracted", "Iron"],
            workedExampleAnswer: "iron",
            studyTip: "Not all metals — iron and steel work best."
        ),
        "sci3-energy-circuits": TopicGuideContent(
            keyIdea: "Electricity flows through a closed circuit. Open circuit = lights off.",
            vocabulary: ["circuit", "electricity", "conductor", "insulator"],
            workedExampleQuestion: "Why won't a bulb light with a broken wire?",
            workedExampleSteps: ["Electricity needs a complete path", "Broken wire = open circuit", "No complete path"],
            workedExampleAnswer: "open circuit",
            studyTip: "Complete loop = closed circuit."
        ),
        "sci3-earth-soil": TopicGuideContent(
            keyIdea: "Rocks, soil, and water make up Earth's surface. Soil has layers.",
            vocabulary: ["soil", "rock", "erosion", "landform"],
            workedExampleQuestion: "What wears rock down over time?",
            workedExampleSteps: ["Wind and water hit rocks", "Pieces break off", "Erosion"],
            workedExampleAnswer: "erosion",
            studyTip: "Water, wind, and ice change land slowly."
        ),
        "sci3-sun-moon": TopicGuideContent(
            keyIdea: "Earth rotates (day/night) and revolves around the Sun (year). The Moon orbits Earth.",
            vocabulary: ["rotate", "revolve", "orbit", "axis"],
            workedExampleQuestion: "What causes day and night?",
            workedExampleSteps: ["Earth spins on its axis", "Sun shines on one side", "Rotation"],
            workedExampleAnswer: "Earth's rotation",
            studyTip: "Spin = day/night. Trip around Sun = year."
        ),
        "sci3-weather-climate": TopicGuideContent(
            keyIdea: "Weather is short-term. Climate is the pattern over many years.",
            vocabulary: ["climate", "weather", "precipitation", "temperature"],
            workedExampleQuestion: "Is 'rainy today' weather or climate?",
            workedExampleSteps: ["Today = short term", "That's weather", "Weather"],
            workedExampleAnswer: "weather",
            studyTip: "Climate = usual pattern. Weather = right now."
        ),
        "sci3-ecosystems": TopicGuideContent(
            keyIdea: "An ecosystem includes living and nonliving parts that interact.",
            vocabulary: ["ecosystem", "population", "community", "food web"],
            workedExampleQuestion: "Pond + fish + plants + rocks = ?",
            workedExampleSteps: ["Living and nonliving together", "They interact", "Ecosystem"],
            workedExampleAnswer: "ecosystem",
            studyTip: "Everything connected in a habitat."
        ),
        "sci3-inherited-traits": TopicGuideContent(
            keyIdea: "Traits from parents are inherited. Learned behaviors are not.",
            vocabulary: ["inherited", "trait", "learned", "offspring"],
            workedExampleQuestion: "Is eye color inherited or learned?",
            workedExampleSteps: ["Born with it", "From parents", "Inherited"],
            workedExampleAnswer: "inherited",
            studyTip: "Born with it = inherited. Practice = learned."
        ),
        "sci3-life-cycles": TopicGuideContent(
            keyIdea: "Plants and animals pass through life stages: egg, young, adult.",
            vocabulary: ["metamorphosis", "life cycle", "stage", "adult"],
            workedExampleQuestion: "Butterfly: egg → ? → chrysalis → butterfly",
            workedExampleSteps: ["After egg comes caterpillar", "Caterpillar = larva", "caterpillar"],
            workedExampleAnswer: "caterpillar",
            studyTip: "Draw the cycle — order matters."
        ),
        "sci3-mixed-review": TopicGuideContent(
            keyIdea: "Review all 3rd-grade science strands: matter, force, Earth, life.",
            vocabulary: ["review", "ecosystem", "circuit", "life cycle"],
            workedExampleQuestion: "Use what you learned on the science map.",
            workedExampleSteps: ["Read carefully", "Think about the big idea", "Use fun facts"],
            workedExampleAnswer: "—",
            studyTip: "You've got this — practice makes progress!"
        ),
        "facts-to-100": TopicGuideContent(
            keyIdea: "Practice adding and subtracting numbers up to 100 until the facts feel quick.",
            vocabulary: ["sum", "difference", "fact", "fluency"],
            workedExampleQuestion: "What is 37 + 25?",
            workedExampleSteps: ["Add ones: 7 + 5 = 12, write 2 carry 1", "Add tens: 3 + 2 + 1 = 6", "Answer 62"],
            workedExampleAnswer: "62",
            studyTip: "Start with easier facts and build speed over time."
        ),
        "more-or-less-100": TopicGuideContent(
            keyIdea: "10 more means add 10. 10 less means subtract 10. Same for 100!",
            vocabulary: ["more than", "less than", "ten", "hundred"],
            workedExampleQuestion: "What is 10 more than 458?",
            workedExampleSteps: ["Start at 458", "Add 10", "468"],
            workedExampleAnswer: "468",
            studyTip: "Only the tens digit changes when you add 10."
        ),
        "number-line-1200": TopicGuideContent(
            keyIdea: "A number line shows order. Numbers increase to the right.",
            vocabulary: ["number line", "interval", "between", "mark"],
            workedExampleQuestion: "On a line marked 200, 250, 300 — what is at 250?",
            workedExampleSteps: ["Find the middle tick between 200 and 300", "That is 250"],
            workedExampleAnswer: "250",
            studyTip: "Use the scale — count the jumps between marks."
        ),
        "number-word-form": TopicGuideContent(
            keyIdea: "Word form says the number in words: 347 = three hundred forty-seven.",
            vocabulary: ["word form", "standard form", "hundred", "thousand"],
            workedExampleQuestion: "Write 512 in word form.",
            workedExampleSteps: ["5 hundreds = five hundred", "12 = twelve", "five hundred twelve"],
            workedExampleAnswer: "five hundred twelve",
            studyTip: "Say it aloud — no \"and\" needed in school word form."
        ),
        "equal-sharing-2": TopicGuideContent(
            keyIdea: "Equal sharing splits a total into fair, same-size groups.",
            vocabulary: ["share", "equal groups", "divide", "fair"],
            workedExampleQuestion: "12 cookies shared by 3 friends — how many each?",
            workedExampleSteps: ["12 total", "3 equal groups", "12 ÷ 3 = 4 each"],
            workedExampleAnswer: "4",
            studyTip: "Deal one to each friend until none are left."
        ),
        "area-square-units-2": TopicGuideContent(
            keyIdea: "Area counts square units inside a shape with no gaps or overlaps.",
            vocabulary: ["area", "square unit", "row", "column"],
            workedExampleQuestion: "A shape is 3 units wide and 2 units tall. Area?",
            workedExampleSteps: ["Count squares in each row: 3", "2 rows", "3 × 2 = 6 square units"],
            workedExampleAnswer: "6",
            studyTip: "Multiply length × width for rectangles."
        ),
        "financial-literacy-2": TopicGuideContent(
            keyIdea: "Saving keeps money for later. Spending uses money now. Deposits add; withdrawals take out.",
            vocabulary: ["save", "spend", "deposit", "withdrawal", "need", "want"],
            workedExampleQuestion: "Inaya puts $2 in her bank each week. What is she doing?",
            workedExampleSteps: ["Money goes into savings", "Not spending it now", "Saving"],
            workedExampleAnswer: "saving",
            studyTip: "Needs come first; wants can wait."
        ),
        "measurement-metric-2": TopicGuideContent(
            keyIdea: "Centimeters measure small lengths. Meters measure longer lengths. 1 meter = 100 cm.",
            vocabulary: ["centimeter", "meter", "metric", "length"],
            workedExampleQuestion: "How many centimeters in 2 meters?",
            workedExampleSteps: ["1 meter = 100 cm", "2 meters = 200 cm"],
            workedExampleAnswer: "200",
            studyTip: "Use cm for books and pencils; meters for rooms and ropes."
        ),
        "sci-scientists-work": TopicGuideContent(
            keyIdea: "Scientists ask questions, investigate fairly, use evidence, and share honest results.",
            vocabulary: ["evidence", "investigate", "ethics", "scientist"],
            workedExampleQuestion: "Should a scientist report what they really observed?",
            workedExampleSteps: ["Science uses real evidence", "Honest records help everyone learn", "Yes"],
            workedExampleAnswer: "yes",
            studyTip: "It's okay to change your mind when new evidence appears!"
        ),
        "sci-vibration-sound": TopicGuideContent(
            keyIdea: "Sound happens when something vibrates — moves back and forth very fast.",
            vocabulary: ["vibration", "pitch", "sound wave", "volume"],
            workedExampleQuestion: "Why does a drum make sound when you hit it?",
            workedExampleSteps: ["The drum skin moves back and forth", "That is vibration", "Vibration pushes air and makes sound"],
            workedExampleAnswer: "vibration",
            studyTip: "Tighter strings or skins often make higher sounds."
        ),
        "sci-severe-weather": TopicGuideContent(
            keyIdea: "Severe weather can be dangerous. Scientists measure and graph weather to find patterns.",
            vocabulary: ["tornado", "hurricane", "blizzard", "data", "graph"],
            workedExampleQuestion: "What tool helps show rainy days across a month?",
            workedExampleSteps: ["Collect weather data each day", "Put counts on a graph", "A bar graph or pictograph"],
            workedExampleAnswer: "graph",
            studyTip: "Know your region — Texas sees tornadoes and hurricanes near the coast."
        ),
        "sci2-mixed-review": TopicGuideContent(
            keyIdea: "Review all 2nd-grade science: matter, force, Earth, weather, and life.",
            vocabulary: ["review", "habitat", "vibration", "weather"],
            workedExampleQuestion: "Use everything you learned on the science map.",
            workedExampleSteps: ["Read the question twice", "Think about the big idea", "Use Sparky's hints"],
            workedExampleAnswer: "—",
            studyTip: "You've explored every world — show what you know!"
        ),
        "sci-science-tools": TopicGuideContent(
            keyIdea: "Scientists use tools to observe and measure safely: rulers, thermometers, hand lenses, goggles.",
            vocabulary: ["ruler", "thermometer", "hand lens", "safety goggles"],
            workedExampleQuestion: "What tool measures temperature?",
            workedExampleSteps: [
                "Temperature is how hot or cold.",
                "A thermometer shows degrees.",
                "Use a thermometer.",
            ],
            workedExampleAnswer: "thermometer",
            studyTip: "Match the tool to what you measure: length → ruler, temp → thermometer."
        ),
    ]

    static func guide(for topic: Topic) -> TopicGuideContent {
        guides[topic.id] ?? defaultGuide(for: topic)
    }

    static func explanation(for problem: Problem, topic: Topic) -> String {
        let answer = problem.correctAnswer
        if let fact = problem.funFact, !fact.isEmpty {
            return "The answer is \(answer). \(fact)"
        }
        if let hint = problem.hint, !hint.isEmpty {
            return "The answer is \(answer). \(hint)"
        }
        let tip = guide(for: topic).studyTip
        return "The answer is \(answer). \(tip)"
    }

    private static func defaultGuide(for topic: Topic) -> TopicGuideContent {
        TopicGuideContent(
            keyIdea: "Practice \(topic.name) step by step. TEKS \(topic.teks) — take your time and use pictures.",
            vocabulary: [topic.name, "TEKS \(topic.teks)"],
            workedExampleQuestion: "Read each question carefully.",
            workedExampleSteps: ["Look at any picture.", "Think about what the question asks.", "Check your work."],
            workedExampleAnswer: "—",
            studyTip: "Use the hint button if Sparky can help!"
        )
    }
}
