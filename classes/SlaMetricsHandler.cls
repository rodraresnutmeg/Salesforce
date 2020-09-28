public with sharing class SlaMetricsHandler {

    public static void afterInsert(Set<id> metricsIds) {
        List<SLA_Metrics__c> metricsToUpdate = new List<SLA_Metrics__c>();
        List<SLA_Metrics__c> metricsHistory = new List<SLA_Metrics__c>();
        List<SLA_Metrics__c> metricsToProcess = new List<SLA_Metrics__c>();
        set<id> casesId = new set<id>();
        Map<Id, List<SLA_Metrics__c>> metricsHistoryMap =new Map<Id, List<SLA_Metrics__c>> ();
        metricsToProcess = [select id, Case__c , Response_time__c,First_response__c,Type__c,  Outbound__c,Received_date__c ,Response_date__c, User__c from SLA_Metrics__c where id in:metricsIds ];

        for(SLA_Metrics__c s :metricsToProcess ){
            casesId.add(s.Case__c);
        }
       // update metrics;
        metricsHistory = [select id, Case__c , Response_time__c,First_response__c,Type__c,  Outbound__c,Received_date__c ,Response_date__c, User__c from SLA_Metrics__c where Case__c in:casesId order by createddate desc];

        for(SLA_Metrics__c s :metricsToProcess ){
            for(SLA_Metrics__c oldS :metricsHistory ){
                List<SLA_Metrics__c> listAux = new List<SLA_Metrics__c> (); 
                if(s.Case__c== oldS.Case__c && s.id != oldS.id){
                    System.debug(LoggingLevel.info , 'rodri sla handler s ' + s); 
                    System.debug(LoggingLevel.info , 'rodri sla handler oldS ' + oldS); 
                    if(metricsHistoryMap.containsKey(s.id)){
                        listAux = metricsHistoryMap.get(s.id);
                    }
                    listAux.add(oldS);
                    metricsHistoryMap.put(s.id,listAux);
                }
            }
        }

        for(SLA_Metrics__c s :metricsToProcess ){
            if(!metricsHistoryMap.isEmpty()){
                SLA_Metrics__c toUpdate = processMetrics(s ,metricsHistoryMap.get(s.id) );
                metricsToUpdate.add(toUpdate);
            }
        }
        if(!metricsToUpdate.isEmpty()){
            update metricsToUpdate;
        }
    }

    public static SLA_Metrics__c processMetrics(SLA_Metrics__c originalMetric , List<SLA_Metrics__c> listMetrics){
        SLA_Metrics__c metric = new SLA_Metrics__c();
        Boolean flag = false;
        if(!listMetrics.isEmpty()){
            for(SLA_Metrics__c s : listMetrics){
                if(!flag){
                    if(listMetrics.size() == 1){
                        if(originalMetric.Outbound__c && !s.Outbound__c){
                            originalMetric.First_response__c = true;
                            originalMetric.Response_time__c = getResponseTime(originalMetric.Response_date__c , s.Received_date__c  );
                            System.debug(LoggingLevel.INFO,  'Rodri Response_time__c' + originalMetric.Response_time__c);
                            createConsolidateSla(originalMetric, true);
                        }
                    }else{
                        System.debug(LoggingLevel.INFO,  'Rodri SLA' + s);
                        if(originalMetric.Outbound__c && !s.Outbound__c){
                            System.debug(LoggingLevel.INFO,  'Rodri adentro' + s);
                            DateTime oldReceiveTime = getOldesReceiveTime(listMetrics);
                            if(oldReceiveTime != null && originalMetric.Response_date__c != null){
                                originalMetric.Response_time__c = getResponseTime(originalMetric.Response_date__c , oldReceiveTime  );

                            }
                            originalMetric.First_response__c = checkIfFirstResponse(listMetrics);
                            flag = true;
                            createConsolidateSla(originalMetric, false);
                            //Que tal si  useo break; ??? Googlearlo
                        }else{
                            flag = true;
                        }
                    }
                }

            }
 
        }
       
        return originalMetric;
    }
    public static DateTime getOldesReceiveTime(List<SLA_Metrics__c> listMetrics){
        DateTime receivedTime ;
        Boolean flag = true;
        for(SLA_Metrics__c s : listMetrics ){
            if(flag){
                if(!s.Outbound__c){
                    receivedTime = s.Received_date__c;
                }else{
                    //Que tal si  useo break; ??? Googlearlo
                    flag =false;
                }
            }

        }
        return receivedTime;

    }
    public static Long getResponseTime(Datetime a, Datetime b){
      
        Decimal milliseconds = (a.getTime() - b.getTime());
        Decimal seconds = milliseconds / 1000;
        Decimal minutes = seconds / 60;
        Long minutesRound = minutes.round();
        return minutesRound;

    }

    public static Boolean checkIfFirstResponse( List<SLA_Metrics__c> listMetrics){
        boolean firstResponse = true;
        for(SLA_Metrics__c s : listMetrics ){
            if(s.First_response__c){
                firstResponse = false;
            }
        }
        return firstResponse;

    }

    public static void createConsolidateSla(SLA_Metrics__c metric, Boolean first){
        List<SLA__c> metricsInfo = new List<SLA__c>();
        if(first){
            SLA__c sla = new SLA__c(
                Agent__c = metric.User__c,
                Interactions__c = 1,
                First_response__c = metric.Response_time__c,
                Average_Response__c = metric.Response_time__c,
                Case__c = metric.Case__c);
                insert sla;
        }else{
            metricsInfo = [select Agent__c , Interactions__c, First_response__c, Average_Response__c, Case__c from SLA__c where Case__c =: metric.case__c and Agent__c =: metric.User__c order by createddate desc];
            if(metricsInfo.isEmpty()){
                SLA__c sla = new SLA__c(
                Agent__c = metric.User__c,
                Interactions__c = 1,
                Average_Response__c = metric.Response_time__c,
                Case__c = metric.Case__c);
                insert sla;
            }else{
                List<SLA_Metrics__c> allMetricsInfo = new List<SLA_Metrics__c>();
                allMetricsInfo = [select id, Case__c , Response_time__c,First_response__c,Type__c,  Outbound__c,Received_date__c ,Response_date__c, User__c from SLA_Metrics__c where Case__c =: metric.case__c and user__c=: metric.User__c and Response_time__c!= null order by createddate desc];
                Integer interactions = 0;
                Decimal totalTime = 0;
                if(!allMetricsInfo.isEmpty()){
                    for(SLA_Metrics__c s :allMetricsInfo){
                        interactions = interactions + 1;
                        totalTime =totalTime + s.Response_time__c;
                    }
                    
                }
                interactions = interactions + 1;
                totalTime = totalTime + metric.Response_time__c;
                metricsInfo[0].Interactions__c = interactions;
                metricsInfo[0].Average_Response__c = (totalTime /interactions ).round();
                update metricsInfo;
                //Integer totaltime = 0;
              //  for(SLA__c s : metricsInfo){
                   // totaltime = s + s
                }
            
        }
    }
}