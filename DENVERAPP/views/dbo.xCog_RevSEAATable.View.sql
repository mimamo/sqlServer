USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xCog_RevSEAATable]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_RevSEAATable]
AS

-- This view is for importing access tables in the Revenue Model.
-- Base = NODATA, Remove Obsolete, Save as Revenue_SEA_Jobs File.
-- Dimension = Measure, cube = SEAPlanning, include e list.
--Updated 8/9/11 for new EList processes

Select 'Measure' as Item
	, EListItemname as EListItem
	, 'WRITE' as AccessLevel
From xCog_RevEList
Where EListItemParentName like '%SEA'
	OR EListItemName = 'SEA'
GO
