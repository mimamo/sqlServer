USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_LookUp]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_LookUp] @SiteId varchar(10) As
Select SiteId From Site Where SiteId = @SiteId
GO
