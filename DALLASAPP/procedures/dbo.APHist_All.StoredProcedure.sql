USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APHist_All]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APHist_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APHist_All] @parm1 varchar ( 15), @parm2 varchar ( 4) as
Select * from APHist where VendId like @parm1
and FiscYr like @parm2
order by VendId,FiscYr
GO
