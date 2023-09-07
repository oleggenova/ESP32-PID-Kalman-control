# ESP32-PID-Kalman-control
An ESP32 driven inverse pendulum PID controller is designed and implemented in MATLAB, with the synthesis of a Kalman Filter to increase the performance of control.

## Workflow


1. **MODEL** - In order to use the Kalman Filter, State-Space model is determined for the pendulum, with the angle of oscillation linearly approximated around a steady vertical position. For the model, a PID controller is synthetized by the use of ``PID Tuner - Control System Toolbox`` and them experimentally adjusted.
2. **KALMAN FILTER** - Using preimplemented Matlab functions, Kalman Filter is designed given the linear model.
3. **RESULTS** -- Follows the comparation of control performance between the behavior of system with and without Kalman Filter; in addition the difference of control results was assessed for Kalman Filter control and **Pole Placement and Deterministic Observer** technique.

