USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_PurchOrd]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_PurchOrd    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[Delete_PurchOrd] @parm1 varchar ( 6) as
    Select * from PurchOrd where
                (PerClosed <= @parm1 and PerClosed <> '')
        Order by PONbr
GO
