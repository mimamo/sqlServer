USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_CpnyId]    Script Date: 12/21/2015 15:42:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_CpnyId] @SiteId varchar(10) As
Select CpnyId From Site Where SiteId = @SiteId
GO
