# Adaptive Hardware Telemetry & Backpressure Engine (AHTBE)
**Status:** v1.0 (Stable, simulation-verified)
AHTBE is a **simulation-only, pre-silicon hardware module** written in Verilog that monitors queue occupancy, detects sustained congestion using adaptive telemetry, and applies feedback-based backpressure to regulate data flow.

The project follows **industry-style RTL and verification methodology**, including clean separation of design and testbench, self-driven simulation, assertions, and waveform-based analysis.

---

## 📌 Motivation

High-throughput hardware systems (SoC interconnects, DMA engines, NoCs, accelerators) require **flow control** to prevent buffer overflow, congestion collapse, and performance instability.

AHTBE models how real hardware:
- observes internal pressure (telemetry),
- detects **sustained** congestion (not transient spikes),
- and applies **controlled backpressure** to stabilize the system.

This project focuses on **architecture and control behavior**, not FPGA or board-specific implementation.

---

## 🧠 Core Concepts Implemented

### 1. Queue Telemetry
- Tracks queue occupancy using `queue_level`
- Models backlog formation when producer is faster than consumer
- Serves as the primary congestion signal

### 2. Adaptive Telemetry (Moving Average)
- Computes a moving average (`queue_avg`) of queue occupancy
- Filters short-lived spikes
- Responds only to **sustained load trends**

### 3. Hysteresis-Based Congestion Detection
- Separate thresholds for asserting and deasserting congestion
- Prevents control flapping
- Commonly used in real hardware control loops

### 4. Backpressure Feedback
- Generates `backpressure` when congestion persists
- Demonstrates closed-loop hardware flow control
- Stabilizes producer-consumer behavior

---

## 🏗 Architecture Overview

<img width="485" height="600" alt="image" src="https://github.com/user-attachments/assets/321ab967-6e79-497a-a25a-938b8965c350" />

+---------------------------------------------+

---

## 🧪 Verification Methodology
- Self-driven testbench generates:
  - Producer traffic (`valid`)
  - Consumer behavior (`ready`)
- Stress scenarios intentionally create sustained congestion
- Assertion checks:
  - Backpressure must follow congestion
- Waveform inspection using GTKWave

This mirrors **pre-silicon verification workflows** used in industry.

---


## ▶️ How to Run the Simulation

### Prerequisites
- Icarus Verilog
- GTKWave

### Commands
```bash
cd tb
iverilog ../rtl/ahtbe_core.v tb_top.sv
vvp a.out
gtkwave waves.vcd
