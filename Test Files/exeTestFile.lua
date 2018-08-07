
print(node.heap())
print("EL PROGRAMA ACABA DE COMENZAR CASI TODO EN CEROS")
print("----------------------------------------------------")
functionTest = assert(loadfile('testFile1.lua'))

print(node.heap())
print("Ya se llevo acabo la compilacion de functionTest")
print("----------------------------------------------------")

resultado = functionTest(0,100,100)

print(node.heap())
print("Se termino de ejecutar la functionTest")
print("----------------------------------------------------")

functionTest = nil

print(node.heap())
print("Se elimino la funcion functionTest")
print("----------------------------------------------------")
print(functionTest)
print("RESULTADO: ",resultado)