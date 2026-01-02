
### **Why Power Matters**

In modern VLSI (especially mobile, IoT, and data centers), **power consumption** directly impacts:
- Battery life  
- Thermal management  
- Reliability and performance (thermal throttling)  
- Operating cost  

CMOS technology was adopted largely because of its **low static power**, but as transistors shrink, **leakage (static) power** becomes significant—sometimes rivaling dynamic power.

---

### **Total Power Dissipation in CMOS**

\[
P_{\text{total}} = P_{\text{dynamic}} + P_{\text{static}} + P_{\text{short-circuit}}
\]

We’ll focus on **dynamic** and **static** components; short-circuit is typically <10% and often lumped into dynamic.

---

### **Dynamic Power (Switching Power)**

**Cause**: Charging and discharging of load capacitances during logic transitions.

#### **Derivation**

- Each switching event (0→1 or 1→0) moves charge:  
  \[
  Q = C_L \cdot V_{DD}
  \]
- Energy per transition:  
  \[
  E = Q \cdot V_{DD} = C_L V_{DD}^2
  \]
- If a node switches **α** times per clock cycle at frequency **f**, average power is:
  \[
  P_{\text{dynamic}} = \alpha \cdot C_L \cdot V_{DD}^2 \cdot f
  \]

Where:
- **α** = switching activity factor (0 ≤ α ≤ 1)  
- **C<sub>L</sub>** = total load capacitance (gate + wire + diffusion)  
- **V<sub>DD</sub>** = supply voltage  
- **f** = clock frequency  

> ✅ **Key Insight**: Power scales **quadratically with V<sub>DD</sub>** → voltage scaling is most effective.

---

### **Static Power (Leakage Power)**

**Cause**: Current that flows **even when the circuit is idle** (no switching), due to non-ideal transistor behavior.

#### **Major Leakage Components**:

| Type | Physical Mechanism |
|------|--------------------|
| **Subthreshold leakage** | Diffusion current when V<sub>GS</sub> < V<sub>th</sub> |
| **Gate leakage** | Quantum tunneling through thin gate oxide (significant in <45nm) |
| **Reverse-biased junction leakage** | Minority carrier drift in source/drain diodes |
| **GIDL** (Gate-Induced Drain Leakage) | Band-to-band tunneling near drain |

#### **Simplified Static Power Model**

For a single transistor in off-state:
\[
I_{\text{leak}} \approx I_0 \cdot e^{\left( \frac{V_{GS} - V_{th}}{n V_T} \right)} \quad \text{(subthreshold)}
\]
\[
P_{\text{static}} = V_{DD} \cdot I_{\text{total,leak}}
\]
where \( I_{\text{total,leak}} \) = sum of leakage from all transistors (scales with **number of transistors**, **temperature**, and **process variation**).

> 🔥 **Critical trend**: As **V<sub>th</sub>** is lowered for performance, subthreshold leakage **increases exponentially**.

---

### **Comparison: Static vs Dynamic Power**

| Feature | **Dynamic Power** | **Static Power** |
|--------|-------------------|------------------|
| **When it occurs** | During switching | Always (even at idle) |
| **Depends on** | f, V<sub>DD</sub>², C<sub>L</sub>, α | V<sub>DD</sub>, T, V<sub>th</sub>, N (transistor count) |
| **Scaling with tech node** | ↓ (smaller C<sub>L</sub>) | ↑↑ (exponential leakage growth) |
| **Dominant in** | High-performance, active circuits | Sleep mode, large SoCs (e.g., smartphone AP) |
| **Control knobs** | Clock gating, voltage scaling | Power gating, high-V<sub>th</sub> cells |

> 📈 In **28nm and below**, static power can exceed dynamic power in always-on domains.

---

### **Power Reduction Techniques**

#### **A. Dynamic Power Reduction**

1. **Voltage Scaling (DVFS)**  
   - Reduce V<sub>DD</sub> → power ↓ quadratically  
   - Trade-off: delay ↑ (∝ 1/V<sub>DD</sub>) → use only when performance allows

2. **Clock Gating**  
   - Disable clock to idle modules → α → 0  
   - Implemented via **integrated clock gates (ICG)**

3. **Logic/Architectural Optimization**  
   - Reduce switching activity (e.g., bus encoding, Gray coding)  
   - Minimize capacitance (buffer insertion, wire sizing)

4. **Operand Isolation**  
   - Prevent unnecessary toggling in datapaths

#### **B. Static Power Reduction**

1. **Power Gating (MTCMOS)**  
   - Use **sleep transistors** (header/footer) to disconnect blocks from V<sub>DD</sub>/GND  
   - Requires state retention (e.g., retention flops)

2. **Multi-Threshold CMOS (MTCMOS)**  
   - Use **high-V<sub>th</sub>** transistors for non-critical paths → ↓ leakage  
   - Use **low-V<sub>th</sub>** for performance-critical paths

3. **Variable V<sub>th</sub> via Body Biasing**  
   - **Reverse Body Bias (RBB)**: ↑ V<sub>th</sub> → ↓ leakage (sleep mode)  
   - **Forward Body Bias (FBB)**: ↓ V<sub>th</sub> → ↑ speed (active mode)  
   - Requires separate well ties → area overhead

4. **Advanced Processes**  
   - **FinFETs** (from 22nm): better gate control → ↓ subthreshold leakage  
   - **FD-SOI**: ultra-thin body → excellent leakage control

---

### **Unified Power Equation (for estimation)**

\[
\boxed{
P_{\text{total}} = \underbrace{\alpha C_L V_{DD}^2 f}_{\text{Dynamic}} + \underbrace{V_{DD} \cdot N \cdot I_{\text{leak, per transistor}}}_{\text{Static}}
}
\]

Where **N** = number of transistors (or active transistors in block).

---

### **Practical Example**

Consider a 1 billion transistor SoC in 16nm:
- **Active mode**:  
  - Dynamic dominates → optimize V<sub>DD</sub>, f, α  
- **Sleep mode**:  
  - All clocks off → α ≈ 0  
  - But 1e9 transistors × 100 pA leakage = 100 mA → **P<sub>static</sub> = 3.3V × 0.1A = 330 mW**!  
  → **Power gating essential**

---

### **Summary**

| Aspect | Key Takeaway |
|-------|--------------|
| **Dynamic Power** | Proportional to **f·V²**; reduced by activity control & voltage scaling |
| **Static Power** | Always present; grows exponentially with scaling; reduced by **power gating** and **V<sub>th</sub> management** |
| **Modern Design** | Hybrid strategies: **DVFS + clock gating + power domains + MTCMOS** |

---