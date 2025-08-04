Crie uma página JSP (calcula.jsp) com um formulário para receber dois valores reais
 e uma operação (+, -, * ou /) e realizar o cálculo. O resultado deverá ser apresentado
 junto com a expressão. Caso haja algum erro, a mensagem deverá aparecer ao lado
 do campo do formulário. Dica: para fazer a conversão de String para float, utilize o
 método estático parseFloat() da classe Float: Float Float.parseFloat(String s).
 Acrescente um servlet Calculo para processar a requisição do cálculo. A página
 calculo.jsp deverá se encarregar somente da apresentação dos dados.
 Dicas: O servlet deve repassar para a página as seguintes informações:
    • Se houve erro no valor 1.
    • Se houve erro no valor 2.
    • Se houve erro de divisão.
    • Resultado.
 Note que cada uma dessas informações pode ser nula ou não.
 Revise as funções de cada um dos elementos envolvidos no processo de
 desenvolvimento de páginas JSP.




 Servlet:
 import java.io.IOException;
 import java.io.PrintWriter;
 import jakarta.servlet.ServletException;
 import jakarta.servlet.annotation.WebServlet;
 import jakarta.servlet.http.HttpServlet;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 @WebServlet(urlPatterns = {"/calcula"})
public class calcula extends HttpServlet {
 protected void processRequest(HttpServletRequest request, HttpServletResponse
 response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Float valor1 = null;
        Float valor2 = null;
        boolean erroValor1 = false;
        boolean erroValor2 = false;
        try {
            valor1 = Float.parseFloat(request.getParameter("valor1"));
        } catch (Exception e) {
            erroValor1 = true;
        }
        try {
            valor2 = Float.parseFloat(request.getParameter("valor2"));
        } catch (Exception e) {
            erroValor2 = true;
        }
        String expressao = null;
        if (!erroValor1 && !erroValor2 && valor1 != null && valor2 != null) {
            Float resultado = valor1 + valor2;
            expressao = String.format("%f + %f = %f", valor1, valor2, resultado);
        }
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Calcula</title>");
            out.println("</head>");
            out.println("<body>");
            if (expressao != null) {
                out.println("<h1>Resultado: " + expressao + "</h1>");
            } else {
                if (erroValor1) {
                    out.println("<p style=\"color:red\">Valor 1 inválido</p>");
                }
                if (erroValor2) {
                    out.println("<p style=\"color:red\">Valor 2 inválido</p>");
                }
            }
            out.println("</body>");
            out.println("</html>");
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }
 }
 JPS:
 <%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html> 
<% 
    Float valor1 = null; 
    Float valor2 = null; 
    String expressao = null; 
    boolean erroValor1 = false; 
    boolean erroValor2 = false; 
    boolean temErro = false; 
    if (request.getParameter("valor1") != null) 
    {
        try {
        valor1 = Float.parseFloat(request.getParameter("valor1"));
            } 
        catch(Exception e){ erroValor1 = true; } 
    } 
    if (request.getParameter("valor2") != null) 
    { 
    } 
        try { 
        valor2 = Float.parseFloat(request.getParameter("valor2")); 
            }
        catch(Exception e){ erroValor2 = true; } 
    if (!erroValor1 && !erroValor2 && valor1 != null && valor2 != null) 
    { 
    } 
        Float resultado = null;
        char op = request.getParameter("op").charAt(0);
        switch (op) 
        { 
        case '+': resultado = valor1 + valor2; break; 
        }
        if (resultado != null)
        { expressao = String.format("%f %c %f = %f", valor1, op, valor2, resultado); } 
    temErro = erroValor1 || erroValor2; 
%> 
<html> 
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
        <title>Calculadora</title> 
    </head> 
    <body> 
        <form name="calc" method="get" action="calcula"> 
            <table> 
                <tr> 
                    <td>Valor 1:</td> 
                    <td> 
                        <input type="text" size="10" name="valor1" value="
                               <%=temErro ? request.getParameter("valor1"):""%>"> 
                        <span style="color:red"> <%=erroValor1 ? "Valor 1 inválido" : ""%> 
                        </span> 
                    </td> 
                </tr> 
                <tr> 
                    <td>Op:</td> 
                    <td> <select name="op"> 
                            <option value="+"<%=temErro &&
 request.getParameter("op").equals("+") ? "selected" : ""%>>+</option> 
                        </select> 
                    </td> 
                </tr> <% if (expressao != null) { %> 
                <tr> 
                    <td>Expressão: 
                    </td> 
                    <td><span style="color:red"><%=expressao%></span>
                    </td>
                </tr> <% } %> 
                <tr> 
                    <td></td> 
                    <td>
                        <input type="submit" value="Calcula">
                    </td> 
                </tr> 
            </table> 
        </form> 
    </body>
 </html>
