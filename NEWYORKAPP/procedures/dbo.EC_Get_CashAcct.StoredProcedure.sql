USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EC_Get_CashAcct]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EC_Get_CashAcct    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[EC_Get_CashAcct] @parm1 varchar ( 1) as
Select * From CashAcct
Where AcctType =  @parm1
Order by acctnbr
GO
