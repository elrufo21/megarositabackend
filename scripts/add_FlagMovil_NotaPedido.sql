IF COL_LENGTH('dbo.NotaPedido', 'FlagMovil') IS NULL
BEGIN
    ALTER TABLE dbo.NotaPedido
    ADD FlagMovil bit NOT NULL
        CONSTRAINT DF_NotaPedido_FlagMovil DEFAULT (0) WITH VALUES;
END;
GO

UPDATE dbo.NotaPedido
SET FlagMovil = 0
WHERE FlagMovil IS NULL;
GO
