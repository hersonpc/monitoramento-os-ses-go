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

SELECT 
       mult.CD_CGC AS "CNPJ OSS"
       , mult.ds_razao_social AS "Razao Social OSS"
       , 'ISG' AS "Nome Fantasia"
       , mult.nr_cnes AS "CNES"
       , mult.ds_multi_empresa AS "Razao Social da Unidade"
       , 'HDT' AS "Nome fantasia da Unidade"
       , atendime.cd_atendimento AS "Codigo da Internacao"
       , paciente.cd_paciente AS "Código da ficha do paciente"
       , paciente.nr_cns AS "CNS Paciente"
       , TO_CHAR(paciente.dt_nascimento, 'YYYY-MM-DD') AS "Data de nascimento"
       , DECODE(paciente.tp_sexo, 'M', 1, 'F', 2, '0') AS "Sexo"
       -- C CASADO, S SOLTEIRO, D DESQUITADO, G IGNORADO, I DIVORCIADO, U UNIAO ESTAVEL, V VIUVO
       , DECODE(paciente.tp_estado_civil, 'C', 2, 'S', 1, 'D', 5,
                                        'G', 0, 'I', 3, 'U', 2,
                                        'V', 4) AS "Estado Civil Int"
       , cidade.cd_ibge AS "Municipio residencia"
       , cidade.cd_uf AS "Estado UF"
       , TO_CHAR(paciente.dt_cadastro, 'YYYY-MM-DD')|| ' '||TO_CHAR(paciente.hr_cadastro, 'HH24:MI:SS') AS "Data de cadastro"
       , atendime.cd_cid AS "Cid 10 Principal Entrada"
       , case when atendime.dt_alta is null then ''
            when atendime.cd_cid_obito is not null then atendime.cd_cid_obito 
            else atendime.cd_cid end AS "Cid10 Codigo saida"
       , procedimento_sus.cd_procedimento AS "Código SIGTAP"          
       
       --04 CLINICA CIRURGICA
       --03 Clínica Medica
       , decode(procedimento_sus.cd_grupo_procedimento, '04', 2, 1)    AS "Classificacao da especialidade",cd_grupo_procedimento
    
       , unid_int.ds_unid_int                   AS "Classificacao Interno"
        
       , TO_CHAR(atendime.dt_atendimento, 'YYYY-MM-DD')  AS "Data entrada internacao"
       , TO_CHAR(atendime.hr_atendimento, 'HH24:MM:SS')  AS "Hora entrada internacao"
       , TO_CHAR(atendime.dt_alta, 'YYYY-MM-DD')  AS "Data saida internacao"
       , TO_CHAR(atendime.hr_alta, 'HH24:MM:SS')  AS "Hora saida internacao"
       
       --O Obito
       --T Transferencia
       --A, D altas
       , CASE 
            WHEN atendime.dt_alta is null then null 
            else
                decode(mot_alt.tp_mot_alta, 'O', 1, 'T', 3, 'A', 2, 'D', 2) 
            END AS "Motivo de saida"
       
       , unid_int.cd_unid_int    AS "Cod local internacao"
       , unid_int.ds_unid_int    AS "Descricao local internacao"
       , leito.cd_leito          AS "Cod interno leito"
       , leito.ds_leito          AS "Descricao do leito"
       
       -- 1 POSTO 1 - REABILIT. - CLINICO, 
       -- 3 UTI, 
       -- 2 POSTO 2 - CIRURGICOS, 
       -- 4 POSTO 3 - REABILITAÇÃO, 
       -- 6 RPA(CIRURGICO),
       -- 7 LEITO 23(UTI)
       -- 8 LEITO 22(UTI)
  , DECODE(unid_int.cd_unid_int, 1, 2, 
                                    3, 3, 
                                    2, 1, 
                                    4, 6, 
                                    6, 1,
                                    7, 3,
                                    8, 3,
                                    6)   AS "Classificacao tipo Leito"
    , 0                                 AS "Maca"
    , DECODE(leito.sn_extra, 'S', 1, '0') AS "Leito extra"
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
    AND atendime.dt_atendimento > ADD_MONTHS(sysdate,-36)
ORDER BY atendime.cd_atendimento DESC