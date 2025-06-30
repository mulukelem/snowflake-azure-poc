CREATE OR REPLACE STAGE azure_stage
  URL = 'azure://solteststorage.blob.core.windows.net/soltestcontainer/'
  STORAGE_INTEGRATION = azure_int;
