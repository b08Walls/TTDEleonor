

print(node.heap())
print("acaba de iniciar la llamada a la funcion")
print("*************************************************")
local from,to,number = ...

local function functionOne(from, to)

	for i=from,to do
		--print(i)
	end

end

print(node.heap())
print("Declaracion de la functionOne se acaba de realizar")
print("*************************************************")

local function factorial(number)

	local acumulado = 1

	for i=1,number do
		acumulado = acumulado*i
	end

	return acumulado
end
print(node.heap())
print("Declaracion de la funcion factorial se acaba de realizar")
print("*************************************************")

local resultadoFactorial = nil
print(node.heap())
print("variable local resultadoFactorial se acaba de declarar")
print("*************************************************")

if from and to then
	functionOne(from,to)
	print(node.heap())
	print("se acaba de mandar a llamar la functionOne")
	print("*************************************************")
end

if number then
	resultadoFactorial = factorial(number)
	print(node.heap())
	print("se acaba de mandar a llamar la funcion factorial")
	print("*************************************************")
end

return resultadoFactorial

