USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APHist_VendId_FiscYr]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APHist_VendId_FiscYr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APHist_VendId_FiscYr] @parm1 varchar ( 15), @parm2 varchar ( 4) As
Select * from APHist where VendId = @parm1
and FiscYr < @parm2
Order by VendId DESC, FiscYr DESC
GO
