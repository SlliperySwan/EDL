#include "aldor"                                                        -- inclui a biblioteca padrão do Aldor
#include "aldorio"                                                       -- inclui a biblioteca de entrada e saída
import from MachineInteger;												-- importa o tipo inteiro e suas operações
import from SingleFloat;                                                 -- importa o tipo ponto flutuante de precisão simples e suas operações
import from Boolean;                                                     -- importa o tipo booleano e suas operações

sqrt(x: SingleFloat): SingleFloat == {                                   -- calcula a raiz quadrada usando o método de Newton
    x <= 0.0 => 0.0;                                                     -- retorna 0 se x for negativo ou zero
    aux := x / 2.0;                                                    -- chute inicial: metade de x
    for i in 1..20 repeat                                                -- itera 20 vezes para convergir
        aux := (aux+x/aux)/ 2.0;                             -- fórmula de Newton: nova estimativa
    aux                                                                -- retorna a estimativa final
}

clamp(t: SingleFloat, chao: SingleFloat, teto: SingleFloat): SingleFloat == -- limita t entre chao e teto
    if t < chao then chao                                                    -- se t menor que chao, retorna chao
    else if t > teto then teto                                               -- se t maior que teto, retorna teto
    else t;                                                              -- senão retorna t

Point: with {                                                            -- dominio Point, implementado previamente, com algumas modificações
    make: (SingleFloat, SingleFloat) -> %;                               -- construtor: cria um ponto a partir de x e y
    x: % -> SingleFloat;                                              -- retorna a coordenada x do ponto
    y: % -> SingleFloat;                                              -- retorna a coordenada y do ponto
} == add {
    Rep ==> Record(x: SingleFloat, y: SingleFloat);                      -- representação interna do ponto como registro
    import from Rep;                                                     -- importa as operações do registro

    make(px: SingleFloat, py: SingleFloat): % == per [px, py];          -- armazena x e y no registro
    x(p: %): SingleFloat == rep(p).x;                                   -- acessa a coordenada x da representação interna
    y(p: %): SingleFloat == rep(p).y;                                   -- acessa a coordenada y da representação interna
}

Segment: with {                                                          -- dominio Segment
    make: (Point,Point) -> %;                                       -- construtor: cria um segmento a partir de dois pontos
    a: % -> Point;                                                -- retorna o ponto inicial do segmento
    b: % -> Point;                                                -- retorna o ponto final do segmento
    distance: (%,Point) -> SingleFloat;                                 -- calcula a distância do segmento a um ponto
} == add {
    Rep ==> Record(a: Point, b: Point);                                  -- representação interna do segmento como registro
    import from Rep;                                                     -- importa as operações do registro
    import from Point;                                                   -- importa as operações do domínio Point

    make(pa: Point, pb: Point): % == per [pa, pb];                      -- armazena os dois pontos no registro
    a(s: %): Point == rep(s).a;                                         -- acessa o ponto inicial da representação interna
    b(s: %): Point == rep(s).b;                                         -- acessa o ponto final da representação interna

    distance(s: %, p: Point): SingleFloat == {                          -- calcula a distância mínima entre o segmento e o ponto
        abx := x(b s)-x(a s);                                         -- componente x do vetor AB
        aby := y(b s)-y(a s);                                         -- componente y do vetor AB
        apx := x(p)-x(a s);                                         -- componente x do vetor AP
        apy := y(p)-y(a s);                                         -- componente y do vetor AP
        modab := abx*abx+aby*aby;                                    -- produto escalar de AB com AB
        modapab := apx*abx+apy*aby;                                    -- produto escalar de AP com AB
        t := clamp(modapab/modab, 0.0, 1.0);                   -- projeta P em AB e limita entre 0 e 1 (dentro do segmento)
        qx := x(a s)+t*abx;                                         -- coordenada x do ponto mais próximo Q no segmento
        qy := y(a s)+t*aby;                                         -- coordenada y do ponto mais próximo Q no segmento
        dx := x(p)-qx;                                                -- diferença em x entre P e Q
        dy := y(p)-qy;                                                -- diferença em y entre P e Q
        sqrt(dx*dx+dy*dy)                                              -- retorna a distância euclidiana entre P e Q
    }
}

import from Point;                                                       -- importa as operações do domínio Point
import from Segment;                                                     -- importa as operações do domínio Segment

A := make(0.0, 0.0)$Point;                                              -- cria o ponto A na origem (0, 0)
B := make(4.0, 0.0)$Point;                                              -- cria o ponto B em (4, 0)
P1 := make(2.0, 3.0)$Point;                                              -- cria o ponto P1 em (2, 3)
P2:= make(4.0, 7.0)$Point;                                              -- cria o ponto P1 em (4, 7)
P3 := make(9.0, -5.0)$Point;                                              -- cria o ponto P1 em (9, -5)

S := make(A, B)$Segment;                                                -- cria o segmento S de A até B
              
stdout << "Distancia de P1 ao segmento: " << distance(S,P1) << newline;   -- calcula e mostra a distância de P1 ao segmento S
stdout << "Distancia de P2 ao segmento: " << distance(S,P2) << newline;   -- calcula e mostra a distância de P2 ao segmento S   
stdout << "Distancia de P3 ao segmento: " << distance(S,P3) << newline;   -- calcula e mostra a distância de P3 ao segmento S   
       