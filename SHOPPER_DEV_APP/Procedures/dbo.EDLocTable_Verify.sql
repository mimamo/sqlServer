USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLocTable_Verify]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLocTable_Verify] @SiteId varchar(10), @WhseLoc varchar(10) As
Select Count(*) From LocTable Where SiteId = @SiteId And WhseLoc = @WhseLoc
GO
