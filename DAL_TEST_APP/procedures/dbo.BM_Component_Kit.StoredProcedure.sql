USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_Component_Kit]    Script Date: 12/21/2015 13:56:54 ******/
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
