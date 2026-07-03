# Soil Chemistry and Water Level Monitoring Engines


Soil Chemistry and Water Level Monitoring

Engines

Sustainable farming in Kutch requires precise management of soil chemistry and water resources. We built a localized monitoring engine that runs on our edg...

◆

Engineering

◆

Systems

By

Dharam Daxini

· July 3, 2026

Read more at →

◆ daxini.xyz

Sustainable farming in Kutch requires precise management of soil chemistry and water resources. We built a localized monitoring engine that runs on our edge gateway to track these key metrics in real-time.

Telemetry from pH probes and water level sensors is collected via Modbus. Zayvora's symbolic engine analyzes these inputs, calculating evaporation rates and determining if soil salinity is approaching critical thresholds.

If any metric goes out of bounds, the gateway triggers local automated valves to flush the soil or refill the reservoir. This closed-loop automation setup operates on-premise, ensuring reliable irrigation management.

Built using: LogicHub · Aporaksha · Daxini · Zayvora