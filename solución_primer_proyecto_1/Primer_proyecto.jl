### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 98c65340-5859-11eb-03be-699fb34b8d36
md"# Solución Primer Proyecto"

# ╔═╡ 7fc09d90-585b-11eb-1f99-eb47f32584c9
md"## Definición de objetos y funciones

* A continuación construya un struct Grid (Grilla), donde se defina la región del plano complejo que debe ser analizado (límites en las abcisas y ordenadas) y el espacio entre cada punto de la grilla."

# ╔═╡ ab77fb00-585a-11eb-0f49-7bf677a9f82c
"""*
 Representa un objeto grilla 
"""
struct Grid{T<:Real}
	
end

# ╔═╡ 75f1ef30-585b-11eb-04f9-5baa98c295d7
md"* Defina una función que cree una matriz de rangos para los ejes de las abcisas y ordenas."

# ╔═╡ d291f0a0-585b-11eb-2760-79433733f2bd
"""
	makeGrid(g::Grid)
Crear una matriz de rangos [rango_abcisas,rango_ordenadas]
"""
function makeGrid(g::Grid)
	
end

# ╔═╡ 81c7c2c0-585c-11eb-27f7-9d6500737259
md"* Defina funciones de una línea para las formas biológicas y la familia de polinomios cuadráticos complejos"

# ╔═╡ 9e38a500-585c-11eb-03f9-5be3e141d5f6
begin ##*
	
end

# ╔═╡ a71cf360-585c-11eb-2503-09522c1a63b7
md"* Defina una función que retorne `true` si el criterio de convergencia para los conjuntos $J_c$ y $M_fc$ se cumple, `false` en caso contrario."

# ╔═╡ cf71cf72-585c-11eb-1fb9-0913a195ddd4
""" *
	testJM(z::Complex)
Comprobar el criterio de convergencia para los conjuntos de Julia y Mandelbrot
"""
function testJM(z::Complex)
	
end

# ╔═╡ 6a574880-585d-11eb-1aac-e1d61b5fc7e6
md"* Defina una función que `true` si el criterio de convergencia para las formas biológicas se cumple, `false` en caso contrario."

# ╔═╡ 8818edae-585d-11eb-14eb-e5aba19f63cd
"""
	testbiomorph(z::Complex,τ::Real)
Comprobar el criterio de convergencia para los conjuntos de Julia y Mandelbrot
"""
function testbiomorph(z::Complex,τ::Real)
	
end

# ╔═╡ b27e8150-585d-11eb-0b8c-c527502a4df6
md"* Defina una función que itere un número sobre una función $f_c$ y devuelva `true` si se cumple el criterio de divergencia para $J_{fc}$, $M_{fc}$ y formas biológicas"

# ╔═╡ ece38a70-585d-11eb-1ba9-6bf688115b8a
"""
	iterate(test::Function,f::Function,z::Complex,iter::Integer)
Interar z sobre una funcion f
"""
function iterate(test::Function,f::Function,z::Complex,iter::Integer)
	
end

# ╔═╡ fa942df0-585d-11eb-17d8-f5779262c3eb
md"* Defina un función que devuelva el número de iteraciones realizadas para un dado z (número complejo), hasta que se no se cumple el criterio de divergencia."

# ╔═╡ 06d255b0-585e-11eb-1728-097f2e554508
"""*
	colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
Retornar el número de iteraciones para un valor dado de z minetras un criterio de convergencia sea válido
"""
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
	
end

# ╔═╡ 0a25ed80-585e-11eb-11a2-dda4146ebd87
md"* Usando multiple dispatch, defina nuevamente la función colormap agregando un nuevo parámetro de entrada $\tau$, de modo que se pueda usar el test de convergencia para la forma biológica"

# ╔═╡ 15551640-585e-11eb-3e01-7b46b0cfc511
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer,τ::Integer)
	
end

# ╔═╡ Cell order:
# ╟─98c65340-5859-11eb-03be-699fb34b8d36
# ╟─7fc09d90-585b-11eb-1f99-eb47f32584c9
# ╠═ab77fb00-585a-11eb-0f49-7bf677a9f82c
# ╟─75f1ef30-585b-11eb-04f9-5baa98c295d7
# ╠═d291f0a0-585b-11eb-2760-79433733f2bd
# ╟─81c7c2c0-585c-11eb-27f7-9d6500737259
# ╠═9e38a500-585c-11eb-03f9-5be3e141d5f6
# ╟─a71cf360-585c-11eb-2503-09522c1a63b7
# ╠═cf71cf72-585c-11eb-1fb9-0913a195ddd4
# ╟─6a574880-585d-11eb-1aac-e1d61b5fc7e6
# ╠═8818edae-585d-11eb-14eb-e5aba19f63cd
# ╟─b27e8150-585d-11eb-0b8c-c527502a4df6
# ╠═ece38a70-585d-11eb-1ba9-6bf688115b8a
# ╟─fa942df0-585d-11eb-17d8-f5779262c3eb
# ╠═06d255b0-585e-11eb-1728-097f2e554508
# ╟─0a25ed80-585e-11eb-11a2-dda4146ebd87
# ╠═15551640-585e-11eb-3e01-7b46b0cfc511
