USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_Component_Kit]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM_Component_Kit] @KitId varchar (30) as
    Select * from Component where
	KitId = @KitId and
	KitSiteId = ''
    Order by CmpnentId
GO
