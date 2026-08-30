--cenario:
--implementacao de uma loja de itens de um MOBA (LoL, DOTA, Deadlock...)
--um tipo de buff eh representado por um nome (ex.: dano_fisico ou vida_adicional) e um custo por unidade
--um buff eh um bonus consedido por um item, ele possui tipo, valor
--cada item possui um nome, um custo de construcao e uma lista de buffs
--a loja eh um conjunto de itens
--nem todos os itens possuem todos os buffs
--o item mais barato que fornece apenas um buff eh considerado componente base
--existe um componente base para cada tipo de buff 

type BuffType = (String,Float)
type Buff = (BuffType,Float)
type Item = (String,Float,[Buff])

loja :: [Item]

--lista de tipos de buffs do exemplo
df = ("dano_fisico", 35)
dm = ("dano_magico", 20)
as = ("velocidade_de_ataque", 25)

hp = ("vida_adicional", 2.6)
ar = ("armadura", 20)
mr = ("resistencia_magica", 20)
cr = ("reducao_de_cooldown", 50)

ms = ("velocidade_de_movimento", 40)

--lista de items do exemplo
machado_De_Guerra = ("Machado_De_Guerra",500,[(df,60),(as,15),(hp,300)])
cajado_Do_Arcanjo = ("Cajado_Do_Arcanjo",700,[(dm,90),(cr,30),(ms,10)])
peitoral_Adamantino = ("Peitoral_Adamantino",400,[(hp,300),(ar,75),(mr,75)])
botas_Serpentinas = ("Botas_Serpentinas",300,[(as,30),(cr,10),(ms,45)])
quebra_Cascos = ("Quebra_Cascos",300,[(df,30),(hp,350),(ar,40),(mr,40),(cr,10)])
espada = ("Espada",0,[(df,10)])
tomo = ("Tomo",0,[(dm,20)])
adaga = ("Adaga",0,[(as,10)])
rubi = ("Rubi",0,[(hp,150)])
couraca = ("Couraca",0,[(ar,15)])
manto = ("Manto",0,[(mr,20)])
frasco = ("Frasco",0,[(cr,5)])
botas = ("Botas",0,[(ms,25)])

--loja
loja = [machado_De_Guerra,
        cajado_Do_Arcanjo,
        peitoral_Adamantino,
        botas_Serpentinas,
        quebra_Cascos,
        espada,
        tomo,
        adaga,
        rubi,
        couraca,
        manto,
        botas]

--Funcoes auxiliares
custoBuff :: Buff -> Float
custoBuff ((_,custoB),quant) = custoB*quant
custoTotalBuffs :: [Buff] -> Float
custoTotalBuffs l = foldr (\x acc -> acc+custoBuff x) 0 l
totalBuffs :: [Buff] -> Float
totalBuffs l = foldr (\(_,quant) acc -> acc+quant) 0 l
temBuff :: BuffType -> [Buff] -> Bool
temBuff buff l = foldr (\(buffType,_) acc -> acc || (buffType==buff)) False l

--1.Map
--1.1 Retornar uma lista com custo total de cada item (custo de construcao + custo dos buffs)
custoTotalItem :: Item -> (String,Float)
custoTotalItem (nome,custoC,buffs) = (nome,custoC+custoTotalBuffs buffs)
precosNominais :: [Item] -> [(String,Float)]
precosNominais l = map custoTotalItem l

--1.2 Retornar uma lista com o nome de cada item e o preco medio unitario de buff (comparacao de eficiencia de custo)
custoParcial :: [Item] -> [(String,Float,Float)]
custoParcial l = map (\(nome,custoC,buffs) -> (nome,custoC+custoTotalBuffs buffs,totalBuffs buffs)) l
custoMedioUnitario :: [Item] -> [(String,Float)]
custoMedioUnitario l = map (\(nome,custoTotal,quant) -> (nome,(custoTotal/quant))) (custoParcial l)

--2.Filter
--2.1 Retornar uma lista com itens com preco total menor que um valor dado (itens que o jogador pode comprar)
itensAcessiveis :: Float -> [Item] -> [Item]
itensAcessiveis limite l = filter (\(nome,custoC,buffs) -> custoC+custoTotalBuffs buffs < limite) l
--2.2 Retornar uma lista com itens que possuem um buff especifico
itensComBuff :: BuffType -> [Item] -> [Item]
itensComBuff buff l = filter (\(nome,custoC,buffs) -> temBuff buff buffs) l

--3.Fold
--3.1 Retornar o item recomendado para compra, dado um buff especifico (item mais barato que possui o buff)
itemRecomendado :: BuffType -> [Item] -> Item
itemRecomendado buff l = foldr (\(nome,custoC,buffs) (nomeRec,custoRec,buffsRec) -> 
        if custoC+custoTotalBuffs buffs < custoRec+custoTotalBuffs buffsRec 
        then (nome,custoC,buffs) 
        else (nomeRec,custoRec,buffsRec)) ("ItemHorrivel",9999,[(buff,0)]) (itensComBuff buff l)
--3.2 Retornar o custo total de todos os itens da loja (custo de construcao + custo dos buffs)
custoTotalLoja :: [Item] -> Float
custoTotalLoja l = foldr (\(nome,custoC,buffs) acc -> acc+custoC+custoTotalBuffs buffs) 0 l