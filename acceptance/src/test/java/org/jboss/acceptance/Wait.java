package org.jboss.acceptance;

import static com.jayway.restassured.RestAssured.*;
import com.jayway.restassured.response.Response;

public class Wait {

  public static void main(String[]a) throws InterruptedException{
    for (int i = 0; i < 30; i++) {
      String s=null;
      try{
        Response response=with().get("http://localhost:8383/hawtio");
        System.out.println(s=response.getStatusLine());
      }catch(Exception e){
        Thread.sleep(1000l);
        continue;
      }finally{
        System.out.print(".");
      }
      if (!s.contains("OK")){
        Thread.sleep(1000);
        System.out.println("Status is: "+s);
      }
      Thread.sleep(1000l);
      System.out.println("Fuse is up!");
    }
  }
}
