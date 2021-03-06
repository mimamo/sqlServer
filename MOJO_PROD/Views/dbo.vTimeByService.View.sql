USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTimeByService]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View vTimeByService    Script Date: 10/3/01 10:46:14 AM ******/
CREATE VIEW [dbo].[vTimeByService]
AS
SELECT tTime.ProjectKey, tService.ServiceCode, 
    tService.Description, SUM(tTime.ActualHours) AS ActualHours, 
    SUM(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) 
    AS ActualTotal
FROM tTime INNER JOIN
    tService ON tTime.ServiceKey = tService.ServiceKey
GROUP BY tTime.ProjectKey, tService.ServiceCode, 
    tService.Description
GO
