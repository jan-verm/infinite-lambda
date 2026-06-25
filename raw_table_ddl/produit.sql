CREATE OR REPLACE EXTERNAL TABLE infinite-lambda.raw.produit (
  CIP STRING,
  Nom STRING,
  EAN13 STRING,
  Prix_Public FLOAT64,
  Prix_RefBD FLOAT64,
  MoyenPrixAHT FLOAT64,
  TVA INTEGER,
  En_stock INTEGER,
  StockUnite INTEGER,
  Time_Modif INTEGER,
  Code_rembt INTEGER,
  ingestion_ts timestamp
)
WITH PARTITION COLUMNS (
  p_pharmacy string,
  p_ingestion_dt date,
)
OPTIONS (
  format = 'NEWLINE_DELIMITED_JSON',
  uris = ['gs://wph-raw-data/produit/*'],
  hive_partition_uri_prefix = 'gs://wph-raw-data/produit/'
)
