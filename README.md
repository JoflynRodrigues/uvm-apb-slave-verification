# UVM-Based APB Slave Verification

A complete SystemVerilog/UVM verification environment for an AMBA APB slave design.

## Features

- APB slave RTL design
- UVM testbench architecture
- Constrained-random stimulus generation
- Driver, monitor, sequencer, and agent
- Scoreboard-based data checking
- Functional coverage collection
- SystemVerilog Assertions (SVA)
- Wait-state (`PREADY`) handling
- Error response (`PSLVERR`) verification

---

## APB Features Verified

- Read transactions
- Write transactions
- Valid/invalid address accesses
- Wait-state insertion
- APB setup and access phase timing
- Protocol handshake behavior

---

## Verification Components

### UVM Environment
- Transaction class
- Sequence & sequencer
- Driver
- Monitor
- Agent
- Environment
- Scoreboard
- Coverage collector

### Assertions
- PENABLE/PSEL protocol checks
- Setup-to-access phase validation
- Handshake assertions
- Transfer stability checks

---

## Functional Coverage

The project uses coverage-driven verification with constrained-random testing.

Current functional coverage achieved:
- ~80% functional coverage
- 100% scoreboard pass rate

---

## Tools Used

- SystemVerilog
- UVM 1.2
- QuestaSim / EDA Playground

---

## Directory Structure

```text
rtl/
tb/
uvm/
assertions/
coverage/
sim/
```

---

## Future Improvements

- APB master agent
- Virtual sequences
- RAL model integration
- APB bridge verification
- Protocol checker VIP
- Cross coverage enhancement

---
