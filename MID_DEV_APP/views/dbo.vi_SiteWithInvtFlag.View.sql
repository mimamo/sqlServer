USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vi_SiteWithInvtFlag]    Script Date: 12/21/2015 14:17:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vi_SiteWithInvtFlag]
AS
SELECT  
	ExistingSiteFlag = ' ',
	Invtid = null,
	Site.*

 FROM Site

union

SELECT  
	ExistingSiteFlag = 
		CASE WHEN ItemSite.SiteID IS NULL
			THEN SPACE (1) 
		ELSE
			'X'
		END,
	  ItemSite.Invtid,
	  Site.*

 FROM Site
 left outer join ItemSite
   on Site.SiteID = ItemSite.SiteID
GO
