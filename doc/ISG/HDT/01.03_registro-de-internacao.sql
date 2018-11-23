/***
**
** PROJETO MONITORAMENTO OS SES/GO 
** -------------------------------
**
** PARCERIA DE INTEGRAÇÃO DAS OS QUE USAM MV EM GOIÁS
**
** DATA: 28/03/2018
** CONTRIBUIDORES:
**   - FELIPE - AGIR / CRER (felipe@agirgo.org.br)
**   - HERSON MELO - ISG / HDT (hersonpc@gmail.com)
***/

CREATE OR REPLACE VIEW V_SESMOS_INTERNACAO AS
SELECT 
    mult.CD_CGC AS "NR_CNPJ_OS"
    , mult.ds_razao_social AS "DS_RAZAO_SOCIAL_OS"
    , 'ISG' AS "NM_FANTASIA_OS"
    , mult.nr_cnes AS "NR_CNES"
    , 'HOSPITAL ESTADUAL DE DOENÇAS TROPICAIS DR. ANUAR AUAD' AS "DS_RAZAO_SOCIAL_UNIDADE"
    , 'HDT' AS "NM_FANTASIA_UNIDADE"
    , atendime.cd_atendimento AS "CD_ATENDIMENTO"
    , paciente.cd_paciente AS "CD_PACIENTE"
    , paciente.nr_cns AS "NR_CNS"
    , TO_CHAR(paciente.dt_nascimento, 'YYYY-MM-DD') AS "DT_NASCIMENTO"
    , DECODE(paciente.tp_sexo, 'M', 1, 'F', 2, 0) AS "TP_SEXO"
    
    -- C CASADO, S SOLTEIRO, D DESQUITADO, G IGNORADO, I DIVORCIADO, U UNIAO ESTAVEL, V VIUVO
    , DECODE(paciente.tp_estado_civil, 
        'G', 0, 'S', 1, 'C', 2, 'U', 2,
        'I', 3, 'V', 4, 'D', 5, 
        0) AS "TP_ESTADO_CIVIL"
        
    , cidade.cd_ibge AS "CD_IBGE"
    , cidade.cd_uf AS "CD_UF"
    , paciente.dt_cadastro AS "DT_FILTRO"
    , TO_CHAR(paciente.dt_cadastro, 'YYYY-MM-DD') || ' ' || TO_CHAR(coalesce(paciente.hr_cadastro, TO_DATE('00:00:00', 'HH24:MI:SS')), 'HH24:MI:SS') AS "DT_CADASTRO"
    , atendime.cd_cid AS "CD_CID_ENTRADA"
    , case when atendime.dt_alta is null then ''
        when atendime.cd_cid_obito is not null then atendime.cd_cid_obito
        else atendime.cd_cid 
      end AS "CD_CID_SAIDA"
    , procedimento_sus.cd_procedimento AS "CD_SIGTAP"
    
    , DECODE(unid_int.cd_unid_int, 
        23, 3, -- ALA A - PEDIATRIA -> 3 - Clínica Pediátrica
        1 -- Qualquer outro -> 1 - Clínica Médica
        ) AS "CD_ESPECIALIDADE"
    
    , cd_grupo_procedimento AS "CD_GRUPO_PROCEDIMENTO"
    , unid_int.ds_unid_int AS "CD_CLASSIFICACAO_INTERNO"
    , TO_CHAR(atendime.dt_atendimento, 'YYYY-MM-DD') AS "DT_ENTRADA_INTERNACAO"
    , TO_CHAR(atendime.hr_atendimento, 'HH24:MI:SS') AS "HR_ENTRADA_INTERNACAO"
    , TO_CHAR(atendime.dt_alta, 'YYYY-MM-DD') AS "DT_SAIDA_INTERNACAO"
    , TO_CHAR(atendime.hr_alta, 'HH24:MI:SS') AS "HR_SAIDA_INTERNACAO"
    
    --O Obito
    --T Transferencia
    --A, D altas
    , case
        when atendime.dt_alta is null then null 
        else
            decode(mot_alt.tp_mot_alta, 'O', 1, 'T', 3, 'A', 2, 'D', 2) 
        END AS "CD_SAIDA"
    
    , unid_int.cd_unid_int AS "CD_LOCAL_INTERNACAO"
    , unid_int.ds_unid_int AS "DS_LOCAL_INTERNACAO"
    , leito.cd_leito AS "CD_LEITO_INTERNACAO"
    , leito.ds_leito AS "DS_LEITO_INTERNACAO"
    
    , DECODE(unid_int.cd_unid_int, 
        23, 5, -- ALA A - PEDIATRIA -> Pediátrico
        2 -- Qualquer outro -> clínico
        ) AS "TP_LEITO"

    , 0 AS "MACA"
    , DECODE(leito.sn_extra, 'S', 1, 0) AS "EXTRA"
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
    AND leito.tp_situacao = 'A'
    --Padronizar atendimentos que podem entrar na consulta, para evitar divergências no processo de homologação
    and atendime.cd_atendimento in (select distinct(cd_atendimento) from atendime a where a.tp_atendimento = 'I' and a.dt_atendimento > ADD_MONTHS(sysdate, -36))
ORDER BY atendime.cd_atendimento;