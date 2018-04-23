# Layout de Integração v1.6

23 de Abril de 2018

[Download PDF](/../../raw/master/layouts/v1.6/layout-internacao-v1.6.pdf)

## Indice

  * [1 - Registro de internação](#1---registro-de-internação)
  * [2 - Transferências internas](#2---transferências-internas)
  * [3 - Status do Leito (Mapa de leitos)](#3---status-do-leito-mapa-de-leitos)

  
## 1 - Registro de internação

#### 1.1 Objetivo

Obter os registros referentes as internações. Os respectivos dados extraídos serão utilizados para o acompanhamento da produção
assistencial e o desenvolvimento dos indicadores de qualidade.

#### 1.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| CNPJ OSS | String | 15 | Sim | CNPJ da Organização Social de Saúde. |
| Razão Social da Organização Social de Saúde | String | 100 | Sim | Razão social da Organização Social de Saúde. |
| Nome Fantasia da Organização Social de Saúde | String | 100 | Sim | Nome fantasia da Organização Social de Saúde. |
| Código da Unidade de Saúde | Inteiro | - | Sim | Código de identificação da unidade de saúde (CNES). |
| Razão Social da Unidade de Saúde | String | 100 | Sim | Descrever a razão social da unidade de saúde. |
| Nome fantasia da Unidade de Saúde | String | 100 | Sim | Descrever o nome fantasia da unidade de saúde. |
| Código da internação | Inteiro | - | Sim | Código único que identifica uma ocorrência de internação do paciente na unidade de saúde. |
| Código da ficha do paciente | Inteiro | - | Sim | Código de identificação da ficha do paciente na Unidade de saúde. |
| CNS Paciente | String | 15 | Sim | Cartão Nacional de Saúde do Paciente |
| Data de nascimento | Date | - | Sim | Data de nascimento do paciente. Formato (YYYY-MM-DD) |
| Sexo | Inteiro | - | Sim | Sexo do paciente. 1 – Masculino 2 – Feminino 0 – Não informado |
| Estado Civil | Inteiro | - | Sim | Estado Civil. 0 – Não informado  1 – Solteiro (a)  2 – Casado (a)  3 – Divorciado(a)  4 – Viúvo(a)  5 – Separado(a) |
| Município residência | Inteiro | - | Não | Código IBGE do município de residência do paciente. |
| Estado (UF) | String | 2 | Não | UF do estado de residência do paciente. |
| Data de cadastro | Datetime | - | Sim | Data de cadastro do paciente. (YYYY-MM-DD HH:MM:SS) |
| Cid10 Principal Entrada | String | 10 | Sim | Código da Cid 10 da internação. (Principal) |
| Cid10 Código saída | String | 10 | Não | Código da Cid 10 do paciente/internação. (Saída) Incluindo o Cid do Óbito, caso a saída tenha sido causada pelo falecimento do paciente. Caso não tenha o Cid de saída, deverá ser o mesmo do Cid de entrada. |
| Código SIGTAP | String | 10 | Sim | Código de identificação do procedimento de saúde vinculado a internação. |
| Classificação da especialidade de Internação | Inteiro | - | Sim | Código da Especialidade de internação Conforme Contrato: 1 – Clínica Médica 2 – Clínica Cirúrgica 3 – Clínica Pediátrica 4 – Clínica Obstétrica 5 – Casa de Apoio 6 – Desintoxicação 7 – Unidade Terapêutica Residencial-UTR 8 - Clínica Ortopédica |
| Classificação da especialidade de Internação (Interno) | String | 255 | Sim | Classificação da especialidade de internação descrita internamente pela Unidade de Saúde. |
| Data entrada internação | Date | - | Sim | Data de entrada do paciente como internação na Unidade de saúde. Formato(YYYY-MM-DD) |
| Hora entrada internação | Time | - | Sim | Horário de entrada do paciente como internação na Unidade de saúde. Formato (HH:MM:SS) |
| Data saída internação | Date | - | Não | Data de saída do paciente da internação na unidade de saúde. (Caso o paciente ainda não tenha saído da unidade de saúde este campo não deverá ser preenchido) Formato (YYYY-MM-DD) |
| Hora saída internação | Time | - | Não | Horário de saída do paciente da internação na unidade de saúde. (Caso o paciente ainda não tenha saído da unidade de saúde, este campo não deverá ser preenchido) Formato(HH:MM:SS) |
| Motivo da saída | Inteiro | - | Não | Tipo de saída hospitalar: 1 – Óbito 2 – Altas 3 – Transferência externa Obs.: Campo obrigatório caso Data e Hora da saída de internação tenham sido preenchidos. |
| Código do local de internação | Inteiro | - | Sim | Código interno na Unidade de saúde que identifica o Local que encontra-se o leito em que o paciente está presente. Exemplo.: Enfermaria, UTI, Emergência. Etc. Obs.: Refere-se ao último leito ocupado por determinada internação |
| Descrição do local de internação | String | 100 | Sim | Descrição do local de internação na Unidade de saúde em que o paciente está presente. Obs.: Refere-se ao último leito ocupado por determinada internação |
| Código interno leito | Inteiro | - | Sim | Código interno de identificação do leito na Unidade de saúde em que o paciente está ocupando. Obs.: Refere-se ao último leito ocupado por determinada internação |
| Descrição do leito | String | 100 | Sim | Descrição do leito na unidade de saúde em que o paciente está ocupando. Obs.: Refere-se ao último leito ocupado por determinada internação |
| Classificação do tipo de Leito | Inteiro | - | Sim | Classificação do tipo de leito de acordo com o cadastro do CNES. 1 – Cirúrgico 2 – Clínico 3 – Complementar 4 – Obstétrico 5 – Pediátrico 6 – Outras Especialidades 7 – Hospital/DIA 8 - Múltipla especialidade Obs.: Refere-se ao último leito ocupado por determinada internação |
| Maca | Inteiro | - | Sim | Caso o Leito em questão é uma maca, identificar: 1 – Sim 0 – Não Obs.: Refere-se ao último leito ocupado por determinada internação |
| Leito extra | Inteiro | - | Sim | Caso o Leito em questão é um leito extra, identificar: 1 – Sim 0 – Não Obs.: Refere-se ao último leito ocupado por determinada internação |

[^ voltar ao indice](#indice)

## 2 - Transferências internas

#### 2.1 Objetivo

Obter a movimentação internação (Mudanças de leito) das internações na unidade de saúde, considerando que uma única internação
poderá ser submetida a diversas transferências internas ao longo do período em que o paciente está sendo mantido internado na
unidade de saúde.

#### 2.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| CNPJ OSS | String | 15 | Sim | CNPJ da Organização Social de Saúde. |
| Razão Social da Organização Social de Saúde | String | 100 | Sim | Razão social da Organização Social de Saúde. |
| Nome Fantasia da Organização Social de Saúde | String | 100 | Sim | Nome fantasia da Organização Social de Saúde |
| Código da Unidade de Saúde | Inteiro | - | Sim | Código de identificação da unidade de saúde (CNES). |
| Razão Social da Unidade de Saúde | String | 100 | Sim | Descrever a razão social da unidade de saúde. |
| Nome fantasia da Unidade de Saúde | String | 100 | Sim | Descrever o nome fantasia da unidade de saúde. |
| Código da internação | Inteiro | - | Sim | Código único que identifica uma ocorrência de internação do paciente na unidade de saúde. |
| Data entrada leito | Date | - | Sim | Data de entrada do paciente no leito. Formato(YYYYMM-DD) |
| Hora entrada leito | Time | - | Sim | Horário de entrada do paciente no leito. Formato (HH:MM:SS) |
| Data saída leito | Date | - | Não | Data de saída do paciente do leito. (Caso o paciente ainda não tenha saído do leito este campo não deverá ser preenchido) Formato (YYYY-MM-DD) |
| Hora saída leito | Time | - | Não | Horário de saída do leito. (Caso o paciente ainda não tenha saído do leito, este campo não deverá ser preenchido) Formato(HH:MM:SS) |
| Código do local de internação | Inteiro | - | Sim | Código interno na Unidade de saúde que identifica o Local que encontra-se o leito em que o paciente está presente. Exemplo.: Enfermaria, UTI, Emergência. Etc. |
| Descrição do local de internação | String | 100 | Sim | Descrição do local de internação na Unidade de saúde em que o paciente está presente. |
| Código interno leito | Inteiro | - | Sim | Código interno de identificação do leito na Unidade de saúde em que o paciente está ocupando. |
| Descrição do leito | String | 100 | Sim | Descrição do leito na unidade de saúde em que o paciente está ocupando. |
| Classificação do tipo de Leito | Inteiro | - | Sim | Classificação do tipo de leito de acordo com o cadastro do CNES. 1 – Cirúrgico 2 – Clínico 3 – Complementar 4 – Obstétrico 5 – Pediátrico 6 – Outras Especialidades 7 – Hospital/DIA 8 - Múltipla especialidade |
| Maca | Inteiro | - | Sim | Caso o Leito em questão é uma maca, identificar: 1 – Sim 0 – Não |
| Leito extra | Inteiro | - | Sim | Caso o Leito em questão é um leito extra, identificar: 1 – Sim 0 – Não |



[^ voltar ao indice](#indice)


## 3 - Status do Leito (Mapa de leitos)

#### 3.1 Objetivo

Obter o status do leito, informando a situação de cada um dos mesmos, com o propósito de compreender diariamente quais leitos estão
(disponíveis, bloqueados ou Ocupados).

#### 3.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| CNPJ OSS | String | 15 | Sim | CNPJ da Organização Social de Saúde. |
| Razão Social da Organização Social de Saúde | String | 100 | Sim | Razão social da Organização Social de Saúde. |
| Nome Fantasia da Organização Social de Saúde | String | 100 | Sim | Nome fantasia da Organização Social de Saúde. |
| Código da Unidade de Saúde | Inteiro | - | Sim | Código de identificação da unidade de saúde (CNES). |
| Razão Social da Unidade de Saúde | String | 100 | Sim | Descrever a razão social da unidade de saúde. |
| Nome fantasia da Unidade de Saúde | String | 100 | Sim | Descrever o nome fantasia da unidade de saúde. |
| Data referência | String | 19 | Sim | Data e hora da última atualização do Status do leito. Formato (YYYY-MM-DD HH:MM:SS) |
| Hora referência | String | 8 | Sim | Hora da última atualização do Status do leitos. Formato (HH:MM:SS) |
| Código do local de internação | Inteiro | - | Sim | Código interno na unidade de saúde que identifica o local que encontra-se o leito. |
| Descrição do local de internação | String | 100 | Sim | Descrição do local de internação na Unidade de saúde em que encontra-se o leito. |
| Código interno leito | Inteiro | - | Sim | Código interno de identificação do leito na unidade de saúde. |
| Descrição do leito | String | 100 | Sim | Descrição do leito na Unidade de saúde. |
| Maca | Boolean | - | Sim | Identifica se o Leito em questão é uma maca |
| Leito extra | Boolean | - | Sim | Identifica se o Leito em questão é um leito extra |
| Classificação do tipo de Leito | Inteiro | - | Sim | Classificação do tipo de leito de acordo com o cadastro do CNES. 1 – Cirúrgico 2 – Clínico 3 – Complementar 4 – Obstétrico 5 – Pediátrico 6 – Outras Especialidades 7 – Hospital/DIA |
| Leito Status | Inteiro | - | Sim | Informa a situação atual do leito. 1 – Disponível. 2 – Ocupado. 3 – Bloqueado. |
| Causa Bloqueio ou Suspensão do leito | String | 255 | Sim | Informar a causa da suspensão ou bloqueio do leito. Obs.: Campo obrigatório caso a opção seja marcada como 3. |
| Data de ativação | Datetime | 19 | Sim | Data e hora da última atualização do Status do leito. Formato (YYYY-MM-DD HH:MM:SS) |
| Data de desativação | Datetime | 19 | Sim | Data e hora da última atualização do Status do leito. Formato (YYYY-MM-DD HH:MM:SS) |



[^ voltar ao indice](#indice)

