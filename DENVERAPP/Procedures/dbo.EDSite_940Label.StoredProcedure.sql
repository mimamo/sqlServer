USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_940Label]    Script Date: 12/21/2015 15:42:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSite_940Label] @SiteId varchar(10) As
Select SiteId, LabelCapable From EDSite Where SiteId = @SiteId And Trans = '940'
GO
