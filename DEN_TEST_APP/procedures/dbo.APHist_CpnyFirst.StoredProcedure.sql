USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APHist_CpnyFirst]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APHist_CpnyFirst] @parm1 varchar ( 15), @parm2 varchar ( 4)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
Select * from APHist where VendId like @parm1
and FiscYr like @parm2
order by VendId,
case when exists(Select * from vs_Access
where ScrnNbr='03271' and CompanyID=APHist.CpnyID and InternetAddress=host_name()) then '' else CpnyID end,
FiscYr
GO
