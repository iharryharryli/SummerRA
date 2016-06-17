class LogFormat{
  PrintWriter writer;
  Object[] format;
  
  public LogFormat(PrintWriter x,Object[] y){
    writer = x;
    format = y;
    
  }
  
  void logging(String[] content){
    for(int i=0; i<format.length; i++){
      Object t = format[i];
      if(t instanceof String){
        writer.print((String)t);
      }
      else if(t instanceof Integer){
        writer.print(content[((Integer)t)]);
      }
    }
    writer.flush();
  }
  
}

class LogItem{
  PrintWriter writer;
  Object[] format;
  public LogItem(PrintWriter a, Object[] b){
    writer = a;
    format = b;
  }
}

class Logger{
  
  LogFormat[] logs;
  
  public Logger(LogItem[] x){
    logs = new LogFormat[x.length];
    for(int i=0; i<x.length; i++){
      
      
      logs[i] = new LogFormat(x[i].writer,x[i].format);
    }
  }
  
  void logging(int i,String[] content){
    logs[i].logging(content);
  }
}

public Object[] createEntry(){
      String sessionId = "L-797cc01:11524c915db:-6ea0";
    String timeZone = "US/Eastern" ;
    String unit = "Unit1";
  String section ="Section1";
  String school ="Montour";
  String classnumber = "Test101";
  String conditionName = "combined";
  String conditionType = "2";
  String studentResponseType ="ATTEMPT";
  String tutorResponseType ="RESULT";
  String selection = "askNesra";
  
  Object[] res = new Object[]{"New player",0,1,2,"\t",sessionId+"\t",
      3,4,5,"\t",timeZone+"\t",studentResponseType+"\t",tutorResponseType+"\t",
    selection+"\t",unit+"\t",  section+"\t",6};
    
    return res;
  
}

public Object[] createSituationLog(){
  Object[] res = new Object[]{0,"-",1,"\tprediction\t"};
  return res;
}

public Object[] createPredictionLog(){
  Object[] res = new Object[]{"explanation\t"+"ButtonPressed\t",0,"\t"};
  return res;
}
