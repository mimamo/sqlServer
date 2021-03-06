USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xCog_RevSEATravelATable]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xCog_RevSEATravelATable]
AS

-- This view is for importing access tables in the Revenue Model.
-- Base = No Data, Remove Obsolete, Save as Revenue_OOS_Jobs File.
-- Dimension = TravelExpTypes, cube = SEATravelPlanning, include e list.


Select xCog_AccessTables.ItemName as Item
	, EListItemname as EListItem
	, xCog_AccessTables.AccessLevel as AccessLevel
From xCog_RevEList x Cross Join xCog_AccessTables 
Where (EListItemParentName like '%SEA'
	OR EListItemName = 'SEA' )
	AND Dlist = 'TravelExpTypes'
GO
