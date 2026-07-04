-- Schema Design
Key Format: weather:{city_name_lowercase}
Example Key: weather:london
Value: '{"temp": 22, "condition": "Clouds"}'
TTL (Expiration): 600 seconds (10 minutes)