USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_CpnyID_OrdNbr_D]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_CpnyID_OrdNbr_D    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_CpnyID_OrdNbr_D] @parm1 varchar ( 10), @parm2 varchar(10) as
    Select * from PurchOrd where CpnyID = @parm1 and PONbr LIKE @parm2 Order by PONbr
GO
