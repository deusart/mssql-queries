-- Создаём фунцию для секционирования. Она буде делить секции по значению INT, ранжирование указано в VALUES
CREATE PARTITION FUNCTION partition_function(INT) AS RANGE FOR VALUES (0, 10, 100, 1000)

-- Создаём схему для секционирования
CREATE PARTITION SCHEME partition_scheme AS PARTITION partition_function ALL TO ([PRIMARY])

-- Создаём таблицу в соответствующей схеме
CREATE TABLE partition_table (field_01 INT, field_02 INT) ON partition_scheme(field_01)

-- Заполняем таблицу
INSERT INTO partition_table (field_01, field_02)
VALUES (-1, 200),(1, 200), (10, 200), (12, 200), (100, 200), (101, 200), (1010, 200)

-- Вывод номера партишна для строки
SELECT $PARTITION.partition_function(field_01) AS PartitionNumber, *
FROM partition_table

-- Информация о таблице и секциях
SELECT DISTINCT o.name as table_name, rv.value as partition_range, fg.name as file_groupName, p.partition_number, p.rows as number_of_rows
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE o.object_id = OBJECT_ID('partition_table');

