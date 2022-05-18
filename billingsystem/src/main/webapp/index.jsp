<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
String sessemail = String.valueOf(session.getAttribute("uemail"));
if(sessemail.equals("null")){
  response.sendRedirect("login.jsp");
}
else if(!sessemail.equals("")){
String driver = "com.mysql.jdbc.Driver";
String connectionUrl = "jdbc:mysql://localhost:3306/";
String database = "bill";
String userid = "root";
String password = "";
String sql="",sql1="",sql2="",sql3="";
Connection con=null,con1=null,con2=null,con3=null;
Statement stm=null,stm1=null,stm2=null,stm3=null;
ResultSet rs=null,rs1=null,rs2=null,rs3=null;
String tblitemname="",recname="",viewstr="",itemnamestr="";
int recitemid=0,recqty=0,recprice=0,recbillid=0,inta=0,intb=0,intc=0,intd=0,inte=0;
int tblitemid=0,tblitemprice=0,viewint=0,viewgrandtotal=0;
boolean viewtrue=false;
viewstr = request.getParameter("view");
if(viewstr!=null){
    viewint=Integer.parseInt(viewstr);
    viewtrue=true;
}
String opt = request.getParameter("opt");
int optnum=0;
if(opt==null){optnum=1;}
else if(opt.equals("bill")){optnum=1;}
else if(opt.equals("rec")){optnum=2;}
else if(opt.equals("view")){optnum=3;}
else if(opt.equals("logout")){optnum=4;}
%>
<!DOCTYPE html>
<html>
  <head>
    <title>Billing System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <style>
      .mainbody{height:100vh;}
      .billupperbody{height:10vh;padding:10px 150px;padding-bottom:20px;}
      .billtitlebox,.billnavbox{font-size:30px;width:50%;}
      .lis{padding:5px 10px;}
      .ahr{font-size:18px;text-decoration:none;color:#000;padding:0 5px;}
      
      .billlowerbody{height:90vh;overflow: hidden;}
      .inrbilllwrbdy{width:660px;height:100%;}
      .formA{border-radius:5px;padding:20px;}
      .bbAlevel1{padding-bottom:10px;}
      .fAinp1{font-size:18px;width:270px;font-weight:300;padding:5px 10px;border:none;border-bottom:1px solid #666;}
      .fAdatebox{font-size:18px;font-weight:300;}

      .bbal23box{flex-grow: 1;}
      .span0{height:100%;width:1px;background:#000;left:0;top:0;}
      .span1{left:6%;}
      .span2{left:60%;}
      .span3{left:75%;}
      .span4{left:85%;}
      .span5{height:1px;width:100%;top:25px;left:0;}

      .bbAl2box0{text-align:center;font-size:18px;padding:2px 0;}
      .bbAl2box1{width:6%;}
      .bbAl2box2{width:54%;text-align:left;padding:2px 5px;}
      .bbAl2box3{width:15%;}
      .bbAl2box4{width:10%;}
      .bbAl2box5{width:15%;}

      .bbAlevel3{flex-grow: 1;}
      .bbAl3itembox{padding:10px 0 0 0;}
      .bbAl3box0{text-align:center;font-size:16px;padding:2px 0;}
      .bbAl3box1{width:6%;}
      .bbAl3box2{width:54%;text-align:left;padding:2px 5px;}
      .bbAl3box3{width:15%;padding:0;}
      .bbAl3box4{width:10%;}
      .bbAl3box5{width:15%;}
      .qtyminus,.qtyplus{border-radius:50%;cursor: pointer;background:#bbb;}
      .qtyminus{width:25%;margin-right:5%;}
      .qtynumber{width:40%;margin-right:5%;}
      .qtyplus{width:25%;}


      .bbAlevel4{border-right:1px solid #000;border-bottom:1px solid #000;border-left: 1px solid #000;}
      .bbAl4box0{font-size:18px;font-weight:400;text-align:center;padding:3px 5px;}
      .bbAl4box1{width:85%;text-align: right;}
      .bbAl4box2{width:15%;}
      .span41{left:85%;}

      .bbAlevel5{padding-top:10px;}
      .btnsubmit,.btnreset{font-size:18px;padding:5px 20px;border-radius:2px;color:#fff;cursor: pointer;border:none;}
      .btnsubmit{background:#0d6efd;margin-right:10px;}
      .btnreset{background:#dc3545;}
      
      .inrrecordroom{border-radius:5px;padding:20px;}
      .recordtitle{font-size:22px;padding-bottom:10px;}
      .recbox0{text-align:center;font-size:18px;padding:2px 0;border:var(--borderx);}
      .customerlist:first-child{background:#ccc;}
      .customerlist{margin-bottom:10px;background:#ddd;}
      .recbox1{width:6%;border-right:none;}
      .recbox2{width:64%;text-align:left;padding:2px 5px;border-right:none;}
      .recbox3{width:15%;border-right:none;}
      .recbox4{width:15%;}
      .viewdetails{font-size:16px;color:#000;text-decoration: none;padding:2px 10px;border-radius:3px;transition:.3s;}
      .viewdetails:hover{background:#bbb;}
      
      .inrviewroom{border-radius:5px;padding:20px;}
      .viewlistbox{padding:10px;border-radius:5px;background:#eee;}
      .noborder{border:none;}
      
      .logoutform{padding:20px;border-radius:5px;}
      .logoutbox1{width:220px;font-size:20px;font-weight:300;text-align: center;padding-bottom:15px;}
      .submitcancelbtn{font-size:18px;font-weight:300;padding:3px 15px;color:#000;text-decoration:none;cursor: pointer;border-radius:3px;}
      .submitbtn{background:#ff4444;color:#fff;border:none;}
    </style>
  </head>
  <body>
    <div class="mainbody borde">
      <div class="inrmainbody borde ins flex fdc">
        <div class="billupperbody borde flex jcsb">
          <div class="billtitlebox bord">Customer Billing Sytsem</div>
          <div class="billnavbox borde flex aic jcc">
            <ul class="ullist flex borde">
              <li class="lis flex borde"><a href="index.jsp?opt=bill" class="ahr borde">Bill</a></li>
              <li class="lis flex borde"><a href="index.jsp?opt=rec" class="ahr borde">Records</a></li>
              <li class="lis flex borde"><a href="index.jsp?opt=logout" class="ahr borde">Logout</a></li>
            </ul>
          </div>
        </div>
        <div class="billlowerbody borde flex jcc">
          <div class="inrbilllwrbdy borde">
            <div class="billbodyA borde ins">
            <%
            if(optnum==1){
            %>
              <form action="record" method="post" class="formA flex fdc ins border">
                <div class="bbAlevel1 borde flex jcsb">
                  <input type="text" class="fAinp1" name="n_namex" placeholder="customer name...">
                  <input type="hidden" class="hiddenquery" name="n_query">
                  <input type="hidden" class="hiddenname" name="n_name">
                  <div class="fAdatebox flex aic">3:44 PM, 4th May 2022</div>
                </div>
                <div class="bbal23box border flex fdc rel">
                  <div class="bbAlevel2 flex">
                    <div class="bbAl2box1 bbAl2box0">SN</div>
                    <div class="bbAl2box2 bbAl2box0">Name</div>
                    <div class="bbAl2box3 bbAl2box0">Quantity</div>
                    <div class="bbAl2box4 bbAl2box0">Price</div>
                    <div class="bbAl2box5 bbAl2box0">Total</div>
                  </div>
                  <div class="bbAlevel3 borde flex fdc">
                  <%
                    
                    try{
                        Class.forName("com.mysql.jdbc.Driver");  
                        con = DriverManager.getConnection(connectionUrl+database, userid, password);
                        stm=con.createStatement();
                        sql ="select * from items;";
                        rs = stm.executeQuery(sql);
                        while(rs.next()){
                            tblitemid = rs.getInt("id");
                            tblitemname = rs.getString("name");
                            tblitemprice = rs.getInt("price");
                  %>
                    <div class="bbAl3itembox borde flex">
                      <div class="bbAl3box1 bbAl3box0"><%=tblitemid%></div>
                      <div class="bbAl3box2 bbAl3box0"><%=tblitemname%></div>
                      <div class="bbAl3box3 bbAl3box0 flex borde">
                        <div class="qtyminus flex aic jcc" onclick="subitem(<%=tblitemid%>-1)">-</div>
                        <div class="qtynumber flex aic jcc">0</div>
                        <div class="qtyplus flex aic jcc" onclick="additem(<%=tblitemid%>-1)">+</div>
                      </div>
                      <div class="bbAl3box4 bbAl3box0"><%=tblitemprice%></div>
                      <div class="bbAl3box5 bbAl3box0">0</div>
                    </div>
                  <%    
                        }
                        con.close();
                    }
                    catch(Exception ex) {
                        System.out.println(ex.toString());
                    }
                  %>
                    
                  </div>
                  
                  <span class="span1 span0 abs"></span>
                  <span class="span2 span0 abs"></span>
                  <span class="span3 span0 abs"></span>
                  <span class="span4 span0 abs"></span>
                  <span class="span5 span0 abs"></span>
                </div>
                <div class="bbAlevel4 flex borde rel">
                  <div class="bbAl4box1 bbAl4box0">Grand Total</div>
                  <div class="bbAl4box2 bbAl4box0">0</div>
                  <span class="span41 span0 abs"></span>
                </div>
                
                <div class="bbAlevel5 flex borde">
                  <input type="submit" class="btnsubmit" value="Submit">
                  <input type="reset" class="btnreset" value="Reset">
                </div>
              </form>
            <%}else if(optnum==2){%>
              <div class="recordroom borde ins">
                <div class="inrrecordroom border ins flex fdc">
                  <div class="recordtitle borde">Customer Records</div>
                  <div class="customerlistbox">
                    <div class="customerlist flex">
                      <div class="recbox1 recbox0">SN</div>
                      <div class="recbox2 recbox0">Name</div>
                      <div class="recbox3 recbox0">Total</div>
                      <div class="recbox4 recbox0">Details</div>
                    </div>
                    <%
                    
                    try{
                        
                        Class.forName("com.mysql.jdbc.Driver");  
                        con = DriverManager.getConnection(connectionUrl+database, userid, password);
                        stm=con.createStatement();
                        sql ="select * from record;";
                        rs = stm.executeQuery(sql);
                        while(rs.next()){
                            recname =  rs.getString("username");
                            recitemid =  rs.getInt("itemid");
                            recqty =  rs.getInt("qty");
                            recprice =  rs.getInt("price");
                            recbillid =  rs.getInt("billid");
//                            usercountint = recbillid;
                            if(inta!=recbillid){
                                inta = recbillid;
                                intb++;
                                intc=inta;
                            
                    %>
                      <div class="customerlist borde flex">
                        <div class="recbox1 recbox0"><%=intb%></div>
                        <div class="recbox2 recbox0"><%=recname%></div>
                        <div class="recbox3 recbox0">Rs 520</div>
                        <div class="recbox4 recbox0 flex jcc aic">
                          <a href="index.jsp?opt=view&view=<%=recbillid%>" class="viewdetails border">View</a>
                        </div>
                      </div>
                    <%
                        }}                       
                        con.close();
                    }
                    catch(Exception ex) {
                        System.out.println(ex.toString());
                        out.print(ex.toString());
                    }
                    %>
                    
                  </div>
                </div>
              </div>
              <%}else if(optnum==3){%>
              <div class="viewroom borde ins">
                <div class="inrviewroom border ins flex fdc">
                  <div class="recordtitle borde">Customer Records</div>
                  <div class="viewlistbox border">
                    <div class="bbAlevel2 flex">
                      <div class="bbAl2box1 bbAl2box0">SN</div>
                      <div class="bbAl2box2 bbAl2box0">Name</div>
                      <div class="bbAl2box3 bbAl2box0">Quantity</div>
                      <div class="bbAl2box4 bbAl2box0">Price</div>
                      <div class="bbAl2box5 bbAl2box0">Total</div>
                    </div>
                    <%
                    try{
                        Class.forName("com.mysql.jdbc.Driver");  
                        con = DriverManager.getConnection(connectionUrl+database, userid, password);
                        stm=con.createStatement();
                        sql ="select*from record right outer join items on items.id = record.itemid;";
                        rs = stm.executeQuery(sql);
                        viewgrandtotal=0;
                    %>
                    <%
                        while(rs.next()){
                            recname =  rs.getString("username");
                            recitemid =  rs.getInt("itemid");
                            recqty =  rs.getInt("qty");
                            recprice =  rs.getInt("price");
                            recbillid =  rs.getInt("billid");
                            itemnamestr = rs.getString("name");
                            
                            if(viewtrue&&viewint==recbillid){
                                viewgrandtotal = viewgrandtotal + (recqty*recprice);
                    %>
                            <div class="bbAlevel2 flex">
                                <div class="bbAl2box1 bbAl2box0"><%=recitemid%></div>
                                <div class="bbAl2box2 bbAl2box0"><%=itemnamestr%></div>
                                <div class="bbAl2box3 bbAl2box0"><%=recqty%></div>
                                <div class="bbAl2box4 bbAl2box0"><%=recprice%></div>
                                <div class="bbAl2box5 bbAl2box0"><%=(recqty*recprice)%></div>
                            </div>
                    <%
                        }}
                        con.close();
                    }
                    catch(Exception ex) {
                        System.out.println(ex.toString());
                    }
                    %>
                    <div class="bbAlevel4 noborder flex borde rel">
                        <div class="bbAl4box1 bbAl4box0">Grand Total</div>
                        <div class="bbAl4box2 bbAl4box0"><%=viewgrandtotal%></div>
                    </div>
                    
                  </div>
                </div>
              </div>
              <%}else if(optnum==4){%>
              <div class="logoutbox borde flex jcc aic h100">
                <div class="inrlogoutbox borde">
                  <form action="index.jsp?opt=logout" method="post" class="logoutform border3 flex fdc">
                    <%
                        String nlogoutstr = request.getParameter("nlogout");
                        if(nlogoutstr!=null){
                            if(nlogoutstr.equals("Log Out")){
                            session.removeAttribute("uemail");
                            response.sendRedirect("index.jsp");
                            }
                        }
                    %>
                    <div class="logoutbox1 borde">
                      Are you sure you want to log out?
                    </div>
                    <div class="logoutbox2 borde flex jcsa">
                      <input type="submit" class="submitbtn submitcancelbtn" value="Log Out" name="nlogout">
                      <a href="index.jsp" class="cancelbtn submitcancelbtn border3">Cancel</a>
                    </div>
                  </form>
                </div>
              </div>
              <%}%>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script>
      /*
      var hiddenname = document.querySelector(".hiddenname");
      var bbAl3box1 = document.querySelectorAll(".bbAl3box1");
      */
      var itemnames = [],itemprice=[],lastrecordvar,mainquery,grandtotal=0;
      var fAinp1 = document.querySelector(".fAinp1");
      var bbAl3box1 = document.querySelectorAll(".bbAl3box1");
      var bbAl3box2 = document.querySelectorAll(".bbAl3box2");
      var bbAl3box4 = document.querySelectorAll(".bbAl3box4");
      var bbAl3box5 = document.querySelectorAll(".bbAl3box5");
      var qtynumber = document.querySelectorAll(".qtynumber");
      var bbAl4box2 = document.querySelector(".bbAl4box2");
      var hiddenquery = document.querySelector(".hiddenquery");
      var hiddenname = document.querySelector(".hiddenname");
      var itemcount=[];
    <%
        try{
            int lastrecord=0;
            Class.forName("com.mysql.jdbc.Driver");  
            con = DriverManager.getConnection(connectionUrl+database, userid, password);
            stm=con.createStatement();
            stm1=con.createStatement();
            sql ="select * from items;";
            sql1 ="select * from recordcount;";
            rs = stm.executeQuery(sql);
            rs1 = stm1.executeQuery(sql1);
            while(rs1.next()){
                lastrecord = rs1.getInt("id");
            }
            while(rs.next()){
                tblitemid = rs.getInt("id");
                tblitemname = rs.getString("name");
                tblitemprice = rs.getInt("price");
    %>
                itemnames[<%=tblitemid%>-1] = "<%=tblitemname%>";
                itemprice[<%=tblitemid%>-1] = "<%=tblitemprice%>";
                lastrecordvar = <%=lastrecord%>+1;
    <%    
            }
            con.close();
        }
        catch(Exception ex) {
            System.out.println(ex.toString());
        }
        
    %> 
    
      
      console.log(itemnames,itemprice);
      iteminitiate();
      function iteminitiate(){
        for(a=0;a<itemnames.length;a++){
          itemcount[a]=0;
        }
      }
      console.log(itemcount);
      function additem(i){
        if(itemcount[i]<10){
          itemcount[i]++;
          printQtyTotal(i);
        }
      }
      function subitem(i){
        if(itemcount[i]>0){
          itemcount[i]--;
          printQtyTotal(i);
        }
      }
      function printQtyTotal(x){
          qtynumber[x].innerHTML = itemcount[x];
          bbAl3box5[x].innerHTML = itemcount[x]*itemprice[x];
          
          createQuery();
      }
      createQuery();
      function createQuery(){
        var a,b=0,c=0,queryA=[];grandtotal=0;
        for(a=0;a<itemnames.length;a++){
          c=a+1;
          if(itemcount[a] != 0){
            queryA[b] = "('"+fAinp1.value+"',"+c+","+itemcount[a]+","+itemprice[a]+","+lastrecordvar+")";
            grandtotal=grandtotal+(itemcount[a]*itemprice[a]);
            bbAl4box2.innerHTML = grandtotal;
            b++;
          }
        }
        createQueryAgain(queryA);
      }
      function createQueryAgain(query){
        mainquery="insert into record(username,itemid,qty,price,billid)values";
        var queryA=query[0],queryB;
        for(a=1;a<query.length;a++){
            queryA=queryA+","+query[a];
        }
        mainquery=mainquery+queryA+";";
        console.log(query.length,mainquery);
        hiddenquery.value=mainquery;
        hiddenname.value="insert into recordcount(name)values('"+fAinp1.value+"');";
        console.log("Grand Total",grandtotal);
      }
    </script>
  </body>
</html>
<%}%>