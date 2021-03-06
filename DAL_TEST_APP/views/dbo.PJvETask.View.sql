USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[PJvETask]    Script Date: 12/21/2015 13:56:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PJvETask]

AS 

SELECT distinct pjpent.project, 
	 pjpent.pjt_entity,
	 pjpent.pjt_entity_desc, 
	 pjpent.mspinterface, 
	 pjpent.status_pa, 
	 pjpent.status_lb, 
	 pjpentem.employee,
	 pjpent.status_ap 

FROM pjpent left outer join pjpentem on 
	 pjpent.project = pjpentem.project and 
	 pjpent.pjt_entity = pjpentem.pjt_entity
GO
