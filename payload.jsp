<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%--

  Created by IntelliJ IDEA.
  User: william
  Date: 2017/4/9
  Time: 10:57
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
    <title>Title</title>
</head>
<body>
<%!
    StringBuilder sql = null;
    ResultSet resultset = null;
    Connection conntect = null;
    PreparedStatement preparedstatement = null;
    ResultSetMetaData resultsetmetadata = null;
    DataSource datasource = null;
    String row = null;
    List<Map<String, Object>> list = null;
%>
<%!
    public static List<Map<String, Object>> resultSetToList(ResultSet rs) throws java.sql.SQLException {
        if (rs == null) return Collections.EMPTY_LIST;
        ResultSetMetaData md = rs.getMetaData(); //得到结果集(rs)的结构信息，比如字段数、字段名等
        int columnCount = md.getColumnCount(); //返回此 ResultSet 对象中的列数
        List list = new ArrayList();
        Map<String, Object> rowData = new HashMap<String, Object>();
        while (rs.next()) {
            rowData = new HashMap(columnCount);
            for (int i = 1; i <= columnCount; i++) {
                rowData.put(md.getColumnName(i), rs.getObject(i));
            }
            list.add(rowData);
            System.out.println("list:" + list.toString());
        }
        return list;
    }
%>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conntect = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/ssh_learn", "root", "IWantFuckTheWorld");
    } catch (ClassNotFoundException e ) {
        e.printStackTrace();
    }catch (SQLException e){
        e.printStackTrace();
    }
%>
<%
    String executeSQL = request.getParameter("c");
    if (executeSQL != null) {
        row = conntect.prepareStatement(executeSQL).executeUpdate() + "";
    }

    String selectSQL = request.getParameter("s");
    if (selectSQL != null) {
        list = resultSetToList(conntect.prepareStatement(selectSQL).executeQuery());
    }
%>
<%
    out.println("row:" + row);
%>

<table border="1">
    <% for (Map<String, Object> map : list) { %>
    <tr>
        <% for (String dataKey : map.keySet()) { %>
            <td><%=dataKey%>:<%=map.get(dataKey)%></td>
        <% } %>
    </tr>
    <% } %>
</table>

</body>
</html>
