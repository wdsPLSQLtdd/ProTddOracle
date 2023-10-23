CREATE OR REPLACE FUNCTION GERAR_HASH( p_VALOR IN CLOB ) RETURN VARCHAR2 IS
--
-- Função que gera um HASH sobre um valor repassado via parâmetro
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	v_HASH_CRIADO VARCHAR2(4000);
	
	v_LENGHT_VALOR NUMBER;
	
	v_TEXTO_PARA_HASH VARCHAR2(1600);
	
BEGIN
	
	IF p_VALOR IS NULL THEN

		RETURN '';
	
	END IF;


    v_LENGHT_VALOR := CEIL( LENGTH( p_VALOR ) );
	
	
	v_TEXTO_PARA_HASH := SUBSTR( p_VALOR, 1, 1500 );
	

	-- Recursividade
	IF v_LENGHT_VALOR > 1500 THEN
		
		v_HASH_CRIADO := GERAR_HASH( SUBSTR( p_VALOR, 1501 ) );
        
		v_TEXTO_PARA_HASH := v_TEXTO_PARA_HASH || v_HASH_CRIADO;
	
	END IF;
		
	
	SELECT dbms_obfuscation_toolkit.md5( input => UTL_RAW.cast_to_raw( v_TEXTO_PARA_HASH ) ) INTO v_HASH_CRIADO FROM DUAL;
	
	
	RETURN v_HASH_CRIADO;

END;
/


