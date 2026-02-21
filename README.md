# Amba-APB
Designed and implemented the AMBA Advanced Peripheral Bus (APB) protocol from scratch using Verilog for low-power peripheral communication.
1)Implemented APB Master and APB Slave modules following APB3/APB4 protocol specifications.
2)Designed FSM-based control logic supporting IDLE, SETUP, and ACCESS phases.
    Implemented key APB signals:
    PADDR, PWRITE, PWDATA, PRDATA, PENABLE, PSEL, PREADY, PSLVERR.
3)Ensured proper two-cycle transfer operation (SETUP + ACCESS phase).
