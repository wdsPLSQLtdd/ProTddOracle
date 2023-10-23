CREATE OR REPLACE FUNCTION GERAR_CODIGO RETURN NUMBER IS
--
-- Função que gera um novo código TIMESTAMP
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	CODIGO NUMBER;
	
BEGIN

    SELECT 
        ( EXTRACT(DAY FROM(SYS_EXTRACT_UTC(SYSTIMESTAMP) - TO_TIMESTAMP('1970-01-01', 'YYYY-MM-DD'))) * 86400000 + TO_NUMBER(TO_CHAR(SYS_EXTRACT_UTC(SYSTIMESTAMP), 'SSSSSFF3')) )
            INTO CODIGO
    FROM 
        DUAL;
    

    RETURN CODIGO;

END;
/


