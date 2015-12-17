USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Open_Vendid]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Open_Vendid    Script Date: 4/16/98 7:50:26 PM ******/
Create proc [dbo].[PurchOrd_Open_Vendid] @parm1 varchar ( 15) as
        Select * from purchord where
                purchord.vendid = @parm1
                and (purchord.status = 'P' or
                purchord.status = 'O' or
                purchord.status = 'C')
                order by purchord.vendid
GO
