library('Cairo')

data0 <- read.table('./results/runtimes.txt')

s <- c(data0[1]$V2, data0[2]$V2)

cairo_ps("./results/runtimes.eps", width=10, height=10) 

p <- barplot(s, main="1024 × 1024 méretű, egészeket tartalmazó mátrixok szorzása \nProgram futási ideje -O3 optimalizálással(auto-vektorizálással) és annak kikapcsolása esetén", xlab="Fordítási kapcsolók", ylab="futásidő (s)", names.arg=c("-O0", "-O3"))

print(p)
dev.off()
