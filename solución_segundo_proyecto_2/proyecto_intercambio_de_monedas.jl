using  Pkg; Pkg.activate(".")
import Pkg; Pkg.add("DataFrames"); Pkg.add("Queryverse"); Pkg.add("Genie"); Pkg.add("JSONTables")
using Queryverse, DataFrames, JSONTables ##Importando librerías
using Genie, Genie.Router, Genie.Renderer, Genie.Renderer.Json, Genie.Renderer.Html, Genie.Requests

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

form1 = """
<form action="/POST/last" method="POST" enctype="multipart/form-data">
  <input type="text" name="moneda1" value="" placeholder="Ingrese Moneda base" />
  <input type="text" name="moneda2" value="" placeholder="Ingrese Moneda particular" />
  <input type="submit" value="Ingresar" />
</form>
"""

route("/form1") do
  return html(form1)
end

route("/POST/last", method = POST) do
    moneda_1=postpayload(:moneda1,"BRL")
    moneda_2=postpayload(:moneda2,"JPY")
    tasa=divisa(moneda_1,moneda_2)
    return "La tasa de intercambio actual entre $(moneda_1) y $(moneda_2) es $(tasa)"
end

form2 = """
<form action="/POST/converter" method="POST" enctype="multipart/form-data">
  <input type="text" name="moneda1" value="" placeholder="Ingrese Moneda base" />
  <input type="text" name="moneda2" value="" placeholder="Ingrese Moneda particular" />
   <input type="text" name="cantidad" value="" placeholder="Cantidad de moneda base" />
  <input type="submit" value="Ingresar" />
</form>
"""

route("/form2") do
  return html(form2)
end

route("/POST/converter", method = POST) do
    moneda_1=postpayload(:moneda1,"BRL")
    moneda_2=postpayload(:moneda2,"JPY")
    n=parse(Float64,postpayload(:cantidad,1.0))
    conversion=converter(moneda_1,moneda_2,n)
    return "La conversion es  $(conversion) $(moneda_2)"
end


form3 = """
<form action="/POST/date" method="POST" enctype="multipart/form-data">
  <input type="text" name="moneda1" value="" placeholder="Ingrese Moneda base" />
  <input type="text" name="moneda2" value="" placeholder="Ingrese Moneda particular" />
  <input type="text" name="fecha" value="" placeholder="Ingrese una fecha" />
  <input type="submit" value="Ingresar" />
</form>
"""

route("/form3") do
  return html(form3)
end

route("/POST/date", method = POST) do
    moneda_1=postpayload(:moneda1,"BRL")
    moneda_2=postpayload(:moneda2,"JPY")
    fecha=postpayload(:fecha,"1/1/2021")
    tasa=divisa(moneda_1,moneda_2,fecha)
    return arraytable(tasa)
end

up(8005)
