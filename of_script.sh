#!/usr/bin/env bash

echo "Este script sirve para realizar múltiples solicitudes a los puertos 80, 443 y 22 del servidor \"víctima\""

for i in {1..500}; do
    curl -s -o /dev/null http://192.168.122.29/
done
