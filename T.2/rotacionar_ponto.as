#include "aldor"                                                -- inclui a biblioteca padrão do Aldor
#include "aldorio"                                              -- inclui a biblioteca de entrada e saída
import from SingleFloat;                                        -- importa o float

PI: SingleFloat == 3.14159265358979;                            -- define PI

toRadians(deg: SingleFloat): SingleFloat == deg * PI / 180.0;   -- converte graus para radianos

sin(x: SingleFloat): SingleFloat == {                           -- calcula o seno usando série de Taylor
    x3 := x * x * x;                                            -- x elevado à 3ª potência
    x5 := x3 * x * x;                                           -- ...         5ª
    x7 := x5 * x * x;                                           -- ...         7ª
    x - x3/6.0 + x5/120.0 - x7/5040.0                           -- fórmula da série de Taylor para seno
}

cos(x: SingleFloat): SingleFloat == {                           -- calcula o cosseno usando série de Taylor
    x2 := x * x;                                                -- x elevado à 2ª potência
    x4 := x2 * x2;                                              -- ...         4º
    x6 := x4 * x2;                                              -- ...         6º
    1.0 - x2/2.0 + x4/24.0 - x6/720.0                           -- fórmula da série de Taylor para cosseno
}

Point: with {                                                   -- define o domínio Point
    make: (SingleFloat, SingleFloat) -> %;                      -- construtor: cria um ponto a partir de x e y
    rotateAround: (%, %, SingleFloat) -> %;                     -- rotaciona um ponto ao redor de um centro por um ângulo
    x: % -> SingleFloat;                                        -- retorna a coordenada x do ponto
    y: % -> SingleFloat;                                        -- retorna a coordenada y do ponto
} == add {
    Rep ==> Record(x: SingleFloat, y: SingleFloat);             -- representação interna do ponto como um registro
    import from Rep;                                            -- importa as operações do registro

    make(px: SingleFloat, py: SingleFloat): % == per [px,py];   -- cria um registro armazenando x e y

    rotateAround(p: %, center: %, angle: SingleFloat): % == {   -- implementa rotateAround
        angle := toRadians(angle);                              -- converte angle graus para radianos
        nx := x(p) - x(center);                                 -- traz centro para (0,0) e move P de acordo
        ny := y(p) - y(center);                                 -- ...
        c := cos(angle);                                        -- calcula o cosseno do ângulo
        s := sin(angle);                                        -- calcula o seno do ângulo
        make(nx*c - ny*s + x(center), nx*s + ny*c + y(center)); -- rotaciona e retorna ao centro
    }

    x(p: %): SingleFloat == rep(p).x;                           -- acessa a coordenada x da representação interna
    y(p: %): SingleFloat == rep(p).y;                           -- acessa a coordenada y da representação interna
}

import from Point;                                              -- importa as operações do domínio Point
P := make(3.0, 4.0);                                            -- cria o ponto P em (3, 4)
Q := make(0.0, 0.0);                                            -- cria o ponto Q em (0, 0)
N := 90.0;                                                      -- define o ângulo N em 90
P := rotateAround(P, Q, N);                                     -- rotaciona P ao redor de Q por N graus
stdout << "P = " << x(P) << "," << y(P) << newline;             -- exibe as coordenadas do ponto rotacionado