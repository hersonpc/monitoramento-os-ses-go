# Projeto: Monitoramento OS SES/GO

Sistema Integrador de Monitoramento de OS's - SIMOS SES/GO

## Consumo das análises

As análises graficas e consolidações seram apresentadas publicamente através da seguinte url:

[http://187.5.96.67/public/monitoramento-os.html](http://187.5.96.67/public/monitoramento-os.html)

## Manual de Integração

[versão 1.6](/layouts/v1.6/) - 23 de Abril de 2018

## Scripts de Integração

| # | Registro | CRER | HDT | HGG |
|----|----------|------|-----|-----|
| 1  | Registro de internação | [abrir](/doc/AGIR/CRER/01.03_registro-de-internacao.sql) | [abrir](/doc/ISG/HDT/01.03_registro-de-internacao.sql) | - |
| 2 | Transferências internas | [abrir](/doc/AGIR/CRER/02.03_transferencias-internas.sql) | [abrir](/doc/ISG/HDT/02.03_transferencias-internas.sql) | - |
| 3 | Mapa de leitos (Status do leito) | - | [abrir](/doc/ISG/HDT/03.03_status_leitos.sql) | - |
| 4 | Atendimento Ambulatorial (Consultas eletivas) | - | [abrir](/doc/ISG/HDT/04.03_consultas_ambulatoriais.sql) | - |



## Modelo de implementação

### Caso de Uso

![](/doc/UML/CasoUso.png) 

### Diagrama de classe

![](/doc/UML/DiagramaClasse.png) 

### Arquitetura

![](/doc/UML/arquitetura_convergencia.png) 
