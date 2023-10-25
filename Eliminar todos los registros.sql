USE LOLABUM;

-- Desactivar restricciones de clave externa
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- Eliminar datos
DECLARE @tableName NVARCHAR(MAX);
DECLARE tableCursor CURSOR FOR
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

OPEN tableCursor;
FETCH NEXT FROM tableCursor INTO @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'DELETE FROM ' + @tableName;
    EXEC sp_executesql @sql;

    FETCH NEXT FROM tableCursor INTO @tableName;
END

CLOSE tableCursor;
DEALLOCATE tableCursor;

-- Activar restricciones de clave externa
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
