# Caregiver & Performance Monitoring

## Overview

The **Caregiver module** provides a monitoring interface for caregivers to track the cognitive-game performance and progress of a patient.

It collects structured performance data from completed cognitive games and presents it through a caregiver-friendly dashboard.

The module is responsible for:

* Patient performance monitoring
* Game-session tracking
* Performance summaries
* Progress visualization
* Session history
* Basic monitoring alerts
* Integration with the shared performance model

The module does not make medical diagnoses or replace clinical assessment.

---

## Purpose

The caregiver should be able to quickly understand:

* How often the patient is playing cognitive games
* How the patient is performing
* Accuracy and score trends
* Performance across different cognitive games
* Recent changes that may require attention

The dashboard converts raw game-performance data into simple visual information that can be understood without technical knowledge.

---

## Caregiver Flow

```text
Patient Plays Game
        ↓
Game Result Generated
        ↓
Game Result Adapter
        ↓
Generic GamePerformance
        ↓
CaregiverService
        ↓
Local Performance Storage
        ↓
Caregiver Dashboard
        ↓
Performance Summary
        ↓
Progress / Alerts