Red [
    Title: "Test driver"
    Description: {
        Will run any functions that start with "test" in files inside the tests/ folder that end in "Test.red"
        It'll run a function called 'setUp from the file, before any test functions, if it exists, and 'tearDown afterwards
    }
]

do %lib/helpers.red

testFilenameSuffix: copy "Test.red"
testFunctionNamePrefix: copy "test"

; test files are those that end with "Test.red"
testFiles: findFiles/matching %tests/ lambda [endsWith ? testFilenameSuffix]

; runs all functions that start with test in testFiles
; runs setUp and tearDown functions before each test function, if they exist
foreach testFile testFiles [

    testFileContents: context load testFile        
    testFileObject: testFileContents/tests
    wordsInTestFile: copy words-of testFileObject
    testFunctions: f_filter lambda [startsWith to-string ? testFunctionNamePrefix] wordsInTestFile

    ; actually call each test function; we don't care about the results
    foreach testFunction testFunctions [
        if in testFileObject 'setUp [testFileObject/setUp]
        if error? err: try/all [
            testFileObject/:testFunction
        ] [
            strError: errorToString err
            print strError
            print rejoin [
                newline "#####" newline
                newline
                "test failure: " newline
                "    " testFunction newline 
                "    " "failed in file " testFile newline
            ]
            quit
        ]
        if in testFileObject 'tearDown [testFileObject/tearDown]
    ]
]

print "all tests pass"