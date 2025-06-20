const sampleQuiz = [
  {
    "type": "mcq",
    "difficulty": "easy",
    "question": "What does `print()` do in Python?",
    "options": ["Takes input", "Prints output", "Declares variable", "Creates a loop"],
    "answer": "Prints output"
  },
  {
    "type": "mcq",
    "difficulty": "easy",
    "question": "Which of the following is a valid Python variable name?",
    "options": ["2variable", "variable_name", "variable-name", "variable name"],
    "answer": "variable_name"
  },
  {
    "type": "mcq",
    "difficulty": "easy",
    "question": "What is the correct way to create a list in Python?",
    "options": ["list = {1, 2, 3}", "list = [1, 2, 3]", "list = (1, 2, 3)", "list = <1, 2, 3>"],
    "answer": "list = [1, 2, 3]"
  },
  {
    "type": "mcq",
    "difficulty": "medium",
    "question": "What is the output of `len('Hello World')`?",
    "options": ["10", "11", "12", "Error"],
    "answer": "11"
  },
  {
    "type": "mcq",
    "difficulty": "medium",
    "question": "Which method is used to add an element to the end of a list?",
    "options": ["add()", "append()", "insert()", "extend()"],
    "answer": "append()"
  },
  {
    "type": "mcq",
    "difficulty": "medium",
    "question": "What does the `range(5)` function return?",
    "options": ["[1, 2, 3, 4, 5]", "[0, 1, 2, 3, 4]", "[0, 1, 2, 3, 4, 5]", "5"],
    "answer": "[0, 1, 2, 3, 4]"
  },
  {
    "type": "mcq",
    "difficulty": "medium",
    "question": "How do you create a dictionary in Python?",
    "options": ["dict = [key: value]", "dict = {key: value}", "dict = (key: value)", "dict = <key: value>"],
    "answer": "dict = {key: value}"
  },
  {
    "type": "mcq",
    "difficulty": "hard",
    "question": "What is the difference between `==` and `is` in Python?",
    "options": [
      "No difference",
      "`==` compares values, `is` compares identity",
      "`==` compares identity, `is` compares values",
      "Both compare identity"
    ],
    "answer": "`==` compares values, `is` compares identity"
  },
  {
    "type": "mcq",
    "difficulty": "hard",
    "question": "What is a lambda function in Python?",
    "options": [
      "A named function",
      "An anonymous function",
      "A class method",
      "A built-in function"
    ],
    "answer": "An anonymous function"
  },
  {
    "type": "mcq",
    "difficulty": "hard",
    "question": "What does `*args` do in a function definition?",
    "options": [
      "Passes keyword arguments",
      "Passes variable number of arguments",
      "Multiplies arguments",
      "Creates a list"
    ],
    "answer": "Passes variable number of arguments"
  },
  {
    "type": "written",
    "question": "Explain the difference between a list and a tuple in Python. Provide examples and use cases for each."
  },
  {
    "type": "written",
    "question": "What is object-oriented programming? Describe the main principles of OOP and how they are implemented in Python."
  },
  {
    "type": "written",
    "question": "Explain exception handling in Python. How do you use try, except, finally blocks? Provide an example."
  },
  {
    "type": "written",
    "question": "What are Python decorators? Explain how they work and provide a simple example of a custom decorator."
  },
  {
    "type": "written",
    "question": "Describe the difference between synchronous and asynchronous programming. How does Python handle asynchronous operations?"
  }
];