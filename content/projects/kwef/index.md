---
title: "Hybrid modelling and machine learning for POME treatment"
weight: 10
summary: "KWEF Overseas Research Grant 2026 — building a predictive framework that estimates palm oil mill effluent treatment performance in real time, from the cheap measurements mills already have."
showDate: false
showAuthor: false
showTableOfContents: true
---

| | |
|---|---|
| **Funder** | Kurita Water and Environment Foundation (KWEF) — Overseas Research Grant 2026 |
| **Grant** | 26Pid194 |
| **Term** | October 2026 – September 2027 |
| **Host** | Institut Teknologi Kalimantan |
| **Role** | Sole principal investigator |
| **Status** | Starting October 2026 |

**Full title:** Hybrid Process Modeling and Machine Learning Framework for Adaptive Treatment of Palm Oil Mill Effluent in the Indonesian Palm Oil Industry.

## The problem
Indonesia is the world's largest palm oil producer, and every mill generates palm oil mill effluent (POME) at extreme organic loading — COD up to 100,000 mg/L, BOD up to 50,000 mg/L, TSS up to 40,000 mg/L. Those figures are not steady: they swing with feedstock quality, milling practice, and season.

Conventional Indonesian treatment relies on ponding systems — anaerobic, facultative, aerobic, and polishing stages in series. Under stable feed these ponds meet discharge limits. Under variable feed their performance becomes unpredictable, and here the operational problem bites: **a COD or BOD analysis takes two to five days.** By the time the number arrives, the disturbance it describes has already passed through the ponds, and a discharge violation is discovered after it happened rather than before.

Mills are therefore steering a slow biological process on information that is always stale. The gap this project closes is the absence of a reliable predictive tool that anticipates effluent quality from measurements a mill can afford to take continuously.

## Approach
An integrated predictive framework in two interconnected layers.

### Layer 1 — mechanistic process model
A model of the full POME treatment train built in **DWSIM**, an open-source, CAPE-OPEN compliant process simulator:
- Oil trap and cooling stage
- Anaerobic digestion modelled with the **Anaerobic Digestion Model No. 1   (ADM1)** framework
- Aerobic and polishing stages modelled with simplified biokinetic   formulations

ADM1 parameters will be **calibrated specifically for Indonesian POME**  inverse modelling against field data from several mills across Kalimantan and Sumatera. This addresses a real gap: published ADM1 parameter sets are predominantly derived from temperate municipal wastewater, and applying them unchanged to tropical, lipid-rich POME is an assumption nobody has validated.

### Layer 2 — machine learning
Models developed in **Python**, serving two complementary functions:

1. **Estimating what is expensive to measure.** Predicting raw POME quality parameters — COD, BOD, lipid fraction — from inexpensive real-time measurements such as pH, temperature, and flow rate.
2. **Hybrid effluent-quality prediction.** Using both the real-time measurements and the *intermediate outputs of the DWSIM model* as features.

Random Forest, Gradient Boosting, and neural networks will be benchmarked against each other. The working hypothesis is that hybrid physics-informed approaches outperform purely data-driven ones **specifically at novel operating conditions** — the case that matters, since a purely statistical model is only trustworthy inside the range it was trained on, and POME variability routinely leaves that range.

## Field campaign
The work is grounded in field data from **three palm oil mills in East Kalimantan and Sumatera**, chosen to capture geographic and operational variability in POME characteristics. Sampling campaigns collect POME at multiple stages of the treatment train, paired with mill operational data, so that calibration and cross-mill validation are both possible. Sample analyses are outsourced to certified laboratories.

## Expected outputs
1. A **multi-mill POME characterization database** for East Kalimantan and Sumatera, capturing spatial variability relevant to treatment design and operation.
2. An **ADM1 parameter set calibrated and validated for Indonesian POME**, enabling other researchers and practitioners across the ASEAN region to model tropical anaerobic digestion rigorously.
3. An **open-source Python framework** integrating DWSIM process simulation with machine learning models, released freely for adoption by Indonesian mills and academic institutions.
4. **Operational insights** into how raw POME variability propagates into treatment performance — practical guidance for mill operators.

Findings will be disseminated through international journal publications and conference presentations.

## Why open-source tools
DWSIM and Python were chosen deliberately over commercial alternatives. A framework that requires a commercial simulator licence is a framework most Indonesian mills cannot run, however good it is. Building on open tools is what makes adoption possible outside the university.

Beyond the grant period, this project establishes the computational and analytical foundation for the **Process Systems Engineering laboratory at ITK** — supporting long-term capacity building in computational approaches to industrial wastewater management in Indonesia.

## Get involved
**Palm oil mills** — we are looking for additional partner mills willing to allow sampling and share operational records. In return you get a calibrated model of your own treatment train and the effluent-quality predictions that come with it. Enquiries via [Contact](/contact/).

**Students** — this project needs work on ADM1 calibration, on the machine learning layer, and on the data reconciliation that precedes both. Be aware that most of the effort goes into making messy plant records usable before any model is fitted. See [Join us](/join/).
