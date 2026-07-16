#!/bin/bash

## Andres
curl -X POST https://api.maidkissa.moe/recorridos \
  -H "Content-Type: application/json" \
  -d '{
  "nombre": "Paparuta",
  "hora": "2026-07-23T10:00:00", 
  "cupos": 40,
  "precio": 3990,
  "image": "https://hito1-leo-emi-datos-10.s3.us-east-1.amazonaws.com/andresfeliz.png",
  "chofer": "Andres",
  "from": "Pto. Montt", 
  "to": "Pto. Varas"
}'
sleep 2
## Crischofer
curl -X POST https://api.maidkissa.moe/recorridos \
  -H "Content-Type: application/json" \
  -d '{
  "nombre": "La ruta del Dragon",
  "hora": "2026-07-20T14:00:00", 
  "cupos": 30,
  "precio": 12990,
  "image": "https://hito1-leo-emi-datos-10.s3.us-east-1.amazonaws.com/rutadeldragon.jpeg",
  "chofer": "Crischofer",
  "from": "Pto. Montt", 
  "to": "Castro"
}'
sleep 2
## Pibe
curl -X POST https://api.maidkissa.moe/recorridos \
  -H "Content-Type: application/json" \
  -d '{
  "nombre": "Ruta Boliviana",
  "hora": "2027-02-24T11:00:00", 
  "cupos": 5,
  "precio": 9990,
  "image": "https://hito1-leo-emi-datos-10.s3.us-east-1.amazonaws.com/rutacangri.jpeg",
  "chofer": "Pibe",
  "from": "Pto. Montt", 
  "to": "Osorno"
}'
sleep 2
## Benja
curl -X POST https://api.maidkissa.moe/recorridos \
  -H "Content-Type: application/json" \
  -d '{
  "nombre": "Ruta del Salmon",
  "hora": "2027-01-11T7:30:00"", 
  "cupos": 40,
  "precio": 2490,
  "image": "https://hito1-leo-emi-datos-10.s3.us-east-1.amazonaws.com/rutasalmonera.jpeg",
  "chofer": "Pencamin",
  "from": "Pto. Montt", 
  "to": "Isla Tenglo"
}'
