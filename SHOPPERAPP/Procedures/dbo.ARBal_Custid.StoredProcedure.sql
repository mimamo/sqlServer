USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARBal_Custid]    Script Date: 12/21/2015 16:13:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARBal_Custid    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARBal_Custid] @parm1 varchar ( 15), @parm2 varchar ( 10) AS
Select * from AR_Balances where CustID = @parm1
        and CpnyId like @parm2
        order by CpnyID, CustID
GO
