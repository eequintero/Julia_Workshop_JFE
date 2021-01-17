### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 98c65340-5859-11eb-03be-699fb34b8d36
md"# Solución Primer Proyecto"

# ╔═╡ 7fc09d90-585b-11eb-1f99-eb47f32584c9
md"## Definición de objetos y funciones

* Un struct Grid (Grilla) donde se define la región del plano complejo que debe ser analizado (límites en las abcisas y ordenadas) y el espacio entre cada punto de la grilla."

# ╔═╡ ab77fb00-585a-11eb-0f49-7bf677a9f82c
"""*
 Representa un objeto grilla 
"""
struct Grid{T<:Real}
	limite_abcisas::T
	limite_ordenadas::T
	paso::T
end

# ╔═╡ 75f1ef30-585b-11eb-04f9-5baa98c295d7
md"* Función que crea una matriz de rangos para los ejes de las abcisas y ordenas."

# ╔═╡ d291f0a0-585b-11eb-2760-79433733f2bd
"""
	makeGrid(g::Grid)
Crear una matriz de rangos [rango_abcisas,rango_ordenadas]
"""
function makeGrid(g::Grid)
	rango_abcisas  = 0:g.paso:g.limite_abcisas   #origen:paso:limite
	rango_ordenadas= 0:g.paso:g.limite_ordenadas #origen:paso:limite
	
	[rango_abcisas,rango_ordenadas]
end

# ╔═╡ 81c7c2c0-585c-11eb-27f7-9d6500737259
md"* Funciones de una línea para las formas biológicas y la familia de polinomios cuadráticos complejos"

# ╔═╡ 9e38a500-585c-11eb-03f9-5be3e141d5f6
begin ##*
	#Familia de polinomios cuadráticos complejos
	f₀(z::Complex, c::Complex)= z^2 + c
	
	
	#Funciones usadas para reproducir formas biológicas
	f₁(z::Complex, c::Complex)= sin(z) + z^2 +c
	f₂(z::Complex, c::Complex)= z^z + z^6 +c
	f₃(z::Complex, c::Complex)= z^z + z^5 +c
	f₄(z::Complex, c::Complex)= z^5 +c
	f₅(z::Complex, c::Complex)= z^3 +c
end

# ╔═╡ a71cf360-585c-11eb-2503-09522c1a63b7
md"* Función que retorna `true` si el criterio de convergencia para los conjuntos $J_c$ y $M_{fc}$ se cumple. Retorna `false` en caso contrario."

# ╔═╡ cf71cf72-585c-11eb-1fb9-0913a195ddd4
""" *
	testJM(z::Complex)
Comprobar el criterio de convergencia para los conjuntos de Julia y Mandelbrot
"""
function testJM(z::Complex)
	if abs(z)<2        #Criterio de convergencia |zₙ|<2
		return true    #Se cumple
	else
		return false   #No se cumple
	end
end

# ╔═╡ 6a574880-585d-11eb-1aac-e1d61b5fc7e6
md"* Función que retorna `true` si el criterio de convergencia para las formas biológicas se cumple y `false` en caso contrario."

# ╔═╡ 8818edae-585d-11eb-14eb-e5aba19f63cd
"""
	testbiomorph(z::Complex,τ::Real)
Comprobar el criterio de convergencia para las formas biológicas
"""
function testbiomorph(z::Complex,τ::Real)
	if abs(real(z))<τ || abs(imag(z))<τ  #Criterio |Re(zₙ)|<τ or |Im(zₙ)|<τ
		return true   #Se cumple
	else
		return false  #No se cumple
	end
end

# ╔═╡ b27e8150-585d-11eb-0b8c-c527502a4df6
md"* Función que itera un número sobre una función $f_c$ y devuelve `true` si se cumple el criterio de divergencia para $J_{fc}$, $M_{fc}$ y formas biológicas. Retorna `false` si diverge. Además, **c** y **τ** son opcionales. Si no se ingresan estos dos parámetros sus valores por defecto serán c=0im y τ=100"

# ╔═╡ ece38a70-585d-11eb-1ba9-6bf688115b8a
"""
	iterate(test::Function,f::Function,z::Complex,iter::Integer)
Interar z sobre una funcion f
"""
function iterate(test::Function,f::Function,z::Complex,iter::Integer, c::Complex=0im, τ::Real=100)
	
	cumple= true
	
	for i ∈ 1:iter
		if test==testJM && test(z)==false #test conjuntos J y M 
			cumple= false
			break #Si no se cumple nos salimos del bucle
		elseif test==testbiomorph && test(z, τ)==false #test formas biológicas
			cumple = false
			break #Si no se cumple nos salimos del bucle
		end
		z= f(z, c)
		i+=1	
	end
	
	cumple  #Al final retorna si se cumple (true) o no (false) el test
end

# ╔═╡ db0d1450-5908-11eb-0cda-e12faf109f07
md"* Función que devuelve el número de iteraciones realizadas para un dado z (número complejo), hasta que se no se cumple el criterio de divergencia.."

# ╔═╡ 06d255b0-585e-11eb-1728-097f2e554508
"""*
	colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
Retornar el número de iteraciones para un valor dado de z mientras un criterio de convergencia sea válido
"""
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
	n=1
	while n<=iter
		if iterate(test, f, z, n,c)==false
			return(n) #Si diverge se detiene y retorna las iteraciones
			break
		end
		n+=1
	end
	iter #Si nunca divergió retorna las iteraciones totales
end

# ╔═╡ 0a25ed80-585e-11eb-11a2-dda4146ebd87
md"* Usando multiple dispatch, se define nuevamente la función colormap agregando un nuevo parámetro de entrada $\tau$, de modo que se puede usar el test de convergencia para la forma biológica"

# ╔═╡ 15551640-585e-11eb-3e01-7b46b0cfc511
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer,τ::Integer)
	n=1
	while n<=iter
		if iterate(test, f, z, iter, c, τ)==false
			return(n)  #Si diverge se detiene y retorna las iteraciones
			break
		end
		n+=1
	end
	iter  #Si nunca divergió retorna las iteraciones totales
end

# ╔═╡ 7f16b4d0-5912-11eb-2c9a-1366da054c92
colormap(f₀, testJM, 0im, 0im, 30)

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
# ╟─db0d1450-5908-11eb-0cda-e12faf109f07
# ╠═06d255b0-585e-11eb-1728-097f2e554508
# ╠═7f16b4d0-5912-11eb-2c9a-1366da054c92
# ╟─0a25ed80-585e-11eb-11a2-dda4146ebd87
# ╠═15551640-585e-11eb-3e01-7b46b0cfc511
