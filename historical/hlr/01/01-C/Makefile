override CFLAGS += -std=c99

# ziemlich ohne Fantasie, aber tut (wenigstens bei mir lokal) 
# seinen Dienst nach den Spezifikationen

default:
	gcc $(CFLAGS) -o pointer.out pointer.c
	gcc $(CFLAGS) -o map.out map.c

pointer:
	gcc $(CFLAGS) -o pointer.out pointer.c

map:
	gcc $(CFLAGS) -o map.out map.c

	
clean:
	rm -f map.out pointer.out