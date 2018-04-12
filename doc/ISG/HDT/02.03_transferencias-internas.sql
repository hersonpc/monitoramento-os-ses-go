/***
**
** PROJETO MONITORAMENTO OS SES/GO 
** -------------------------------
**
** PARCERIA DE INTEGRAÇÃO DAS OS QUE USAM MV EM GOIÁS
**
** DATA: 11/04/2018
** CONTRIBUIDORES:
**   - FELIPE - AGIR / CRER (felipe@agirgo.org.br)
**   - HERSON MELO - ISG / HDT (hersonpc@gmail.com)
***/

select 
    mult.CD_CGC AS "CNPJ OSS"
    , mult.ds_razao_social AS "Razao social OSS"
    , 'ISG' AS "Nome fantasia"
    , mult.NR_CNES AS "CNES"
    , 'HOSPITAL ESTADUAL DE DOENÇAS TROPICAIS DR. ANUAR AUAD' AS "Razao social da unidade"
    , 'HDT' AS "Nome fantasia da unidade"
    , atendime.cd_atendimento AS "Codigo da Internacao"
    , trunc(mov_int.dt_mov_int) as dt_entrada
    , to_char(mov_int.hr_mov_int, 'HH24:MI:SS') as hr_entrada
    , case when (
        select 
            min(trunc(mov.dt_mov_int))
        from mov_int mov, leito let, atendime ate
        where 
                mov.cd_atendimento = ate.cd_atendimento
            and let.cd_leito = mov.cd_leito
            and mov.cd_atendimento = atendime.cd_atendimento
            and mov.cd_leito_anterior = mov_int.cd_leito
            and mov.dt_mov_int >= mov_int.dt_mov_int
        ) is not null then (
            select min(trunc(mov.dt_mov_int))
            from mov_int mov, leito let, atendime ate
            where mov.cd_atendimento = ate.cd_atendimento
            and let.cd_leito = mov.cd_leito
            and mov.cd_atendimento = atendime.cd_atendimento
            and mov.cd_leito_anterior = mov_int.cd_leito
            and mov.dt_mov_int >=  mov_int.dt_mov_int
        ) else trunc(atendime.dt_alta) end as dt_saida
    , case when (
        select 
            min(to_char(mov.hr_mov_int, 'HH24:MI:SS'))
        from mov_int mov, leito let, atendime ate
        where 
                mov.cd_atendimento = ate.cd_atendimento
            and let.cd_leito = mov.cd_leito
            and mov.cd_atendimento = atendime.cd_atendimento
            and mov.cd_leito_anterior = mov_int.cd_leito
            and mov.dt_mov_int >=  mov_int.dt_mov_int
        ) is not null then ( 
            select 
                min(to_char(mov.hr_mov_int, 'HH24:MI:SS'))
            from mov_int mov, leito let, atendime ate
            where 
                    mov.cd_atendimento = ate.cd_atendimento
                and let.cd_leito = mov.cd_leito
                and mov.cd_atendimento = atendime.cd_atendimento
                and mov.cd_leito_anterior = mov_int.cd_leito
                and mov.dt_mov_int >=  mov_int.dt_mov_int
        ) else to_char(atendime.hr_alta, 'HH24:MI:SS') end as hr_saida
    , unid_int.cd_unid_int AS "Cod local internacao"
    , unid_int.ds_unid_int AS "Descricao local internacao"
    , leito.cd_leito AS "Cod interno leito"
    , leito.ds_leito AS "Descricao do leito"
    , decode(unid_int.cd_unid_int, 
        23, 5, -- ALA A - PEDIATRIA -> Pediátrico
        2 -- Qualquer outro -> clínico
    ) AS "Tipo de leito"
    , 0 AS "Maca"
    , DECODE(leito.sn_extra, 'S', 1, 0) AS "Leito extra"
from mov_int, leito, atendime,  dbamv.multi_empresas mult, unid_int, procedimento_sus
where 
        mov_int.cd_atendimento = atendime.cd_atendimento
    and leito.cd_leito = mov_int.cd_leito
    and unid_int.cd_unid_int = leito.cd_unid_int
    AND atendime.cd_procedimento = procedimento_sus.cd_procedimento(+)
    and atendime.tp_atendimento = 'I'
    /*19 SALA DE OBSERVACAO
    20 SALA DE URGENCIA E EMERGENCIA
    26 LEITO DE MOVIMENTAÇÃO*/
    and mov_int.cd_tip_acom not in(19, 20, 26)
    AND atendime.dt_atendimento > ADD_MONTHS(sysdate, -36)
order by  mov_int.cd_mov_int