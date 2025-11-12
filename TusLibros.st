!classDefinition: #CajeroPorVentaTest category: #TusLibros!
TestCase subclass: #CajeroPorVentaTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CajeroPorVentaTest methodsFor: 'as yet unclassified' stamp: 'gs 11/11/2025 20:16:00'!
test01CajeroPorVentaNoSeCreaSiCarritoVacio
	
	
	
	self should: [CajeroPorVenta crearCon: Cart new unCatalogo: OrderedCollection new unaTarjeta: Tarjeta new unaFecha: Date today]
		raise: Error
		withExceptionDo: [:error | error messageText = CajeroPorVenta errorDeCarritoVacio]
	! !

!CajeroPorVentaTest methodsFor: 'as yet unclassified' stamp: 'gs 11/11/2025 20:19:49'!
test02CajeroPorVentaNoSeCreaSiElClienteNoTieneGuita
	| catalogo carrito tarjeta|
	
	catalogo := OrderedCollection with: 'Antony' with: 'Sr Ortega y Sr Gasset'.
	
	tarjeta := Tarjeta conUnFondo: 0 yUnaExpiracion: 12/2029. 
	
	carrito := Cart acceptingItemsOf: catalogo.
	carrito add: 'Antony'.
	
	self should: [CajeroPorVenta crearCon: carrito unCatalogo: catalogo  unaTarjeta: tarjeta unaFecha: Date today ]
		raise: Error
		withExceptionDo: [:error | error messageText = CajeroPorVenta errorDeTarjetaVacia].
	! !

!CajeroPorVentaTest methodsFor: 'as yet unclassified' stamp: 'gs 11/11/2025 20:49:55'!
test03CajeroPorVentaRegistraLaOperacionSiElCheckoutSePudoConcretar
	|cajero precios carrito tarjeta|
	
	carrito := Cart acceptingItemsOf: (OrderedCollection with: 'Antony' with: 'Sr Ortega y Sr Gasset').
	carrito add: 'Antony'.
	
	precios := Dictionary new.
	precios at: 'Antony' put: 1000000. 
	precios at: 'Sr Ortega y Sr Gasset' put: 1.
	
	tarjeta := Tarjeta conUnFondo: 1000 yUnaExpiracion: 12/2029. 
	
	
	cajero := CajeroPorVenta crearCon: carrito  unCatalogo: precios  unaTarjeta: tarjeta  unaFecha: GregorianDayOfMonth today .
	
	self assert: cajero checkoutOk.
	! !


!classDefinition: #CartTest category: #TusLibros!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 0 of: self itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 2 of: self itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CajeroPorVenta category: #TusLibros!
Object subclass: #CajeroPorVenta
	instanceVariableNames: 'carro catalogo tarjeta fecha estado'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CajeroPorVenta methodsFor: 'actions' stamp: 'gs 11/11/2025 20:58:45'!
checkout
	|debito|
	debito := 0.
	
	catalogo keys do: [ :key | debito := debito + ((carro occurrencesOf: key)*catalogo at: key)].
	
	
	
	
	"tarjeta debitar: debito."
	
	
	
	
	
	
	
	"Si no se lanzo error y se realizo el cobro, el checkout termina y se registra"
	estado := true.! !


!CajeroPorVenta methodsFor: 'initialization' stamp: 'gs 11/11/2025 20:53:28'!
initializeCrearCon: unCarro unCatalogo: unCatalogo unaTarjeta: unaTarjeta unaFecha: enUnMomento 
	
	carro := unCarro.
	catalogo := unCatalogo.
	tarjeta := unaTarjeta.
	fecha := enUnMomento.
	
	estado := false.! !


!CajeroPorVenta methodsFor: 'tests' stamp: 'gs 11/11/2025 20:53:56'!
checkoutOK
	^estado! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CajeroPorVenta class' category: #TusLibros!
CajeroPorVenta class
	instanceVariableNames: ''!

!CajeroPorVenta class methodsFor: 'as yet unclassified' stamp: 'gs 11/11/2025 19:40:31'!
errorDeCarritoVacio
	^'No se puede validar esta compra'! !

!CajeroPorVenta class methodsFor: 'as yet unclassified' stamp: 'gs 11/11/2025 19:58:56'!
errorDeTarjetaVacia
	^ 'estafador'! !


!CajeroPorVenta class methodsFor: 'instance creation' stamp: 'gs 11/11/2025 20:20:47'!
crearCon: unCarro unCatalogo: unCatalogo unaTarjeta: unaTarjeta unaFecha: enUnMomento 
	unCarro isEmpty ifTrue: [ ^self error: self errorDeCarritoVacio ].
	(unaTarjeta notieneFondos) ifTrue: [^self error: self errorDeTarjetaVacia].
	
	^self new initializeCrearCon: unCarro unCatalogo: unCatalogo unaTarjeta: unaTarjeta unaFecha: enUnMomento ! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidItem: anItem

	(catalog includes: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Tarjeta category: #TusLibros!
Object subclass: #Tarjeta
	instanceVariableNames: 'monto fechaDeExpiracion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Tarjeta methodsFor: 'initialization' stamp: 'gs 11/11/2025 19:57:58'!
initializeConUnFondo: unMonto yUnaExpiracion: unaFechaDeExpiracion 
	
	monto := unMonto.
	fechaDeExpiracion := unaFechaDeExpiracion.! !

!Tarjeta methodsFor: 'initialization' stamp: 'gs 11/11/2025 19:58:34'!
notieneFondos
	^ monto = 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Tarjeta class' category: #TusLibros!
Tarjeta class
	instanceVariableNames: ''!

!Tarjeta class methodsFor: 'instance creation' stamp: 'gs 11/11/2025 19:57:48'!
conUnFondo: unMonto yUnaExpiracion: unaFechaDeExpiracion 
	
	^self new initializeConUnFondo: unMonto yUnaExpiracion: unaFechaDeExpiracion ! !
