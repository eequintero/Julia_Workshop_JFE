using Pkg; Pkg.activate("."); Pkg.instantiate() ##Activando enviroment local

import Pkg; Pkg.add("DataFrames"); Pkg.add("Queryverse"); Pkg.add("Dates")
using Queryverse, DataFrames, Dates ##Importando librerías

begin #Preparación del DataFrame
    rate= load("FRB_H10_rows.csv")
    dfrate= DataFrame(rate)[Not([:"Multiplier:", :"Descriptions:", :"Unique Identifier:", :"Series Name:"])] #Quitamos la columnas que no importan
    dfrate= dfrate[describe(dfrate).min.!="ND"] #Quitamos las columnas sin datos (No Data)

    rename!(dfrate, :"Currency:"=>"Currency")
    rename!(dfrate, :"Unit:"=>"Unit")
    names(dfrate)
end

#Función que da la tasa de cambio, más reciente, entre dos tipos de moneda
function divisa(moneda_base::String, moneda_particular::String)
    tasa_base= dfrate[dfrate.Currency.==moneda_base, end][1]
    tasa_particular=  dfrate[dfrate.Currency.==moneda_particular, end][1]

    tasa_intercambio= tasa_particular/tasa_base
    #particular = tasa_intercambio*base
end

#Función que da la tasa de cambio, desde la fecha indicada a la más reciente, entre dos tipos de moneda
function divisa(moneda_base::String, moneda_particular::String, fecha::String)
    df_fechas= dfrate[3:end] #DataFrame solo con las tasas en cada fecha (Sin el nombre de la moneda)
    tasas_base= df_fechas[dfrate.Currency.==moneda_base, names(df_fechas).>=fecha]
    tasas_particular=  df_fechas[dfrate.Currency.==moneda_particular, names(df_fechas).>=fecha]

    tasas_intercambio= copy(tasas_base)

    for i ∈ 1:size(tasas_base,2)
        tasas_intercambio[1,i]=tasas_particular[1,i]/tasas_base[1,i]
    end

    tasas_intercambio
    #particular = tasa_intercambio*base
end

function converter(moneda_base::String, moneda_particular::String, cantidad::Float64)
    tasa_intercambio= divisa(moneda_base, moneda_particular)
    return(cantidad*tasa_intercambio)
end

converter("BRL", "JPY", 15.0) #funciona bien
divisa("BRL", "JPY") #nice
divisa("BRL", "JPY", "1/15/2021") #quedó genial
