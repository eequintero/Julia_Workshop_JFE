### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ e8b92820-5901-11eb-375b-81906de8f254
using Plots

# ╔═╡ abec3c30-5900-11eb-2299-cb5807fb5743
import Pkg

# ╔═╡ d7821270-5900-11eb-153a-1baf2f044436
Pkg.add("Plots")

# ╔═╡ 66163170-5923-11eb-30b2-ebb4042f31d3
struct Grid{T<:Real}
	limite_abcisas::T
	limite_ordenadas::T
	paso::T
end

# ╔═╡ 9ab62d90-5923-11eb-1ff0-479e31e1f714
function makeGrid(g::Grid)
	rango_abcisas=0:g.paso:g.limite_abcisas
	rango_ordenadas=0:g.paso:g.limite_ordenadas
	[rango_abcisas,rango_ordenadas]
end 

# ╔═╡ bcb46270-590c-11eb-1701-c9f3bd9b024d
begin ##* 
	f_0(z::Complex,c::Complex)=z^2+c
end 

# ╔═╡ babb3fa0-590e-11eb-156d-ad8c7dd7d4ba
function testJM(z::Complex)
	abs(z)<2
end

# ╔═╡ 0f19e970-590f-11eb-287d-3bbaf1370566
function testbiomorph(z::Complex,τ::Real)
	abs(real(z))<τ || abs(imag(z))<τ
end

# ╔═╡ 9e4e9130-5910-11eb-132c-7d8bb54f8e9d
function iterate(test::Function,f::Function,z::Complex,iter::Integer,c::Complex,τ::Real)
	z_i=z;
	if test==testJM 
	 for i=1:iter 
		if test(z_i)==false break
			end 
		z_i=f(z_i,c); 
		i+=1
		end
		return testJM(z_i)
	end 
		
	if test==testbiomorph
	 for i=1:iter 
		if test(z_i,τ)==false break
			end 
		z_i=f(z_i,c); 
		i+=1
		end
		return testbiomorph(z_i,τ)
	end 
	
end

# ╔═╡ a41a01a2-5922-11eb-143e-1f80d85ec506
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

# ╔═╡ be4a7ce0-593a-11eb-28c9-195707e3e9d0
function setjulia(f::Function,test::Function,grid::Array{T,2} where T,c::Complex,iter::Integer,τ::Real=0)
	m=size(grid,1); #el numero de filas
	n=size(grid,2); #el numero de columnas
    matriz_ceros=zeros(m,n) #creamos una matriz de ceros de mxn
	  for i in 1:m
         for j in 1:n
            value=iterate(test,f,grid[i,j],iter,c,τ) #ver si cumple la convergencia
            if value==true
				matriz_ceros[i,j]=grid[i,j]
            else
                matriz_ceros[i,j]=0
            end
        end
    end
    return matriz_ceros
end

# ╔═╡ 0f1d7d02-593d-11eb-257d-d105bb61cce6
#begin
#grid=Grid{Float64}(-2,2,0.1)
#matriz=makeGrid(grid)
#conjunto_Julia=setjulia(f_0,testJM,matriz,0*im,5,0)
#scatter(conjunto_Julia, seriescolor=:white,markerstrokecolor=:blue,aspectratio=1,title="Conjunto de Julia",legend=false,markersize=40)
#end

# ╔═╡ Cell order:
# ╠═abec3c30-5900-11eb-2299-cb5807fb5743
# ╠═d7821270-5900-11eb-153a-1baf2f044436
# ╠═e8b92820-5901-11eb-375b-81906de8f254
# ╠═66163170-5923-11eb-30b2-ebb4042f31d3
# ╠═9ab62d90-5923-11eb-1ff0-479e31e1f714
# ╠═bcb46270-590c-11eb-1701-c9f3bd9b024d
# ╠═babb3fa0-590e-11eb-156d-ad8c7dd7d4ba
# ╠═0f19e970-590f-11eb-287d-3bbaf1370566
# ╠═9e4e9130-5910-11eb-132c-7d8bb54f8e9d
# ╠═a41a01a2-5922-11eb-143e-1f80d85ec506
# ╠═be4a7ce0-593a-11eb-28c9-195707e3e9d0
# ╠═0f1d7d02-593d-11eb-257d-d105bb61cce6
