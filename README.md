# Wurdle

A basic Wordle clone implemented using SwiftUI

Mostly done as a learning process for myself. Not all functionality is implemented currently. 

# What works: 
- Layout for iPhone
- Typing in a word
- Progressing from one row to the next
- Rudimentary "game state"
- Color matching when character is in the right spot, somewhere else in the word, or not in the word at all

# TODO:
- Limit typing to 5 characters --> had a basic concept for implementing this but it tanks performance, so need to rethink
- Limit typing to alphabetical characters
- iPad layout
- Landscape layout / lockout
- Unit testing
- General error handling
- Game restart
- Cleaner architecture... not sure I wanna go MVVM route for something like this, but still would like to move more logic out of the views to help facilitate better testing
