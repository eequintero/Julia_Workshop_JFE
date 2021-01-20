### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ d1d53fe0-5a96-11eb-0eac-c7e18bf9c99c
begin
	using Pkg; Pkg.activate("."); Pkg.instantiate()
	using Plots	
end

# ╔═╡ d170dbf0-5a9a-11eb-0022-bf532cebc244
struct Grid{T<:Real}
	limite_abcisas::T
	limite_ordenadas::T
	paso::T
end

# ╔═╡ d0a48b40-5a9a-11eb-13fa-e79ee2995e3a
function makeGrid(g::Grid)
	rango_abcisas=-g.limite_abcisas:g.paso:g.limite_abcisas
	rango_ordenadas=-g.limite_ordenadas:g.paso:g.limite_ordenadas
return [x+y*im for x in rango_abcisas,y in rango_ordenadas]
end 

# ╔═╡ a400ff70-5aa3-11eb-07b2-a17d094e0a61
begin
    g=Grid{Float64}(2,2,0.01)
	matriz=makeGrid(g)
end

# ╔═╡ e81e5ee0-5a9a-11eb-15cc-09b65ce5b6cb
begin ##* 
	f_0(z::Complex,c::Complex)=z^2+c
end 

# ╔═╡ efcb65c0-5a9a-11eb-12a5-cd939be44320
function testJM(z::Complex)
	abs(z)<2
end

# ╔═╡ f6e5c990-5a9a-11eb-3449-73a30012d85d
function testbiomorph(z::Complex,τ::Real)
	abs(real(z))<τ || abs(imag(z))<τ
end

# ╔═╡ 017c5bd0-5a9b-11eb-31fa-b16d854561f1
function iterate(test::Function,f::Function,z::Complex,iter::Integer,c::Complex,τ::Real)
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
	

# ╔═╡ 09f53e30-5a9b-11eb-228f-0f2d92daac8d
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer,τ::Integer)
	n=0
	while n<=iter
		if iterate(test, f, z, iter, c, τ)==false
			return(n)  #Si diverge se detiene y retorna las iteraciones
			break
		end
		n+=1
	end
	return iter  #Si nunca divergió retorna las iteraciones totales
end

# ╔═╡ 1829b7b0-5a9b-11eb-23e7-256a305cc62c
function setjulia(f::Function,test::Function,grid::Array{T,2} where T,c::Complex,iter::Integer,τ::Real=0)
	m= size(grid,1) #número de abcisas (eje X)
	n= size(grid,2) #número de ordenadas (eje Y) 
	
	In_set= Array{Float64}(undef,n,m)  #Array vacío
	
	for i ∈ 1:m
		for j ∈ 1:n
			z=grid[i,j]
			In_set[i,j]=colormap(f,test,z,c,iter,0)
			j=+1
		end
		i+=1
	end
	return transpose(In_set)
end


# ╔═╡ f20e3460-5a9b-11eb-26c5-01947142daf2
begin  #Ajustamos los valores de default para el tamaño de la gráfica
	tamanio = 50
	Plots.default(size = (2200,2200),titlefontsize = tamanio, tickfontsize = tamanio, 	  legendfontsize = tamanio, guidefontsize = tamanio, legendtitlefontsize = tamanio)
end

# ╔═╡ cd48b940-5a9e-11eb-3f96-518de5c183d2
begin
	x= -g.limite_abcisas:g.paso:g.limite_abcisas   
	y= -g.limite_ordenadas:g.paso:g.limite_ordenadas
	colores= setjulia(f_0,testJM, matriz,0.1+0.5*im, 15,0)
	
	heatmap(x, y, colores, color=cgrad([:white,:pink,:red]), title="Conjunto de Julia (Heatmap)", xlabel="Re(z)", ylabel="Im(z)")
	
end

# ╔═╡ Cell order:
# ╠═d1d53fe0-5a96-11eb-0eac-c7e18bf9c99c
# ╠═d170dbf0-5a9a-11eb-0022-bf532cebc244
# ╠═d0a48b40-5a9a-11eb-13fa-e79ee2995e3a
# ╠═a400ff70-5aa3-11eb-07b2-a17d094e0a61
# ╠═e81e5ee0-5a9a-11eb-15cc-09b65ce5b6cb
# ╠═efcb65c0-5a9a-11eb-12a5-cd939be44320
# ╠═f6e5c990-5a9a-11eb-3449-73a30012d85d
# ╠═017c5bd0-5a9b-11eb-31fa-b16d854561f1
# ╠═09f53e30-5a9b-11eb-228f-0f2d92daac8d
# ╠═1829b7b0-5a9b-11eb-23e7-256a305cc62c
# ╠═f20e3460-5a9b-11eb-26c5-01947142daf2
# ╠═cd48b940-5a9e-11eb-3f96-518de5c183d2
