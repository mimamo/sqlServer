USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Venditem_InvtID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Venditem_InvtID                                          ******/
Create proc [dbo].[Venditem_InvtID] @parm1 varchar(30) as
	select * from VendItem where InvtID like @parm1
	order by InvtID, SiteID, VendID, FiscYr
GO
