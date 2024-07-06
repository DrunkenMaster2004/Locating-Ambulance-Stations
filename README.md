
# Ambulance Station Location Optimization

This project aims to optimize the location of ambulance stations to minimize the cost of responding to patient emergencies and transporting them to hospitals. The model considers fixed costs for establishing ambulance stations, variable costs for ambulance travel, and constraints related to station and hospital capacities as well as budget limitations.

## Table of Contents

- [Files Included](#files-included)
- [Model Description](#model-description)
- [Setup Instructions](#setup-instructions)
- [Running the Model](#running-the-model)
- [Results](#results)

## Files Included

- `input_data.xlsx`: Contains the input data for the model including costs, capacities, and patient distribution.
- `input_data.gdx`: GDX file generated from the Excel input data.
- `model.gms`: The GAMS model file containing the optimization problem definition.
- `README.md`: This file.

## Model Description

The model includes the following sets, parameters, variables, and equations:

### Sets
- `i`: Ambulance station locations
- `j`: Patient locations
- `k`: Hospital locations

### Parameters
- `f(i)`: Fixed cost incurred if an ambulance station is located at `i`
- `cost_asp(i,j)`: Cost from ambulance station `i` to patient `j`
- `cost_ph(j,k)`: Cost from patient `j` to hospital `k`
- `cost_has(k,i)`: Cost from hospital `k` to ambulance station
- `capas(i)`: Ambulance station capacity
- `caph(k)`: Hospital capacity
- `p(j)`: Patients in each ward
- `budget`: Total budget available for ambulance operations

### Variables
- `y(i)`: Binary variable indicating if an ambulance station is located at `i`
- `xnasp(i,j)`: Ambulance allocation from station `i` to patient `j`
- `xnph(j,k)`: Patient allocation from `j` to hospital `k`
- `xnhas(k,i)`: Allocation from hospital `k` to station `i`
- `z`: Objective function value (total cost)

### Equations
- Various constraints ensuring capacity limits, demand satisfaction, and budget compliance
- Objective function definition

## Setup Instructions

1. Install GAMS (General Algebraic Modeling System) from the [official website](https://www.gams.com/).
2. Ensure the `input_data.xlsx` file is in the same directory as the GAMS model file (`model.gms`).

## Running the Model

1. Open the GAMS IDE or use the command line.
2. Load the `model.gms` file.
3. Execute the model by running the GAMS job:
    ```sh
    gams model.gms
    ```

## Results

After running the model, the following results will be displayed:
- `y.l`: Locations of ambulance stations (0 or 1 for each location `i`)
- `xnasp.l`: Optimal allocation of ambulances from stations to patients
- `xnph.l`: Optimal patient allocation to hospitals
- `xnhas.l`: Optimal allocation from hospitals back to stations
- `z.l`: Total minimized cost

These results can be interpreted to understand the optimal placement of ambulance stations and the corresponding allocations to minimize the overall response and transportation costs within the given constraints.

