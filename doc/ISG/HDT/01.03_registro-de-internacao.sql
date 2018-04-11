/***
**
** PROJETO MONITORAMENTO OS SES/GO 
** -------------------------------
**
** PARCERIA DE INTEGRA��O DAS OS QUE USAM MV EM GOI�S
**
** DATA: 28/03/2018
** CONTRIBUIDORES:
**   - FELIPE - AGIR / CRER (felipe@agirgo.org.br)
**   - HERSON MELO - ISG / HDT (hersonpc@gmail.com)
***/

SELECT 
    mult.CD_CGC AS "CNPJ OSS"
    , mult.ds_razao_social AS "Razao social OSS"
    , 'ISG' AS "Nome fantasia"
    , mult.nr_cnes AS "CNES"
    , 'HOSPITAL ESTADUAL DE DOEN�AS TROPICAIS DR. ANUAR AUAD' AS "Razao social da unidade"
    , 'HDT' AS "Nome fantasia da unidade"
    , atendime.cd_atendimento AS "Codigo da internacao"
    , paciente.cd_paciente AS "C�digo da ficha do paciente"
    , paciente.nr_cns AS "CNS paciente"
    , TO_CHAR(paciente.dt_nascimento, 'YYYY-MM-DD') AS "Data de nascimento"
    , DECODE(paciente.tp_sexo, 'M', 1, 'F', 2, 0) AS "Sexo"
    
    -- C CASADO, S SOLTEIRO, D DESQUITADO, G IGNORADO, I DIVORCIADO, U UNIAO ESTAVEL, V VIUVO
    , DECODE(paciente.tp_estado_civil, 
        'G', 0, 'S', 1, 'C', 2, 'U', 2,
        'I', 3, 'V', 4, 'D', 5, 
        0) AS "Estado civil"
        
    , cidade.cd_ibge AS "Municipio residencia"
    , cidade.cd_uf AS "UF"
    , TO_CHAR(paciente.dt_cadastro, 'YYYY-MM-DD') || ' ' || TO_CHAR(coalesce(paciente.hr_cadastro, TO_DATE('00:00:00', 'HH24:MI:SS')), 'HH24:MI:SS') AS "Data de cadastro"
    , atendime.cd_cid AS "Cid 10 entrada"
    , case when atendime.dt_alta is null then ''
        when atendime.cd_cid_obito is not null then atendime.cd_cid_obito
        else atendime.cd_cid 
      end AS "Cid 10 saida"
    , procedimento_sus.cd_procedimento AS "SIGTAP"
    
    , DECODE(unid_int.cd_unid_int, 
        23, 3, -- ALA A - PEDIATRIA -> 3 - Cl�nica Pedi�trica
        2 -- Qualquer outro -> 1 - Cl�nica M�dica
        ) AS "Classificacao da especialidade"
    
    , cd_grupo_procedimento AS "Grupo procedimento"
    , unid_int.ds_unid_int AS "Classificacao interno"
    , TO_CHAR(atendime.dt_atendimento, 'YYYY-MM-DD') AS "Data entrada internacao"
    , TO_CHAR(atendime.hr_atendimento, 'HH24:MM:SS') AS "Hora entrada internacao"
    , TO_CHAR(atendime.dt_alta, 'YYYY-MM-DD') AS "Data saida internacao"
    , TO_CHAR(atendime.hr_alta, 'HH24:MM:SS') AS "Hora saida internacao"
    
    --O Obito
    --T Transferencia
    --A, D altas
    , case
        when atendime.dt_alta is null then null 
        else
            decode(mot_alt.tp_mot_alta, 'O', 1, 'T', 3, 'A', 2, 'D', 2) 
        END AS "Motivo de saida"
    
    , unid_int.cd_unid_int AS "Cod local internacao"
    , unid_int.ds_unid_int AS "Descricao local internacao"
    , leito.cd_leito AS "Cod interno leito"
    , leito.ds_leito AS "Descricao do leito"
    
    , DECODE(unid_int.cd_unid_int, 
        23, 5, -- ALA A - PEDIATRIA -> Pedi�trico
        2 -- Qualquer outro -> cl�nico
        ) AS "Tipo de leito"

    , 0 AS "Maca"
    , DECODE(leito.sn_extra, 'S', 1, 0) AS "Leito extra"
FROM 
    dbamv.multi_empresas mult
    , leito
    , unid_int
    , atendime
    , paciente
    , cidade
    , procedimento_sus
    , tipo_internacao
    , mot_alt
    , especialid
WHERE 
        leito.cd_unid_int = unid_int.cd_unid_int
    AND atendime.cd_leito = leito.cd_leito
    AND atendime.cd_paciente = paciente.cd_paciente
    AND paciente.cd_cidade = cidade.cd_cidade
    AND atendime.cd_procedimento = procedimento_sus.cd_procedimento(+)
    AND tipo_internacao.Cd_Tipo_Internacao = atendime.cd_tipo_internacao
    AND especialid.cd_especialid = atendime.cd_especialid
    AND mot_alt.Cd_Mot_Alt(+) = atendime.cd_mot_alt
    AND atendime.tp_atendimento = 'I'
    AND leito.tp_situacao = 'A'
    --AND unid_int.cd_unid_int not in (5, 7, 8) 
    --AND cd_convenio = 3
    AND atendime.dt_atendimento > ADD_MONTHS(sysdate, -36)
ORDER BY atendime.cd_atendimento

;/

select * from procedimento_sus where --cd_grupo_procedimento = '04'
cd_procedimento = '0303130040'

;/
select * from ESPECIALID
;/

select * from PROCEDIMENTO_SUS_ESPEC_LEITO where cd_procedimento = '0303010053'
;/

select * from ESPEC_SUS

;/

select cd_atendimento atend, cd_procedimento proc, atendime.* from atendime order by atendime.cd_atendimento desc