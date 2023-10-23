
--
-- Job usado para realizar uma validação periódica das Capsulas de Testes TDD

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'JOB_VALIDAR_CAPSULAS',
            job_type => 'STORED_PROCEDURE',
            job_action => 'ENCAPSULAR.INICIAR',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2023-09-24 20:07:43.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=SECONDLY;INTERVAL=5',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Job usado para realizar uma validação periódica das Capsulas de Testes TDD');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_VALIDAR_CAPSULAS', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_VALIDAR_CAPSULAS', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => 'JOB_VALIDAR_CAPSULAS');
END;
/
