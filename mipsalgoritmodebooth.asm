.data
tab: .asciiz "\t"
endl: .asciiz "\n"
error_mensaje: .asciiz "El error esta en los argumentos "
m_primernumero: .asciiz "Ingrese el primer numero:  "
m_segundonumero: .asciiz "Ingrese el segundo numero:  "
m_resultado: .asciiz "El resultado es :  "
.text
.globl start
#INDICE DE VARIABLES
#a0 = primer numero(M)
#a1 = segundo numero(Q)
#v0 = primera parte del producto 
#v1 = segunda parte del producto
#a2 = valor temporal del primer numero(M)
#a3 = valor temporal del segundo numero(Q)
#s1 = valor del A en el algorimo de booth
#s2 = valor de Q-1(Q sub -1) en A. BOOTH 
#s3 = contador
#s4 = Qo
#t1 = valor temporal de A0
#s7 = valor temporal de v0
#t5 = A mas significativo
start:
	#cargar el contador
    	li $s3,32
    	#CARGAR EL VALOR DE A
    	li $s1,0
    	#cargar el valor de Q-1
    	li $s2,0
    	# Cargar el m_primernumero(M)
    	li $v0, 4
    	la $a0, m_primernumero    
    	syscall
    	# Cargar el primernumero(M)
    	li $v0, 5
    	syscall
    	move $a2, $v0
    
    	# Cargar el m_segundonumero(Q)
    	li $v0, 4
    	la $a0, m_segundonumero
 	syscall
  	# Cargar el segundonumero(Q)
 	li $v0, 5
 	syscall
 	move $a3, $v0
   	#el bit menos significativo de Qo
   	#move $t6,$a3
    	move $s4,$a3
	andi $s4,$s4,1 
    	#bucle para las condiciones
    	bgt $s4, $s2,llamarcaso1
    	bgt $s2, $s4,llamarcaso2
    	beq $s4,$s2,llamarcaso3
    	
    	#fin del programa
	li $v0, 10
    	syscall
print:
	mul $s7,$a2,$t6
	#aqui se carga los valores para el double
	move $v0,$s1
    	move $v1,$a3
    	#imprimirmensaje
    	li $v0, 4
    	la $a0, m_resultado
   	syscall
   	#imprimir los datos
   	li $v0, 1
    	move $a0,$s1
    	syscall
    	li $v0, 1
    	move $a0,$a3
    	syscall
    	#fin del programa
	li $v0, 10
    	syscall
llamarcaso1:
	#a=a-m
	sub $s1,$s1,$a2
	#el bit menos significativo de Q
	move $s4,$a3
	andi $s4,$s4,1 
	jal corr_arit
	ble $s3,0,cierre
    	sub $s3,$s3,1
    	bgt $s4, $s2,llamarcaso1
    	bgt $s2, $s4,llamarcaso2
    	beq $s4,$s2,llamarcaso3
    	ble $s3,0,cierre
llamarcaso2:
		#a=a+m
	add $s1,$s1,$a2
	#el bit menos significativo de Q
    	move $s4,$a3
    	andi $s4,$s4,1 
    	jal corr_arit
    	ble $s3,0,cierre
    	sub $s3,$s3,1
    	bgt $s4, $s2,llamarcaso1
    	bgt $s2, $s4,llamarcaso2
    	beq $s4,$s2,llamarcaso3
    	ble $s3,0,cierre
llamarcaso3:
	jal corr_arit
	ble $s3,0,cierre
	sub $s3,$s3,1
	bgt $s4, $s2,llamarcaso1
    	bgt $s2, $s4,llamarcaso2
    	beq $s4,$s2,llamarcaso3
	ble $s3,0,cierre

corr_arit:
	ble $s3,0,cierre
    	#el bit menos significativo de A
    	move $t1,$s1
    	andi $t1,$t1,1 
    	#el bit menos significativo de Q
    	move $s4,$a3
    	andi $s4,$s4,1 
    	#valor de q-1
	move $s2,$s4
    	#corrimiento aritmetico de A
    	andi $t8,$s1,-2147483648
	sra $s1,$s1,1
	or $s1,$s1,$t8#corrige el A
	sll $t1, $t1, 31
	#corrimiento aritmetico de Q
	srl $a3,$a3,1
	or $a3,$a3,$t1	
	#actualizacion del significativo de Q
    	move $s4,$a3
    	andi $s4,$s4,1 
	#terminar el corrimiento
	jr $ra
cierre:	
	beqz $s3,print
	jr $ra
	
    
    

