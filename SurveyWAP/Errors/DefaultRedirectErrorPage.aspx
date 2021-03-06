﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DefaultRedirectErrorPage.aspx.cs" Inherits="Votations.NSurvey.WebAdmin.NSurveyAdmin.Errors.DefaultRedirectErrorPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Survey&#8482; Project Webapplication</title>
    <meta charset="UTF-8" />

    <meta name="application-name" content="Survey&trade; Project Errorpage" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <meta name="DESCRIPTION" content="SurveyProject&trade;  is a free and open source survey and (data entry) forms webapplication for processing & gathering data online." />
    <meta name="KEYWORDS" content="surveyproject, survey, webform, questionnaire, nsurvey, w3devpro" />
    <meta name="COPYRIGHT" content=" 2021 &lt;href='http://www.w3devpro.com'>W3DevPro&lt;/a>" />
    <meta name="GENERATOR" content="SurveyProject&trade; " />
    <meta name="AUTHOR" content="W3DevPro" />

    <meta name="RESOURCE-TYPE" content="DOCUMENT" />
    <meta name="DISTRIBUTION" content="GLOBAL" />
    <meta name="ROBOTS" content="INDEX, FOLLOW" />
    <meta name="REVISIT-AFTER" content="1 DAYS" />
    <meta name="RATING" content="GENERAL" />

    <!-- IE only -->
    <meta http-equiv="PAGE-ENTER" content="RevealTrans(Duration=0,Transition=1)" />

        <link rel="SHORTCUT ICON" href="favicon.ico" type="image/x-icon" />
</head>
<body>
    <form id="form1" runat="server">

  <div style=" font-family:Tahoma; 
      font-size:small; 
      width:1020px; 
      background-color: #e2e2e2; 
      padding:35px; 
      -webkit-border-radius: 7px;
      -moz-border-radius: 7px;
      border-radius: 7px;
  ">

            <div class="topCell"
            style=" left:-4px;
                    top:-3px;
                    position: relative;
                    padding:0px 13px 2px 0px; 
                    border: 0px; 
                    border-top-style: none;
                    border-left-style: none;
                    border-bottom-style: none;
                    border-right-style: none;
                    border-color: #ffffff;
                    
          
            "> 
            
                <a href="<%= Page.ResolveUrl("~")%>default.aspx" title="Survey&#8482; Project Homepage" target="_self">
                 <img src="<%= Page.ResolveUrl("~")%>Images/SpLogo.svg" alt="logo" border="0" />
                </a>

            </div>  
  
  <br /><br />
    <h2>Survey&trade; Project Generic Error Page</h2>
    An error occured.<br /><br />
    For safety reasons the request has been redirected to this error page. 
    To try again please return to the <a href='Default.aspx'>Default Page</a>
      <br />

    <br />
    <hr style="color:#e2e2e2;"/><br /><br />&copy; W3DevPro&trade; <%=DateTime.Now.Year%>
  </div>
    </form>
</body>
</html>
