USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APBal_VendID_MDB]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APBal_VendID_MDB    Script Date: 4/7/98 12:19:54 PM ******/
Create Proc [dbo].[APBal_VendID_MDB] @parm1 varchar ( 15) AS
Select * from AP_Balances where VendID = @parm1
        order by CpnyID, VendID
GO
