USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSiteExt_AllDMG]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSiteExt_AllDMG] @SiteId varchar(10) As
Select * From EDSiteExt Where SiteId = @SiteId
GO
