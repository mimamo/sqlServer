USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_PI]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_PI    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[ItemSite_PI] @Parm1 VarChar(10) as
   Update ItemSite set selected = 1, CountStatus = 'P'
   Where SiteID = @Parm1
   and CountStatus = 'A'
GO
