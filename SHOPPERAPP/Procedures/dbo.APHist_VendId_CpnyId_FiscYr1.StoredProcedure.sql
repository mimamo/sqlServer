USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APHist_VendId_CpnyId_FiscYr1]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APHist_VendId_CpnyId_FiscYr1    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APHist_VendId_CpnyId_FiscYr1] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 4) As
Select * from APHist where VendId = @parm1
and CpnyId = @parm2
and FiscYr > @parm3
Order by VendId, CpnyId, FiscYr DESC
GO
