USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA930_BilHistSum]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_BilHistSum]
as
Select 

RI_ID 		= a.ri_id,
Payment		= sum(a.payment),
Project		= a.project

from

xvr_PA930_BilHist a

where a.type = 'CA'

group by a.ri_id, a.project
GO
