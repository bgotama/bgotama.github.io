---
title: "Methods & capabilities"
weight: 40
summary: "The process systems engineering toolchain behind every research direction: modelling, simulation, synthesis and design, optimization, assessment, and control."
showDate: false
showAuthor: false
showTableOfContents: true
---

This page describes **how** we work. What we apply it to is on the
[Research](/research/) page — each direction there links back here rather than
repeating any of this.

The PSE workflow below runs in roughly this order, though in practice it loops:
an optimization result sends you back to the model, and a controllability
problem sends you back to the design.

## 1. Modelling

Formulating the mass, energy, and momentum balances and the constitutive
relations that describe a unit or a plant.

- Thermodynamic property method selection and validation — the step that
  quietly determines whether everything downstream is meaningful
- Reaction kinetics from literature and patents; lumped and molecular-based
  reactor models
- Biokinetic models for biological treatment processes (ADM1 and simplified
  variants)
- Data-driven and hybrid physics-informed models where mechanism is incomplete
- Parameter estimation and inverse modelling against plant or laboratory data

## 2. Simulation

Solving those models at scale and making the results reproducible.

- **Aspen Plus** — primary simulator for steady-state and dynamic flowsheets
- **Aspen HYSYS**, **DWSIM** — DWSIM is our preference for work that must stay
  license-free, including student projects and collaborations without a budget
- **Python** and **MATLAB** for automation: driving the simulator through its
  interface so that hundreds of design cases run without a single manual click
- Convergence strategy, initialization sequences, and diagnostics — in
  practice, where most of the time on a real flowsheet goes

## 3. Process synthesis and design

Generating candidate configurations rather than evaluating one inherited
design.

- Flowsheet alternatives generation and screening
- **Process intensification** — reactive distillation, dividing-wall columns,
  side-reactor and side-stream configurations, non-adiabatic reactor designs,
  heat-integrated arrangements
- Heat integration and utility system design
- Equipment sizing and costing to a stated basis

## 4. Optimization

Finding the configuration and operating point that is actually best, and being
explicit about "best at what".

- **Multi-objective optimization** — particle swarm (MOPSO) and related
  population-based methods, producing Pareto fronts rather than a single answer
- Single-objective and mixed-integer formulations where the problem allows
- Surrogate-assisted optimization when each simulation evaluation is expensive
- Decision support on the Pareto front (multi-criteria decision making tools): how to choose one point and defend it

## 5. Assessment

Turning a design into numbers a decision-maker can use.

- **Techno-economic analysis** — capital and operating cost estimation,
  discounted cash flow, sensitivity and uncertainty analysis
- **Carbon intensity and life-cycle assessment** of the designed process
- Feedstock and market sensitivity for Indonesian conditions specifically

## 6. Dynamics and control

Confirming the design can be operated.

- Dynamic simulation of the designed flowsheet
- Control structure selection and tuning
- Disturbance rejection and operability assessment — checked as part of the
  design, not after it

---

## Software and tools

| Purpose | Tools |
|---|---|
| Process simulation | Aspen Plus, Aspen HYSYS, DWSIM |
| Automation and optimization | Python, MATLAB |
| Machine learning | Python |
| Documentation and reproducibility | Git, Markdown |

Tutorials on several of these are on
[Course Materials](/tutorials/).

## Collaboration

We are open to collaboration where a process model would settle a question that
is currently being argued from opinion — in low-carbon fuels, wastewater
treatment, or commodity downstream processing. Industry partners with
operational data and academic groups with experimental capability are both
welcome; see [Join us](/join/).
