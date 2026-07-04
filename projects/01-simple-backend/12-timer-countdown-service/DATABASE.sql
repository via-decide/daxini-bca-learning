-- Schema Design
Table: Timers
- id: VARCHAR (Primary Key)
- name: VARCHAR
- target_time: TIMESTAMP (UTC strictly)
- is_active: BOOLEAN