USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Cpny_Ord_All]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Cpny_Ord_All    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_Cpny_Ord_All] @parm1 varchar ( 10), @parm2 varchar(10) as
    Select * from PurchOrd where CpnyID Like @parm1 and PONbr LIKE @parm2 Order by PONbr DESC
GO
