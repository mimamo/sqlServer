USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_PJPTDSum_Estimate]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_PJPTDSum_Estimate]
as
Select 

Project		= a.project,
Task		= a.pjt_entity,
EAC_Amount	= sum(a.EAC_Amount)

from

pjptdsum a

where 

acct IN ('ESTIMATE', 'ESTIMATE TAX')

group by project, pjt_entity
GO
