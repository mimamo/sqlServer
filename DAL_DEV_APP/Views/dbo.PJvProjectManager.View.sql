USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[PJvProjectManager]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PJvProjectManager]
AS
SELECT     dbo.PJPROJ.project, dbo.PJPROJ.manager1 AS PM01, dbo.PJEMPLOY.emp_name AS PM01_Name, 'PM1' as manager
FROM         dbo.PJPROJ INNER JOIN
                      dbo.PJEMPLOY ON dbo.PJPROJ.manager1 = dbo.PJEMPLOY.employee
GO
