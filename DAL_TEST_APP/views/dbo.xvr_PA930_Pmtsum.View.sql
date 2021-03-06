USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_Pmtsum]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_Pmtsum]
as
Select 

RI_ID 		= a.ri_id,
Amount		= sum(a.amount),
Discount	= sum(a.discount),
Project		= a.project

from

xvr_PA930_PmtDet a

group by a.ri_id, a.project
GO
