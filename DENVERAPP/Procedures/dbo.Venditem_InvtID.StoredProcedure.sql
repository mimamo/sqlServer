USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Venditem_InvtID]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Venditem_InvtID                                          ******/
Create proc [dbo].[Venditem_InvtID] @parm1 varchar(30) as
	select * from VendItem where InvtID like @parm1
	order by InvtID, SiteID, VendID, FiscYr
GO
