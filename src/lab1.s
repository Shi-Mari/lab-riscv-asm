#
# Подрограмма расчета суммы элементов двумерного массива 4x4
#
# Требуемая строка задается меткой row_number
#

#Секция изменяемых данных
.data

#Строка для вывода сообщения на экран
print_string:      .asciiz "Calculated sum: "

#Исходный массив 4х4
array:      
    .word 11, 12, 13, 14
    .word 21, 22, 23, 24
    .word 31, 32, 33, 34
    .word 41, 42, 43, 44

#Длина строки массива
array_row_length:
    .word 4

#Номер строки (начинаем счет с 0) 
row_number:
    .word 1

#Секция кода
.text
.globl MAIN

MAIN:
	#Загружаем в регистр a3 длину строки массива
    la a3, array_row_length
    lw a3, 0(a3)
    #Загружаем в регистр а4 адрес первого элемента массива
    la a4, array

	#
	# Сдвигаем на N адрес, чтобы получить доступ к нужной строке двумерного массива. 
    # Для этого в цикле сдвинем адрес нужное кол-во раз
    
    #Загружаем номер строки из памяти в регистр t0
    la t0, row_number
    lw t0, 0(t0)
    #Счетчик циклов будет t1, загружаем туда 0
    li t1, 0
    
    #Собственно, цикл
shift_row:
	# if(t1 >= t0) тогда переходим на метку shift_row_end(конец цикла)
	bgeu t1, t0, shift_row_end
    
    #Cдвиге адреса на кол-во элементов в массиве * 4 (потому что 1 элемент = 4 байта)
    slli a5, a3, 2 # a5 = a3 << 2 = a3 * 4
    add a4, a4, a5 # a4 = a4 + a5 = a4 + a3 * 4
    
    #Увеличиваем счетчик циклов на 1
    addi t1, t1, 1
    
    #Просто прыгаем обратно в начало цикла
    jal zero, shift_row # goto shift_row

	#Сюда приходим после завершения цикла сдвига
shift_row_end:

	#Обнуляем счетчик циклов для нового цикла - сложения всех элементов строки
    li a2, 0
    #Для хранения искомой суммы будем использовать регистр a7, обнуляем его
    li a7, 0

	#Цикл сложения всех чисел строки
loop:
	# if(a2 >= a3) тогда переходим на метку loop_exit(конец цикла)
    bgeu a2, a3, loop_exit
    
    #Получение адреса элемента в строке
    slli a5, a2, 2 # a5 = a2 << 2 = a2 * 4
    add a5, a4, a5 # a5 = a4 + a5 = a4 + a2 * 4

    lw t2, 0(a5) # t2 = array[i] - тут загружаем из массива(памяти) в регистр элемент для работы с ним
    
    #Прибавляем элемент к сумме
    add a7, a7, t2

	#Увеличиваем счетчик циклов на 1
    addi a2, a2, 1
    
    #Переходим обратно в начало цикла
    jal zero, loop # goto loop

	#Сюда приходим после завершения цикла сложения
loop_exit:
	#Печатаем строку 
    addi  a0, zero, 4      # 4 - print_string ecall
    la    a1, print_string # в а1 нужно загрузить адрес строки в памяти
    ecall
    
	#Печатаем сумму(число)
    addi a0, zero, 1        # 1 - print_int ecall
    add a1, zero, a7		# в а1 нужно загрузить нужное число(регистр с числом)
    ecall

	#Печатаем символ перевода строки
    addi a0, zero, 11
    addi a1, zero, '\n'
    ecall

#Конец программы - выходим через системный вызов
exit:
    addi  a0, zero, 10      
    ecall