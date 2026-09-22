---
title: "Water and effluent treatment"
weight: 20
summary: "Modelling palm oil mill effluent and industrial wastewater treatment so that operators can predict effluent quality from measurements they can actually afford."
showDate: false
showAuthor: false
---

Palm oil mills in Kalimantan and Sumatera run effluent ponds whose performance
is judged by parameters that are slow and expensive to measure. By the time a
laboratory result comes back, the condition it described has passed. Operators
are therefore steering a biological process on stale information.

This direction builds models that close that gap.

### What we work on

- **Mechanistic modelling of anaerobic digestion** of palm oil mill effluent
  (POME), with ADM1 as the core and simplified biokinetics for the aerobic and
  polishing stages.
- **Hybrid physics-informed machine learning** — an inner model that estimates
  hard-to-measure influent characteristics from low-cost sensors, and an outer
  model that uses mechanistic model outputs as features to predict effluent
  quality.
- **Model calibration under sparse data** — inverse modelling with genetic
  algorithms and particle swarm optimization against the limited historical
  records mills actually keep.
- **Biogas recovery** as a co-product rather than an afterthought.

This is a predictive framework, deliberately not a full digital twin. The
distinction matters: we are after decisions an operator can act on this shift,
not a complete virtual replica of the plant.

### Where it stands

Funded by the **Kurita Water and Environment Foundation (KWEF) Overseas
Research Grant 2026** (grant 26Pid194), running October 2026 – September 2027
at ITK. Details are on the [Projects](/projects/) page. Mill partnerships for
field sampling are being arranged in Kalimantan Timur.

### What a student would do here

Work with real plant data, which means most of your effort goes into
reconciling records that disagree with each other before any model is fitted.
If you want a clean dataset, this is not the direction for you.

Methods used in this direction are described on
[Methods & capabilities](/research/methods/).
