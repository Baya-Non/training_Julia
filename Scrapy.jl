#クローラーです
using CSV 
data = Any[]


filename = "./Crawling/20170502.html"
PATH = "./Crawling/1720502"


f = open(filename)
lines = readlines(f)
close(f)

push!(data, "data!")

for l in lines
	t = match(r"('N)", l)
	if t !== nothing
		push!(data, l)
	end
end

for val = data
	println(val)
	
end

println("end!")

