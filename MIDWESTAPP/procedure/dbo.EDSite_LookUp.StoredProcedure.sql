USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_LookUp]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_LookUp] @SiteId varchar(10) As
Select SiteId From Site Where SiteId = @SiteId
GO
