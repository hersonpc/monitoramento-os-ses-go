select atendime.cd_atendimento AS "Codigo da Internacao",
       trunc(mov_int.dt_mov_int) as dt_entrada,
       to_char(mov_int.hr_mov_int, 'HH24:MI:SS') as hr_entrada,
       
   case when ( 
    select min(trunc(mov.dt_mov_int))
    from mov_int mov, leito let, atendime ate
    where mov.cd_atendimento = ate.cd_atendimento
    and let.cd_leito = mov.cd_leito
    and mov.cd_atendimento = atendime.cd_atendimento
    and mov.cd_leito_anterior = mov_int.cd_leito
    and mov.dt_mov_int >=  mov_int.dt_mov_int
   ) is not null then ( 
    select min(trunc(mov.dt_mov_int))
    from mov_int mov, leito let, atendime ate
    where mov.cd_atendimento = ate.cd_atendimento
    and let.cd_leito = mov.cd_leito
    and mov.cd_atendimento = atendime.cd_atendimento
    and mov.cd_leito_anterior = mov_int.cd_leito
    and mov.dt_mov_int >=  mov_int.dt_mov_int
   ) else trunc(atendime.dt_alta) end as dt_saida,
   
   case when ( 
    select min(to_char(mov.hr_mov_int, 'HH24:MI:SS'))
    from mov_int mov, leito let, atendime ate
    where mov.cd_atendimento = ate.cd_atendimento
    and let.cd_leito = mov.cd_leito
    and mov.cd_atendimento = atendime.cd_atendimento
    and mov.cd_leito_anterior = mov_int.cd_leito
    and mov.dt_mov_int >=  mov_int.dt_mov_int
   ) is not null then ( 
    select min(to_char(mov.hr_mov_int, 'HH24:MI:SS'))
    from mov_int mov, leito let, atendime ate
    where mov.cd_atendimento = ate.cd_atendimento
    and let.cd_leito = mov.cd_leito
    and mov.cd_atendimento = atendime.cd_atendimento
    and mov.cd_leito_anterior = mov_int.cd_leito
    and mov.dt_mov_int >=  mov_int.dt_mov_int
   ) else to_char(atendime.hr_alta, 'HH24:MI:SS') end as hr_saida,
   unid_int.cd_unid_int    AS "Cod local internacao",
       unid_int.ds_unid_int    AS "Descricao local internacao",
       leito.cd_leito          AS "Cod interno leito",
       leito.ds_leito          AS "Descricao do leito",
       
  /*     
8  CLINICA TRAUMAT/ORTOPEDIA
9  CLINICA MEDICA
10  CLINICA PEDIATRICA
11  CLINICA ESPECIALIDADES
12  UNID TER INTENSIVA ADULTO C
13  UNID TER INTENSIVA ADULTO F
14  UNID TER INTENSIVA PEDIATRICA
15  UNID CUIDADO ESP. DE QUEIM UTI
16  CLINICA ESP. DE QUEIM ENF
17  CLINICA CIRURGICA
18  LEITOS EXTRAS DE MOVIMENTAÇÃO
19  UNID TER INTENSIVA ADULTO E
20  LEITOS EXTRAS DE MOVIMENTAÇÃO
21  EXTRA-CLÍNICA ORTO URGEN/EMERG
22  EXTRA-CLÍNICA MÉDICA
23  EXTRA-CLÍNICA MÉDICA URG/EMERG
24  EXTRA-CENTRO CIRÚRGICO
25  EXTRA-CLÍNICA ORTO CENTRO CIRU
26  EXTRA-CLÍNICA CIR CENTRO CIRUR
27  EXTRA-CLÍNICA PEDIÁTRICA
28  EXTRA-UTI ADULTO CENTRO CIRURG
29  EXTRA-UTI PED CENTRO CIRÚRGICO
30  OBSERV URG/EMERG
31  EXTRA-CLÍN PED URGEN/EMERGEN
32  CLÍNICA DE ESPECIALIDADES
33  UNID TER INTENSIVA ADULTO A
34  UNID TER INTENSIVA ADULTO B*/
    case when unid_int.ds_unid_int = 'URGENCIA E EMERGENCIA' then decode(procedimento_sus.cd_grupo_procedimento, '04', 2, 1) 
    else
       DECODE(unid_int.cd_unid_int, 8, 1,
                                    9, 2,
                                    10, 5,
                                    11, 6,
                                    12, 3,
                                    13, 3,
                                    14, 3,
                                    15, 3,
                                    16, 2,
                                    17, 1, 
                                    18, 3,
                                    19, 3,
                                    20, 3,
                                    21, 1,
                                    22, 2,
                                    23, 2, 
                                    24, 1,
                                    25, 1,
                                    26, 1,
                                    27, 5,
                                    28, 3,
                                    29, 3,
                                    30, 3,
                                    31, 5,
                                    32, 6,
                                    33, 3,
                                    34, 3
                                    ) end  AS "Classificacao tipo Leito",
       
       0                       AS "Maca",
       DECODE(leito.sn_extra, 'S', 1, '0') AS "Leito extra"
from mov_int, leito, atendime,  dbamv.multi_empresas mult, unid_int, procedimento_sus
where mov_int.cd_atendimento = atendime.cd_atendimento
and leito.cd_leito = mov_int.cd_leito
and unid_int.cd_unid_int = leito.cd_unid_int
AND atendime.cd_procedimento = procedimento_sus.cd_procedimento(+)
and atendime.tp_atendimento = 'I'
/*19 SALA DE OBSERVACAO
20 SALA DE URGENCIA E EMERGENCIA
26 LEITO DE MOVIMENTAÇÃO*/
and mov_int.cd_tip_acom not in(19, 20, 26)
order by  mov_int.cd_mov_int
