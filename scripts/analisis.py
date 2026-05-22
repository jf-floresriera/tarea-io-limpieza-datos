#!/usr/bin/env python3
"""
Tarea 0.11 - Lectura Robusta de Archivos y Limpieza de Datos
Script: analisis.py
Ejercicio 1: Limpiando un inventario forestal (I/O y Excepciones)
Ejercicio 2: Analizando datos estructurados (Diccionarios y Listas)
"""

import csv

print("=" * 60)
print("  EJERCICIO 1 - Limpiando un inventario forestal")
print("=" * 60)

# Paso 1: Crear archivo crudo con errores intencionales
lineas_crudas = [
    "Especie,Latitud,Longitud",
    "Roble,4.6097,-74.0817",
    "Pino,4.6XYZ,-74.0900",
    "Cedro,4.6150,-74.0850",
    "Eucalipto,NULA,-74.0700",
    "Nogal,4.6200,-74.0650",
]
with open("arboles_crudos.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(lineas_crudas) + "\n")
print("  Archivo arboles_crudos.txt creado.")


def limpiar_inventario(archivo_entrada: str, archivo_salida: str) -> None:
    """
    Lee el inventario linea a linea con try-except.
    float() lanza ValueError si el texto no es numerico.
    Sin try-except ese error detendria TODO el programa.
    El bloque 'with' garantiza el cierre del archivo siempre.
    """
    validos = invalidos = 0
    with open(archivo_entrada, "r", encoding="utf-8") as entrada, \
         open(archivo_salida, "w", encoding="utf-8", newline="") as salida:
        writer = csv.writer(salida)
        writer.writerow(["especie", "latitud", "longitud"])
        for linea in entrada.readlines()[1:]:
            partes = linea.strip().split(",")
            if len(partes) != 3:
                continue
            especie, lat_str, lon_str = partes
            try:
                lat = float(lat_str.strip())
                lon = float(lon_str.strip())
                writer.writerow([especie.strip(), lat, lon])
                validos += 1
            except ValueError:
                invalidos += 1
                print(f"  ADVERTENCIA: {especie!r} lat={lat_str!r} invalida. Omitido.")
    print(f"\n  Registros validos  : {validos}")
    print(f"  Registros omitidos : {invalidos}")
    print(f"  Archivo limpio     : {archivo_salida}")


limpiar_inventario("arboles_crudos.txt", "arboles_limpios.csv")

print("\nContenido de arboles_limpios.csv:")
with open("arboles_limpios.csv", encoding="utf-8") as f:
    print(f.read())

print("=" * 60)
print("  EJERCICIO 2 - Analizando datos estructurados")
print("=" * 60)


def cargar_datos_espaciales(archivo_csv: str) -> list:
    """
    Lee el CSV limpio y retorna lista de diccionarios.
    Llaves: especie, latitud, longitud.
    Diccionarios son mas legibles que listas posicionales.
    """
    registros = []
    with open(archivo_csv, "r", encoding="utf-8") as f:
        for fila in csv.DictReader(f):
            registros.append({
                "especie"  : fila["especie"].strip(),
                "latitud"  : float(fila["latitud"]),
                "longitud" : float(fila["longitud"])
            })
    return registros


arboles = cargar_datos_espaciales("arboles_limpios.csv")

print("\nRegistros cargados en memoria:")
for a in arboles:
    print(f"  {a}")

lat_promedio = sum(a["latitud"] for a in arboles) / len(arboles)
mas_norte    = max(arboles, key=lambda a: a["latitud"])

print(f"\n  Latitud promedio : {lat_promedio:.4f} grados")
print(f"  Arbol mas norte  : {mas_norte['especie']} (lat={mas_norte['latitud']})")
print("\n  Script Python completado exitosamente.")
