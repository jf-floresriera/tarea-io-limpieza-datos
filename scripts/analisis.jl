# =============================================================
# Tarea 0.11 - Lectura Robusta de Archivos y Limpieza de Datos
# Script: analisis.jl
# =============================================================

using Printf

println(repeat("=", 60))
println("  EJERCICIO 1 - Limpiando un inventario forestal")
println(repeat("=", 60))

lineas_crudas = [
    "Especie,Latitud,Longitud",
    "Roble,4.6097,-74.0817",
    "Pino,4.6XYZ,-74.0900",
    "Cedro,4.6150,-74.0850",
    "Eucalipto,NULA,-74.0700",
    "Nogal,4.6200,-74.0650",
]
open("arboles_crudos.txt", "w") do f
    write(f, join(lineas_crudas, "\n") * "\n")
end
println("  Archivo arboles_crudos.txt creado.")

function limpiar_inventario(entrada::String, salida::String)
    validos = invalidos = 0
    open(salida, "w") do fout
        write(fout, "especie,latitud,longitud\n")
        open(entrada, "r") do fin
            for linea in readlines(fin)[2:end]
                partes = strip.(split(strip(linea), ","))
                length(partes) != 3 && continue
                especie = partes[1]
                lat_str = partes[2]
                lon_str = partes[3]
                try
                    lat = parse(Float64, lat_str)
                    lon = parse(Float64, lon_str)
                    write(fout, "$(especie),$(lat),$(lon)\n")
                    validos += 1
                catch
                    invalidos += 1
                    println("  ADVERTENCIA: $(especie) lat=$(lat_str) invalida. Omitido.")
                end
            end
        end
    end
    @printf("\n  Registros validos  : %d\n", validos)
    @printf("  Registros omitidos : %d\n", invalidos)
end

limpiar_inventario("arboles_crudos.txt", "arboles_limpios.csv")
println("\nContenido de arboles_limpios.csv:")
println(read("arboles_limpios.csv", String))

println(repeat("=", 60))
println("  EJERCICIO 2 - Analizando datos estructurados")
println(repeat("=", 60))

function cargar_datos_espaciales(archivo::String)
    registros = Vector{Dict{Symbol, Any}}()
    open(archivo, "r") do f
        for linea in readlines(f)[2:end]
            partes = strip.(split(strip(linea), ","))
            length(partes) != 3 && continue
            push!(registros, Dict(
                :especie  => String(partes[1]),
                :latitud  => parse(Float64, partes[2]),
                :longitud => parse(Float64, partes[3])
            ))
        end
    end
    return registros
end

arboles_jl  = cargar_datos_espaciales("arboles_limpios.csv")

println("\nRegistros cargados en memoria:")
for a in arboles_jl
    @printf("  %-12s lat=%.4f  lon=%.4f\n", a[:especie], a[:latitud], a[:longitud])
end

latitudes_jl = [a[:latitud] for a in arboles_jl]
norte_jl     = arboles_jl[argmax(latitudes_jl)]

@printf("\n  Latitud promedio : %.4f grados\n", sum(latitudes_jl)/length(latitudes_jl))
@printf("  Arbol mas norte  : %s (lat=%.4f)\n", norte_jl[:especie], norte_jl[:latitud])
println("\n  Script Julia completado exitosamente.")
