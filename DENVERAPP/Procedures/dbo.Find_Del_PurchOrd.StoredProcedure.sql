USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Find_Del_PurchOrd]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Find_Del_PurchOrd    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[Find_Del_PurchOrd] @parm1 varchar ( 6) as
    Select * from PurchOrd
            where (PurchOrd.PerClosed <= @parm1 and PurchOrd.PerClosed <> '')
GO
