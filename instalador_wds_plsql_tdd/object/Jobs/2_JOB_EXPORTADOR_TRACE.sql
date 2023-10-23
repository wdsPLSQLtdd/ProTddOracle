
--
-- Job que verifica se existem novos traces a serem processados com TKPROF e Coletados

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'JOB_EXPORTADOR_TRACE',
            job_type => 'STORED_PROCEDURE',
            job_action => 'EXPORTADOR_TRACE.IDENTIFICAR_NOVOS_TRACE',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2023-09-24 20:22:24.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=SECONDLY;INTERVAL=25',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Job que verifica se existem novos traces a serem processados com TKPROF e Coletados');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_EXPORTADOR_TRACE', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_EXPORTADOR_TRACE', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => 'JOB_EXPORTADOR_TRACE');
END;
/

