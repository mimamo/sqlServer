USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_Bat]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_Bat    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_Bat] @parm1 varchar ( 10) as
    Select * from ARTran
    where BatNbr = @parm1
    order by BatNbr, Acct, Sub
GO
