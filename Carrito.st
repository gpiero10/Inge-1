!classDefinition: #CarritoDeComprasTest category: #Carrito!
TestCase subclass: #CarritoDeComprasTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Carrito'!

!CarritoDeComprasTest methodsFor: 'tests' stamp: 'rf 11/7/2025 21:34:55'!
test01CarritoNuevoEstaVacio
	|carrito|
	carrito := CarritoDeCompras new.
	
	self assert: carrito items equals: OrderedCollection new.! !

!CarritoDeComprasTest methodsFor: 'tests' stamp: 'rf 11/7/2025 21:40:09'!
test02CarritoNoAgregaItemQueNoEstaEnElCatalogo
	|carrito carritoCantidadDeItems|
	carrito := CarritoDeCompras new.
	carritoCantidadDeItems := carrito items size.
	
	self should: [carrito add: 'Antony: La Biografia del GOAT'] 
		raise: Error
		withExceptionDo: [:error | 
			error messageText = CarritoDeCompras errorDeProductoNoEnOferta.
			self assert: carrito items size = carritoCantidadDeItems ] 
	
	! !

!CarritoDeComprasTest methodsFor: 'tests' stamp: 'rf 11/7/2025 22:01:13'!
test03CarritoAgregaMuchosLibrosQueEstanEnElCatalogo

	|carrito|
	carrito := CarritoDeCompras conUnCatalogo: (OrderedCollection with: 'Antony: History of the GOAT' with: 'CR7' with: '9/11').
	
	carrito add: 'Antony: History of the GOAT'.
	carrito add: 'CR7'.
	carrito add: '9/11'.
	
		
	self assert: (carrito contiene: 'Antony: History of the GOAT').
	self assert: (carrito contiene: 'CR7').
	self assert: (carrito contiene: '9/11').! !

!CarritoDeComprasTest methodsFor: 'tests' stamp: 'rf 11/7/2025 22:01:48'!
test04CarritoAgregaUnPedidoMayoristaDeLibrosQueEstanEnElCatalago
	|carrito|
	carrito := CarritoDeCompras conUnCatalogo: (OrderedCollection with: 'Antony: History of the GOAT' with: 'CR7' with: 'Cazadores De Utopias 
	Imposibles').
	
	carrito agregarCantidadDeEjemplares: 50 deEsteLibro: 'Antony: History of the GOAT' .
	
	carrito agregarCantidadDeEjemplares: 50 deEsteLibro: 'CR7' .
	
	carrito agregarCantidadDeEjemplares: 50 deEsteLibro: 'Cazadores De Utopias Imposibles'.
	
		
	self assert: (carrito contieneEstaCantidadDeUnidades: 50 DeEsteLibro: 'Antony: History of the GOAT').
	self assert: (carrito contieneEstaCantidadDeUnidades: 50 DeEsteLibro: 'CR7').
	self assert: (carrito contieneEstaCantidadDeUnidades: 50 DeEsteLibro: 'Cazadores De Utopias Imposibles').
	.! !


!classDefinition: #CarritoDeCompras category: #Carrito!
Object subclass: #CarritoDeCompras
	instanceVariableNames: 'catalogo itemsAgregados'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Carrito'!

!CarritoDeCompras methodsFor: 'init' stamp: 'rf 11/7/2025 21:50:49'!
initializeConUnCatalogo: unCatalogo 
	itemsAgregados := OrderedCollection new.
	catalogo := unCatalogo.! !

!CarritoDeCompras methodsFor: 'init' stamp: 'rf 11/7/2025 21:35:27'!
items
	^OrderedCollection new! !


!CarritoDeCompras methodsFor: 'as yet unclassified' stamp: 'rf 11/7/2025 21:49:54'!
add: unLibroPedido
	(catalogo includes: unLibroPedido)  ifFalse: [ ^self error: self class errorDeProductoNoEnOferta].
	
	itemsAgregados add: unLibroPedido.
! !

!CarritoDeCompras methodsFor: 'as yet unclassified' stamp: 'rf 11/7/2025 22:03:23'!
agregarCantidadDeEjemplares: unaCantidad deEsteLibro: unLibro 
	
	itemsAgregados at: unLibro put: unaCantidad .! !

!CarritoDeCompras methodsFor: 'as yet unclassified' stamp: 'rf 11/7/2025 21:49:41'!
contiene: unLibro 
	^itemsAgregados includes: unLibro. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CarritoDeCompras class' category: #Carrito!
CarritoDeCompras class
	instanceVariableNames: ''!

!CarritoDeCompras class methodsFor: 'as yet unclassified' stamp: 'rf 11/7/2025 21:43:14'!
errorDeProductoNoEnOferta
	^'No te puedo vender algo que nunca ofreci'! !


!CarritoDeCompras class methodsFor: 'instance creation' stamp: 'rf 11/7/2025 21:48:03'!
conUnCatalogo: unCatalogo 
	
	^self new initializeConUnCatalogo: unCatalogo ! !
