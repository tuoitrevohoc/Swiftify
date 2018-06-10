# Swiftify

Toolbox for creating application with Swift using Single Source of Truth & Unidirectional data flow Architect that takes use of Value types and functional programming paradism that would be easy to tests & change.

## State

The truth of the application. It contains the data the view needs to display on the screen.

## Store

A single place-container of the state. It also contains 1 pure function called **the handler** and 1 function to dispatch **actions** to the store.

## Handler
 
A pure function that handle changes by taking the current state and incoming action and calculate the next state.

## Actions

Generated action by user interface, network, ...

## Action Creators

A class who creates actions.

## The views

Where state is displayed to the user.


## Flow

The view subscribe to the **store** to receive the latest state. It render **state** to UI. Whenever an interaction happened, **action creators** create **action** and **dispatch** to **the store**. The store will call **the handler** to calculate the next state. If the state got updated, then **the store** will forward state changes to **the views** those will reflect the changes to UI.



