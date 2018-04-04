# Layout de Integração v1.5

[Download PDF](../../raw/master/layouts/layout-internacao-v1.5%20.pdf)

## Indice

  * [1 - Registro de internação](#1---registro-de-internação)
  * [2 - Transferências internas](#2---transferências-internas)
  * [3 - Mapa de leitos (Quantitativo)](#3---mapa-de-leitos-quantitativo)
  * [4 - Mapa de leitos (Status do leito)](#4---mapa-de-leitos-status-do-leito)

## 1 - Registro de internação

#### 1.1 Objetivo

Obter os registros referentes as internações. Os respectivos dados extraídos serão utilizados para o acompanhamento da produção
assistencial e o desenvolvimento dos indicadores de qualidade.

#### 1.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| CNPJ | OSS | String | 15 | Sim | CNPJ da Organização Social de Saúde. |
| Razão Social da Organização Social de Saúde | String | 100 | Sim | Razão social da Organização Social de Saúde. |
| Nome Fantasia da Organização Social de Saúde | String | 100 | Sim | Nome fantasia da Organização Social de Saúde. |
| Código da Unidade de Saúde | Inteiro | - | Sim | Código de identificação da unidade de saúde (CNES). |
| Razão Social da Unidade de Saúde | String | 100 | Sim | Descrever a razão social da unidade de saúde. |
| Nome fantasia da Unidade de Saúde | String | 100 | Sim | Descrever o nome fantasia da unidade de saúde. |
| Código da internação | Inteiro | - | Sim | Código único que identifica uma ocorrência de internação do paciente na unidade de saúde. |
| Código da ficha do paciente | Inteiro | - | Sim | Código de identificação da ficha do paciente na Unidade de saúde. |
| CNS Paciente | String | 15 | Sim | Cartão Nacional de Saúde do Paciente |

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

## 3 - Mapa de leitos (Quantitativo)

#### 3.1 Objetivo

Obter o censo diário referente a disponibilidade de leitos. Apresentando a relação quantitativa de leitos operacionais, instalados,
bloqueados e leitos de observação

#### 3.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|

## 4 - Mapa de leitos (Status do leito)

#### 4.1 Objetivo.

Obter o status do leito, informando a situação de cada um dos mesmos.

#### 4.2 Estrutura CSV

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
