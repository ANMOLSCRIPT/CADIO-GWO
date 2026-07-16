# Multi-UAV 3D Path Planning Mathematical Model

## Problem Description

The objective is to determine an optimal collision-free three-dimensional trajectory for multiple UAVs operating in a constrained environment while minimizing the total flight cost.

Each UAV must travel from its start location to its destination while satisfying all flight constraints.

---

# Decision Variables

Each candidate solution encodes

- Flight segment length
- Heading (yaw) angle
- Pitch angle

For a trajectory with **D** nodes,
$X_i=[l,\rho,\sigma]$

where

- $l$ = segment lengths
- $\rho$ = yaw angles
- $\sigma$ = pitch angles

---

# Coordinate Transformation

The UAV position is updated in Cartesian coordinates using the spherical motion parameters.

For every trajectory node,

$x_t=x_{t-1}+l_t\cos(\sigma_t)\cos(\rho_t)$

$y_t=y_{t-1}+l_t\cos(\sigma_t)\sin(\rho_t)$

$z_t=z_{t-1}+l_t\sin(\sigma_t)$

This converts the optimization variables into the actual UAV flight path.

---

# Trajectory Smoothing

The discrete trajectory nodes are converted into a smooth flight path using

- Cubic quasi-uniform B-spline curves

This produces realistic UAV trajectories by avoiding sharp turns between waypoints.

---

# Flight Constraints

The planned trajectory must satisfy the following constraints.

## 1. Energy Constraint

The total energy consumption consists of

- Take-off energy
- Horizontal flight energy
- Landing energy

subject to

$E_U+E_H+E_D \le E_{max}$

---

## 2. Altitude Constraint

The UAV must remain inside the allowable flight corridor

$h_{min}<h<h_{max}$

---

## 3. Flight Angle Constraint

The heading and pitch angles are bounded by

$\alpha\le\alpha_{max}$

$\beta\le\beta_{max}$

to ensure stable flight.

---

## 4. Threat Avoidance Constraint

Threat regions are modeled as cylindrical no-fly zones.

Each trajectory segment is evaluated against every threat region.

Trajectories entering a forbidden region receive an infinite penalty.

---

# Objective Function

The overall trajectory cost is a weighted sum of five objectives.

$F=\sum_{i=1}^{5}\eta_iF_i$

subject to

$\sum_{i=1}^{5}\eta_i=1$

where

- $F_1$: Energy consumption cost
- $F_2$: Path length cost
- $F_3$: Altitude cost
- $F_4$: Threat cost
- $F_5$: Trajectory smoothness cost

---

## Energy Cost

Minimize total energy consumed during

- Take-off
- Cruise
- Landing

---

## Path Length Cost

Minimize the total travelled distance

$F_2=\sum l_i$

---

## Altitude Cost

Penalize trajectories approaching altitude limits while satisfying

$h_{min}<h<h_{max}$

---

## Threat Cost

Penalize trajectories passing close to obstacles or restricted regions.

---

## Smoothness Cost

Reduce abrupt changes in

- Yaw angle
- Pitch angle

to generate smooth UAV motion.

---

# Optimization Workflow

For each candidate trajectory

1. Decode the optimization variables.
2. Convert spherical coordinates to Cartesian coordinates.
3. Smooth the trajectory using cubic B-splines.
4. Evaluate all flight constraints.
5. Compute the five objective costs.
6. Compute the weighted total cost.
7. Update the trajectory using the optimization algorithm.

---

# Multi-UAV Extension

For multiple UAVs,

- each UAV is optimized independently,
- all UAVs share the same environmental map,
- collision avoidance between UAVs can be incorporated through an additional inter-UAV separation constraint.
