CREATE OR REPLACE FUNCTION GERAR_NOME_TRACE( p_PREFIXO_NOME_TRACE IN VARCHAR2 ) RETURN VARCHAR2 IS
--
-- Função que gera um novo nome para o arquivo de Trace
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	v_NOME_TRACE VARCHAR2(100);

    v_DATA_FORMATADA VARCHAR2(100);

	
BEGIN

    SELECT TO_CHAR(SYSDATE, 'HH24"h"MI"m"SS"s"') INTO v_DATA_FORMATADA FROM DUAL;

    v_NOME_TRACE := REPLACE( CONSTANTES.PREFIXO_NOME_TRACEFILE_IDENTIFIER, '{TESTE_ID}', p_PREFIXO_NOME_TRACE );

    v_NOME_TRACE := REPLACE( v_NOME_TRACE, '{DATA_TESTE}', v_DATA_FORMATADA );

    RETURN v_NOME_TRACE;

END;
/


