USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_940Label]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSite_940Label] @SiteId varchar(10) As
Select SiteId, LabelCapable From EDSite Where SiteId = @SiteId And Trans = '940'
GO
