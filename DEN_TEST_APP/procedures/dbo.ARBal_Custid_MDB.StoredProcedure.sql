USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARBal_Custid_MDB]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARBal_Custid_MDB    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARBal_Custid_MDB] @parm1 varchar ( 15) AS
Select * from AR_Balances where CustID = @parm1
        order by CpnyID, CustID
GO
