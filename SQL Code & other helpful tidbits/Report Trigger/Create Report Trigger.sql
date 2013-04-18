----create trigger on rptruntime table in system db.  the tigger will right records to xRptRunTimeAudit table

--run on SL system database


CREATE Trigger xRptRunAudit on rptruntime for insert as

begin

insert into xrptruntimeAudit

SELECT [AccessNbr]
      ,[Acct]
      ,[Banner]
      ,[BatNbr]
      ,[BegPerNbr]
      ,[BusinessDate]
      ,[CmpnyName]
      ,[ComputerName]
      ,[CpnyID]
      ,[DatabaseName]
      ,[DocNbr]
      ,[EndPerNbr]
      ,[LongAnswer00]
      ,[LongAnswer01]
      ,[LongAnswer02]
      ,[LongAnswer03]
      ,[LongAnswer04]
      ,[NotesOn]
      ,[PerNbr]
      ,''
      ,''
      ,[ReportDate]
      ,[ReportFormat]
      ,[ReportName]
      ,[ReportNbr]
      ,[ReportTitle]
      ,[RI_BEGPAGE]
      ,[RI_CHKTIME]
      ,[RI_COPIES]
      ,[RI_DATADIR]
      ,[RI_DICTDIR]
      ,''
      ,''
      ,[RI_DISPERR]
      ,[RI_ENDPAGE]
      ,[RI_ID]
      ,[RI_INCLUDE]
      ,[RI_LIBRARY]
      ,[RI_NOESC]
      ,[RI_OUTAPPN]
      ,[RI_OUTFILE]
      ,[RI_PRINTER]
      ,[RI_REPLACE]
      ,[RI_REPORT]
      ,[RI_STATUS]
      ,[RI_TEST]
      ,[RI_WHERE]
      ,[RI_WPORT]
      ,[RI_WPTR]
      ,[RI_WTITLE]
      ,[SegCustMask]
      ,[SegCustTitle]
      ,[SegInvenMask]
      ,[SegInvenTitle]
      ,[SegSubMask]
      ,[SegSubTitle]
      ,[SegVendMask]
      ,[SegVendTitle]
      ,[ShortAnswer00]
      ,[ShortAnswer01]
      ,[ShortAnswer02]
      ,[ShortAnswer03]
      ,[ShortAnswer04]
      ,[Sub]
      ,[SystemDate]
      ,[SystemTime]
      ,[UserId]
      ,null
  FROM inserted

  end



