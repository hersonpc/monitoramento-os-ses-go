CREATE OR REPLACE FORCE VIEW "DBAMV"."V_SESMOS_CONSULTAS" AS 
SELECT 
    mult.CD_CGC AS "NR_CNPJ_OS"
    , mult.ds_razao_social AS "DS_RAZAO_SOCIAL_OS"
    , 'ISG' AS "NM_FANTASIA_OS"
    , mult.nr_cnes AS "NR_CNES"
    , 'HOSPITAL ESTADUAL DE DOENÇAS TROPICAIS DR. ANUAR AUAD' AS "DS_RAZAO_SOCIAL_UNIDADE"
    , 'HDT' AS "NM_FANTASIA_UNIDADE"
    , paciente.cd_paciente AS "CD_PACIENTE"
    , paciente.nr_cns AS "NR_CNS"
    , F_INICIAIS_NOME(paciente.NM_PACIENTE) AS INICIAIS_NM_PACIENTE
    , F_INICIAIS_NOME(paciente.NM_MAE) AS INICIAIS_NM_MAE
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
    , atendime.cd_atendimento AS "CD_CONSULTA"
    , TO_CHAR(atendime.dt_atendimento, 'YYYY-MM-DD') || ' ' || TO_CHAR(atendime.hr_atendimento, 'HH24:MI:SS') AS "DT_CONSULTA"
    , procedimento_sus.cd_procedimento AS "CD_SIGTAP"
    , especialid.DS_ESPECIALID AS "DS_ESPECIALIDADE"
    , case when especialid.cd_especialid in (1,2,3,55,57,60,62,66,67,64,68,69,70,75,77,78,79,85,86,92,93,76,90,91,97,0,80) then 2 -- consulta não médica
        else 1 -- consulta médica
      end AS TP_CONSULTA

    , atendime.cd_cid AS "CD_CID_PRINCIPAL"
    , NULL AS "CD_CID_SECUNDARIO"
    
    , case when atendime.CD_ORI_ATE = 3 then 1
        else 0 
      end AS "TERCEIRO_TURNO"
    , tipo_agendamento.ds_tip_mar AS "RETORNO"
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
    , (
                SELECT
                    it_marcacao.cd_it_marcacao
                    , it_marcacao.cd_marcacao
                    , it_marcacao.cd_atendimento
                    , it_marcacao.dt_agendado
                    , it_marcacao.hr_agendado
                    , tip_mar.cd_tip_mar
                    , tip_mar.ds_tip_mar
                FROM it_marcacao
                inner join tip_mar on tip_mar.cd_tip_mar = it_marcacao.cd_tip_mar
    ) tipo_agendamento
WHERE 
        leito.cd_unid_int = unid_int.cd_unid_int
    AND atendime.cd_leito = leito.cd_leito
    AND atendime.cd_paciente = paciente.cd_paciente
    AND paciente.cd_cidade = cidade.cd_cidade
    AND atendime.cd_procedimento = procedimento_sus.cd_procedimento(+)
    AND tipo_internacao.Cd_Tipo_Internacao = atendime.cd_tipo_internacao
    AND especialid.cd_especialid = atendime.cd_especialid
    AND mot_alt.Cd_Mot_Alt(+) = atendime.cd_mot_alt
    AND tipo_agendamento.cd_atendimento(+) = atendime.cd_atendimento
    AND leito.tp_situacao = 'A'
    --Padronizar atendimentos que podem entrar na consulta, para evitar divergências no processo de homologação
    /*and (
            atendime.cd_atendimento in (
                select 
                    distinct(cd_atendimento)
                    --, TO_CHAR((sysdate - interval '72' hour), 'DD/MM/YYYY HH24:MI:SS') corte
                    --, TO_CHAR(a.dt_atendimento, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.hr_atendimento, 'HH24:MI') DT
                from atendime a 
                where 
                    -- Atendimentos que tiveram movimentações recentes
                    a.CD_ATENDIMENTO in (SELECT DISTINCT CD_ATENDIMENTO FROM VDIC_SESMOS_TRANSF_INTERNA)
                    -- Atendimentos criados recentemente
                    OR (
                        a.tp_atendimento = 'A' 
                        and TO_DATE(TO_CHAR(a.dt_atendimento, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.hr_atendimento, 'HH24:MI'), 'DD/MM/YYYY HH24:MI:SS') >= (sysdate - interval '72' hour)
                    )
                --ORDER BY DT
            )
            --OR atendime.cd_atendimento in (SELECT DISTINCT CD_ATENDIMENTO FROM VDIC_SESMOS_TRANSF_INTERNA)
        )*/
ORDER BY atendime.cd_atendimento;
 
