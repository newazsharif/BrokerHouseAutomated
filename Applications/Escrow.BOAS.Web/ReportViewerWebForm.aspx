
<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="ReportViewerWebForm.aspx.cs" Inherits="ReportViewerForMvc.ReportViewerWebForm" ClientIDMode="Static" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="width: 721px; height: 330px;">
<head runat="server">
    <title></title>
    <link href="Content/report.css" media="print,handheld" rel="stylesheet" />
    
    </head>
    
<body style="background-color:#f2f2f2; overflow:hidden">
    <form id="form1" style="background-color:#f2f2f2;width:125%;height:600px;"  runat="server">
        
            <asp:ScriptManager ID="ScriptManager1" runat="server">
                <Scripts>
                    <asp:ScriptReference Assembly="ReportViewerForMvc" Name="ReportViewerForMvc.Scripts.PostMessage.js" />
                </Scripts>
            </asp:ScriptManager>

<%--            <asp:ScriptManager ID="ScriptManager1"  EnablePageMethods="true" 
                EnablePartialRendering="true" runat="server">
            </asp:ScriptManager>--%>
        
            <rsweb:ReportViewer BackColor="#ffcc99" ID="ReportViewer1" ShowPrintButton="true" ProcessingMode="Local" runat="server" ZoomMode="Percent" ClientIDMode="Inherit"></rsweb:ReportViewer>
                    <%--<rsweb:ReportViewer ID="rvREXReport" runat="server" Width="100%" Height="798px"
            Style="display: table !important; margin: 0px; overflow: auto !important;" 
            ShowBackButton="true" onreportrefresh="rrvREXReport_ReportRefresh">
            </rsweb:ReportViewer> --%>


           <%--<iframe id="frmPrint" name="frmPrint" runat="server" style = "display:none"></iframe>
                <div id="spinner" class="spinner" style="display:none;">
                    <table align="center" valign="middle" style="height:100%;width:100%">
                    <tr>
                    <td><img id="img-spinner" src="../Images/ajax-loader.gif" alt="Printing"/></td>
                    <td><span style="font-family:Verdana; font-weight:bold;font-size:10pt;width:86px;">Printing...</span></td>
                    </tr>
                    </table>
               </div>--%>
    </form>
</body>
<script src="Scripts/jquery-2.1.1.js"></script>

    <%--<script>
        function showPrintButton() {    
            var table = $("table[title='Refresh']");
            var parentTable = $(table).parents('table');
           

        }
    </script>--%>
     <script>
        
         $(document).ready(function () {
             var matched, browser;

             jQuery.uaMatch = function (ua) {
                 ua = ua.toLowerCase();

                 var match = /(chrome)[ \/]([\w.]+)/.exec(ua) ||
                     /(webkit)[ \/]([\w.]+)/.exec(ua) ||
                     /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) ||
                     /(msie) ([\w.]+)/.exec(ua) ||
                     ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) ||
                     [];

                 return {
                     browser: match[1] || "",
                     version: match[2] || "0"
                 };
             };

             matched = jQuery.uaMatch(navigator.userAgent);
             browser = {};

             if (matched.browser) {
                 browser[matched.browser] = true;
                 browser.version = matched.version;
             }

             // Chrome is Webkit, but Webkit is also Safari.
             if (browser.chrome) {
                 browser.webkit = true;
             } else if (browser.webkit) {
                 browser.safari = true;
             }

             jQuery.browser = browser;
             if (browser.mozilla || browser.chrome) {
                 try {
                     var ControlName = 'ReportViewer1';
                     var innerTbody = '<tbody><tr><td><input type="image" style="border-width: 0px; padding: 2px; height: 16px; width: 16px;" alt="Print" src="/Reserved.ReportViewerWebControl.axd?OpType=Resource&amp;Version=9.0.30729.1&amp;Name=Microsoft.Reporting.WebForms.Icons.Print.gif" title="Print"></td></tr></tbody>';
                     var innerTable = '<table title="Print" onclick="PrintFunc(\'' + ControlName + '\'); return false;" id="id="injectedPrintButton"" style="border: 1px solid rgb(236, 233, 216); background-color: rgb(236, 233, 216); cursor: default;">' + innerTbody + '</table>'
                     var outerDiv = '<div style="display: inline; font-size: 8pt; height: 30px;" class=" "><table cellspacing="0" cellpadding="0" style="display: inline;"><tbody><tr><td height="28px">' + innerTable + '</td></tr></tbody></table></div>';

                     $("#ReportViewer1_ctl05 > div").append(outerDiv);

                 }
                 catch (e) { alert(e); }
             }
         });

         function PrintFunc(s) {
             var headstr = "<html><head><style>.a86{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:2pt;" +
           "padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;" +
           "font-family:Arial;font-size:10pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;}.a5_s{WIDTH:146.05mm;HEIGHT:6.35mm;" +
           "font-style:Normal;font-family:Arial;font-size:10pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Center;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;}.a5{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:0pt;" +
           "padding-top:0pt;padding-right:0pt;padding-bottom:0pt;HEIGHT:6.35mm;" +
           "overflow:hidden;WIDTH:146.05mm}.a92{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:0pt;" +
           "padding-top:0pt;padding-right:0pt;padding-bottom:0pt;WIDTH:114.30mm}.a96{" +
           "border:1pt None Black;background-color:Transparent;background-repeat:" +
           "Repeat;padding-left:0pt;padding-top:0pt;padding-right:0pt;padding-bottom:0pt;" +
           "WIDTH:114.30mm}.a98{border:1pt None Black;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:0pt;padding-top:0pt;padding-right:0pt;" +
           "padding-bottom:0pt;WIDTH:38.10mm;HEIGHT:19.05mm;overflow:hidden}.a99" +
           "{border:1pt None Black;background-color:Transparent;background-repeat:" +
           "Repeat;padding-left:0pt;padding-top:0pt;padding-right:0pt;padding-bottom:0pt;" +
           "font-style:Normal;font-family:Arial;font-size:12pt;font-weight:700;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;}.a100{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:0pt;padding-top:" +
           "0pt;padding-right:0pt;padding-bottom:0pt;font-style:Normal;font-family:Arial;" +
           "font-size:10pt;font-weight:Normal;text-decoration:None;direction:LTR;unicode-bidi:" +
           "Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;}." +
           "a101{border:1pt None Black;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:0pt;padding-top:0pt;padding-right:0pt;padding-bottom:0pt;" +
           "font-style:Normal;font-family:Arial;font-size:10pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;}.a102{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:0pt;" +
           "padding-top:0pt;padding-right:0pt;padding-bottom:0pt;font-style:Normal;" +
           "font-family:Arial;font-size:10pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;}.a103{border:1pt None Black;background-color" +
           ":Transparent;background-repeat:Repeat;padding-left:0pt;padding-top:0pt;" +
           "padding-right:0pt;padding-bottom:0pt;font-style:Normal;font-family:Arial;" +
           "font-size:10pt;font-weight:Normal;text-decoration:None;direction:LTR;" +
           "unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;}" +
           ".a85{border:1pt None Black;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;" +
           "font-family:Arial;font-size:11pt;font-weight:700;text-decoration:None;direction:LTR;" +
           "unicode-bidi:Normal;text-align:Center;writing-mode:lr-tb;vertical-align:Top;color:Black;" +
           "}.a6{border:1pt None Black;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:0pt;padding-top:0pt;padding-right:0pt;padding-bottom:0pt;border" +
           "-collapse:collapse}.a76{border:1pt None Black;border-top-style:Solid;border" +
           "-bottom-style:Solid;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font" +
           "-style:Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;word-wrap:break-word}.a77{border:1pt None " +
           "Black;border-top-style:Solid;border-bottom-style:Solid;background-color:" +
           "Transparent;background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding" +
           "-right:2pt;padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:" +
           "9pt;font-weight:700;text-decoration:None;direction:LTR;unicode-bidi:Normal;" +
           "text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap" +
           ":break-word}.a78{border:1pt None Black;border-top-style:Solid;border-bottom" +
           "-style:Solid;background-color:Transparent;background-repeat:Repeat;padding" +
           "-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a79{border" +
           ":1pt None Black;border-top-style:Solid;border-bottom-style:Solid;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a80{border" +
           ":1pt None Black;border-top-style:Solid;border-bottom-style:Solid;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a81{border" +
           ":1pt None Black;border-top-style:Solid;border-bottom-style:Solid;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a82{border" +
           ":1pt None Black;border-top-style:Solid;border-bottom-style:Solid;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:700;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a83{border" +
           ":1pt None Black;border-top-style:Solid;border-bottom-style:Solid;background" +
           "-color:Transparent;background-repeat:Repeat;padding-left:2pt;padding-top:2pt;" +
           "padding-right:2pt;padding-bottom:2pt;font-style:Normal;font-family:Arial;font-" +
           "size:9pt;font-weight:700;text-decoration:None;direction:LTR;unicode-bidi:Normal;" +
           "text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:" +
           "break-word}.a84{border:1pt None Black;border-top-style:Solid;border-bottom-" +
           "style:Solid;background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;font" +
           "-family:Arial;font-size:9pt;font-weight:700;text-decoration:None;direction:LTR;" +
           "unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:" +
           "Black;word-wrap:break-word}.a17{border:1pt None Black;border-top-style:" +
           "Solid;border-bottom-style:Solid;background-color:Transparent;background-repeat" +
           ":Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;" +
           "font-style:Normal;font-family:Arial;font-size:10pt;font-weight:700;text-decoration:" +
           "None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-align:" +
           "Top;color:Black;word-wrap:break-word}.a18{border:1pt None Black;border-" +
           "top-style:Solid;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:10pt;font-weight:" +
           "Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a19" +
           "{border:1pt None Black;border-top-style:Solid;border-bottom-style:Solid;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:2pt;" +
           "padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;" +
           "font-family:Arial;font-size:10pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;word-wrap:break-word}.a20{border:1pt None Black;border" +
           "-top-style:Solid;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:10pt;" +
           "font-weight:Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;" +
           "text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap" +
           ":break-word}.a21{border:1pt None Black;border-top-style:Solid;border-" +
           "bottom-style:Solid;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;" +
           "font-style:Normal;font-family:Arial;font-size:10pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a22{border:" +
           "1pt None Black;border-top-style:Solid;border-bottom-style:Solid;background-color" +
           ":Transparent;background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding" +
           "-right:2pt;padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:10pt;" +
           "font-weight:Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;" +
           "text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:" +
           "break-word}.a23{border:1pt None Black;border-top-style:Solid;border-bottom" +
           "-style:Solid;background-color:Transparent;background-repeat:Repeat;padding" +
           "-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:" +
           "Normal;font-family:Arial;font-size:10pt;font-weight:Normal;text-decoration" +
           ":None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;word-wrap:break-word}.a35{border:1pt None Black;" +
           "border-bottom-style:Solid;background-color:Transparent;background-" +
           "repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-" +
           "bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode" +
           ":lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a36{border:1pt None Black;" +
           "border-bottom-style:Solid;background-color:Transparent;background-repeat:Repeat;" +
           "padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-" +
           "align:Top;color:Black;word-wrap:break-word}.a37{border:1pt None Black;border-" +
           "bottom-style:Solid;background-color:Transparent;background-repeat:Repeat;padding" +
           "-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;" +
           "font-family:Arial;font-size:9pt;font-weight:Normal;text-decoration:None;direction:" +
           "LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;color" +
           ":Black;word-wrap:break-word}.a38{border:1pt None Black;border-bottom-style:Solid" +
           ";background-color:Transparent;background-repeat:Repeat;padding-left:2pt;padding-" +
           "top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;font-family:Arial;" +
           "font-size:9pt;font-weight:Normal;text-decoration:None;direction:LTR;unicode-bidi" +
           ":Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-" +
           "wrap:break-word}.a39{border:1pt None Black;border-bottom-style:Solid;background-" +
           "color:Transparent;background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding" +
           "-right:2pt;padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;" +
           "font-weight:Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align" +
           ":Left;writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}" +
           ".a40{border:1pt None Black;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:" +
           "Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a41{" +
           "border:1pt None Black;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight" +
           ":Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a42" +
           "{border:1pt None Black;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight" +
           ":Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a43" +
           "{border:1pt None Black;border-bottom-style:Solid;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight" +
           ":Normal;text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left" +
           ";writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}.a55{border" +
           ":1pt None Black;border-bottom-style:None;background-color:Transparent;background" +
           "-repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom" +
           ":2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}" +
           ".a56{border:1pt None Black;background-color:Transparent;background-repeat:" +
           "Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:" +
           "2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}." +
           "a57{border:1pt None Black;background-color:Transparent;background-repeat:" +
           "Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom:" +
           "2pt;font-style:Normal;font-family:Arial;font-size:10pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}" +
           ".a58{border:1pt None Black;background-color:Transparent;background-repeat" +
           ":Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom" +
           ":2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}" +
           ".a59{border:1pt None Black;background-color:Transparent;background-repeat" +
           ":Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;padding-bottom" +
           ":2pt;font-style:Normal;font-family:Arial;font-size:9pt;font-weight:Normal;" +
           "text-decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}." +
           "a60{border:1pt None Black;border-bottom-style:None;background-color:" +
           "Transparent;background-repeat:Repeat;padding-left:2pt;padding-top:2pt" +
           ";padding-right:2pt;padding-bottom:2pt;font-style:Normal;font-family" +
           ":Arial;font-size:10pt;font-weight:Normal;text-decoration:None;direction" +
           ":LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical" +
           "-align:Top;color:Black;word-wrap:break-word}.a61{border:1pt None Black" +
           ";background-color:Transparent;background-repeat:Repeat;padding-left" +
           ":2pt;padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style" +
           ":Normal;font-family:Arial;font-size:9pt;font-weight:Normal;text-" +
           "decoration:None;direction:LTR;unicode-bidi:Normal;text-align:Left;" +
           "writing-mode:lr-tb;vertical-align:Top;color:Black;word-wrap:break-word}" +
           ".a62{border:1pt None Black;background-color:Transparent;background-" +
           "repeat:Repeat;padding-left:2pt;padding-top:2pt;padding-right:2pt;" +
           "padding-bottom:2pt;font-style:Normal;font-family:Arial;font-size:" +
           "10pt;font-weight:Normal;text-decoration:None;direction:LTR;unicode" +
           "-bidi:Normal;text-align:Left;writing-mode:lr-tb;vertical-align:Top;" +
           "color:Black;word-wrap:break-word}.a63{border:1pt None Black;background" +
           "-color:Transparent;background-repeat:Repeat;padding-left:2pt;padding-" +
           "top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;font-" +
           "family:Arial;font-size:9pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;word-wrap:break-word}.a87{border:1pt " +
           "None Black;border-top-style:Dotted;background-color:Transparent;" +
           "background-repeat:Repeat;padding-left:0pt;padding-top:0pt;padding-" +
           "right:0pt;padding-bottom:0pt;WIDTH:100%}.a90{border:1pt None Black;" +
           "background-color:Transparent;background-repeat:Repeat;padding-left:2pt;" +
           "padding-top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;" +
           "font-family:Arial;font-size:9pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Left;writing-mode:lr-tb;" +
           "vertical-align:Top;color:Black;}.a89{border:1pt None Black;background-" +
           "color:Transparent;background-repeat:Repeat;padding-left:2pt;padding-" +
           "top:2pt;padding-right:2pt;padding-bottom:2pt;font-style:Normal;font-" +
           "family:Arial;font-size:9pt;font-weight:Normal;text-decoration:None;" +
           "direction:LTR;unicode-bidi:Normal;text-align:Right;writing-mode:lr-" +
           "tb;vertical-align:Top;color:Black;}.r1{HEIGHT:100%;WIDTH:100%}." +
           "r2{HEIGHT:100%;WIDTH:100%;overflow:hidden}.r3{HEIGHT:100%}.r4{" +
           "border-style:none}.r5{border-left-style:none}.r6{border-right-" +
           "style:none}.r7{border-top-style:none}.r8{border-bottom-style:none}." +
           "r10{border-collapse:collapse}.r9{border-collapse:collapse;table-layout" +
           ":fixed}.r11{WIDTH:100%;overflow-x:hidden}.r12{position:absolute;display" +
           ":none;background-color:white;border:1px solid black;}.r13{text-decoration:" +
           "none;color:black;cursor:pointer;}</style>";
             //End of body tag
             var footstr = "</body></html>";
             //This the main content to get the all the html content inside the report viewer control
             //"ReportViewer1_ctl10" is the main div inside the report viewer
             //controls who helds all the tables and divs where our report contents or data is available
             var newstr = $("#VisibleReportContentReportViewer1_ctl09").;
             //open blank html for printing
             var popupWin = window.open('', '_blank');
             //paste data of printing in blank html page
             popupWin.document.write(newstr);
             //print the page and see is what you see is what you get
             popupWin.print();
             return false;
         }
         
   </script>
</html>
