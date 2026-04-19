#include "aldor"                                                -- inclui a biblioteca padrão do Aldor
#include "aldorio"                                             -- inclui a biblioteca de entrada e saída
import from MachineInteger;                                     -- importa o tipo inteiro de precisão simples
import from Boolean;                                           -- importa o tipo booleano e suas operações

Rectangle: with {
    make: (MachineInteger, MachineInteger, MachineInteger, MachineInteger) -> %; -- construtor: cria um retângulo a partir de x, y, largura e altura
    AABB: (%, %) -> Boolean;                                   -- verifica colisão entre dois retângulos (Axis-Aligned Bounding Box)
    x: % -> MachineInteger;                                       -- retorna a coordenada x do retângulo
    y: % -> MachineInteger;                                       -- retorna a coordenada y do retângulo
    w: % -> MachineInteger;                                       -- retorna a largura do retângulo
    h: % -> MachineInteger;                                       -- retorna a altura do retângulo
} == add {
    Rep ==> Record(x: MachineInteger, y: MachineInteger,             -- representação interna do retângulo como registro
                   w: MachineInteger, h: MachineInteger);
    import from Rep;                                           -- importa as operações do registro

    make(rx: MachineInteger, ry: MachineInteger,
         rw: MachineInteger, rh: MachineInteger): % == per [rx,ry,rw,rh]; -- armazena x, y, largura e altura no registro

    AABB(r1: %, r2: %): Boolean ==                             -- retorna true se os retângulos se sobrepõem em ambos os eixos
        (x(r1)+w(r1) >= x(r2)) /\ (x(r2)+w(r2) >= x(r1)) /\
        (y(r1)+h(r1) >= y(r2)) /\ (y(r2)+h(r2) >= y(r1));

    x(r: %): MachineInteger == rep(r).x;                         -- acessa a coordenada x da representação interna
    y(r: %): MachineInteger == rep(r).y;                         -- acessa a coordenada y da representação interna
    w(r: %): MachineInteger == rep(r).w;                         -- acessa a largura da representação interna
    h(r: %): MachineInteger == rep(r).h;                         -- acessa a altura da representação interna
}

import from Rectangle;                                         -- importa as operações do domínio Rectangle

R1 := make(0,0,4,7);                             -- cria o retângulo R1 em (0,0) com largura 4 e altura 7
R2 := make(0,6,10,5);                            -- cria o retângulo R2 em (0,6) com largura 10 e altura 5
R3 := make(7,5,3,3);							-- cria o retângulo R3 em (7,5) com largura 3 e altura 3

stdout << "O retangulo R1 colide com R2? " << AABB(R1,R2) << newline;
stdout << "O retangulo R2 colide com R3? " << AABB(R2,R3) << newline;     
stdout << "O retangulo R3 colide com R1? " << AABB(R3,R1) << newline;              