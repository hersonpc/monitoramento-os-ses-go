WITH
    PERIODO_MIN AS (
        -- Especificar o ponto de corte dos dados...
        
        --SELECT TRUNC(SYSDATE) AS DATA_MIN FROM DUAL
        SELECT '%DATA%' AS DATA_MIN FROM DUAL
    ), 
    ATENDIMENTOS_ELEGIVEIS AS (
        -- Determinar quais são os atendimentos que os dados de movimentação são necessários selecionar...
        
        SELECT DISTINCT ATENDIME.CD_ATENDIMENTO FROM ATENDIME
        WHERE 
            -- Atendimentos dos ultimos 3 dias que ocuparam algum leito
            (( TRUNC(ATENDIME.DT_ATENDIMENTO) >= (SELECT DATA_MIN FROM PERIODO_MIN)) AND (ATENDIME.CD_LEITO IS NOT NULL))
            -- Ou qualquer outro atendimento anterior em andamento, que tiveram movimentações nos ultimos 3 dias
            OR ATENDIME.CD_ATENDIMENTO IN (
                                                SELECT 
                                                    MOV_INT.CD_ATENDIMENTO
                                                FROM MOV_INT
                                                WHERE 
                                                    TRUNC(MOV_INT.DT_MOV_INT) >= (SELECT DATA_MIN FROM PERIODO_MIN)
                                            )    
    ),
    MOVIMENTACOES AS (
        -- Buscar os dados de movimentações dos atendimentos elegíveis...
        
        SELECT 
            MULTI_EMPRESAS.CD_CGC AS CNPJ_OSS
            , MULTI_EMPRESAS.DS_RAZAO_SOCIAL AS RAZAO_SOCIAL_OSS
            , 'ISG' AS NOME_FANTASIA
            , MULTI_EMPRESAS.NR_CNES AS CNES
            , 'HOSPITAL ESTADUAL DE DOENÇAS TROPICAIS DR. ANUAR AUAD' AS RAZAO_SOCIAL_UNIDADE
            , 'HDT' AS NOME_FANTASIA_UNIDADE
            , ATENDIME.CD_ATENDIMENTO
            --, ATENDIME.TP_ATENDIMENTO
            --, ATENDIME.DT_ATENDIMENTO
            , TRUNC(MOV_INT.DT_MOV_INT) DT_MOV
            , TO_CHAR(MOV_INT.DT_MOV_INT, 'YYYY-MM-DD') DT_ENTRADA
            , TO_CHAR(MOV_INT.HR_MOV_INT, 'HH24:MI:SS') HR_ENTRADA
            , TO_CHAR(MOV_INT.DT_LIB_MOV, 'YYYY-MM-DD') DT_SAIDA
            , TO_CHAR(MOV_INT.HR_LIB_MOV, 'HH24:MI:SS') HR_SAIDA
            , UNID_INT.CD_UNID_INT CD_LOCAL
            , UNID_INT.DS_UNID_INT DS_LOCAL
            , LEITO.CD_LEITO
            , LEITO.DS_RESUMO DS_LEITO
            , DECODE(unid_int.cd_unid_int, 
                23, 5,  -- ALA A - PEDIATRIA -> PEDIÁTRICO
                2       -- QUALQUER OUTRO -> CLÍNICO
                ) AS TP_LEITO
            , 0 AS IS_MACA
            , DECODE(LEITO.SN_EXTRA, 'S', 1, 0) AS IS_EXTRA
        FROM ATENDIME
        INNER JOIN MULTI_EMPRESAS ON MULTI_EMPRESAS.CD_MULTI_EMPRESA = 1
        LEFT JOIN MOV_INT ON MOV_INT.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
        LEFT JOIN LEITO ON LEITO.CD_LEITO = MOV_INT.CD_LEITO
        LEFT JOIN UNID_INT ON UNID_INT.CD_UNID_INT = LEITO.CD_UNID_INT
        WHERE 
            MOV_INT.CD_ATENDIMENTO IN (SELECT ATENDIMENTOS_ELEGIVEIS.CD_ATENDIMENTO FROM ATENDIMENTOS_ELEGIVEIS)
        ORDER BY 
            ATENDIME.CD_ATENDIMENTO, MOV_INT.CD_MOV_INT
    )
    SELECT * FROM MOVIMENTACOES