USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APBal_VendId_CpnyID]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APBal_VendId_CpnyID    Script Date: 4/7/98 12:19:54 PM ******/
Create Proc [dbo].[APBal_VendId_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 15) AS
Select * from AP_Balances where CpnyID = @parm1
        and VendID = @parm2
GO
