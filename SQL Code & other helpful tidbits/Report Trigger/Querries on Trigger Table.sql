-- get list of reports that were run by company and who ran them
select businessDate,ReportDate,Userid,computername,CPNYID,RI_Report,Reportname,ReportFormat,reportNbr  FROM  xRptRuntimeAudit 

-- number of times each report was run with name
select distinct ReportName, RI_Report, COUNT(*) as NumberofTimesRun from xrptruntimeaudit group by reportname, RI_Report order by ReportName

-- number of times each report was run
select distinct ReportName, COUNT(*) as NumberofTimesRun from xrptruntimeaudit group by reportname

