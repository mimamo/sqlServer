USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_ShipNow]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_ShipNow] @SiteId varchar(10) As
Select S4Future09 From Site Where SiteId = @SiteId
GO
