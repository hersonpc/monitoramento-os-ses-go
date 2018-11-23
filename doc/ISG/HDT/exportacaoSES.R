library(RISGMv)

setwd('F:/gdrive/code/isg/hdt/monitoramento-os-ses-go/doc/ISG/HDT/')

ler <- function(fileName) {
  return (readChar(fileName, file.info(fileName)$size))
}

exportar_internacoes <- function() {
  script_sql <- ler("exportar_script_1.sql")
  script_sql <- gsub("%DATA%", '01/01/2015', script_sql)
  dsInternacoes <- RISGMv::query(script_sql)
  write.csv2(x = dsInternacoes, file = "hdt_exportacao_internacoes.csv", fileEncoding = 'UTF-8')
}

exportar_movimentacoes_internas <- function() {
  script_sql <- ler("exportar_script_2.sql")
  script_sql <- gsub("%DATA%", '20/05/2018', script_sql)
  dsMovimentacoes <- RISGMv::query(script_sql)
  dsMovimentacoes[is.na(dsMovimentacoes)] <- ''
  write.csv2(x = dsMovimentacoes, file = "hdt_exportacao_movimentacoes.csv", fileEncoding = 'ISO-8859-1')
}

exportar_status_leitos <- function() {
  script_sql <- ler("exportar_script_3.sql")
  script_sql <- gsub("%DATA%", '01/01/2015', script_sql)
  dsInternacoes <- RISGMv::query(script_sql)
  write.csv2(x = dsInternacoes, file = "hdt_exportacao_internacoes.csv", fileEncoding = 'UTF-8')
}

exportar_internacoes()

dsMovimentacoes <- RISGMv::query("select * from VDIC_SESMOS_INTERNACOES where dt_cadastro >= '01/01/2015'")
write.csv2(x = dsInternacoes, file = "hdt_exportacao_internacoes.csv", fileEncoding = 'UTF-8')


dsStatus <- RISGMv::query("select * from VDIC_SESMOS_INTERNACOES where dt_cadastro >= '01/01/2015'")
write.csv2(x = dsInternacoes, file = "hdt_exportacao_internacoes.csv", fileEncoding = 'UTF-8')
