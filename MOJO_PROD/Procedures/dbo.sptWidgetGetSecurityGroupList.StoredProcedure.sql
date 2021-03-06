USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetGetSecurityGroupList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWidgetGetSecurityGroupList]
	@UserKey int,
	@WidgetKey int = null
AS

  /*
  || When     Who Rel      What
  || 05/27/08 GHL WMJ10    Corrected Order By   
  || 06/09/08 QMD 10.0.0.2 Added Widget Description
  */

-- Keep This

SELECT 	sg.SecurityGroupKey, sg.GroupName, sg.CompanyKey, DisplayName='' ,WidgetKey = 0, CanView = 0 , CanEdit = 0, [Description] = ''
FROM	tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.CompanyKey = sg.CompanyKey						
WHERE	u.UserKey = @UserKey
		AND sg.Active = 1

UNION 
	
SELECT	a.SecurityGroupKey, a.GroupName, a.CompanyKey, a.DisplayName, a.WidgetKey, ISNULL(b.CanView, 0) as CanView, ISNULL(b.CanEdit, 0) as CanEdit, a.Description
FROM	(SELECT 	sg.*, w.WidgetKey, w.DisplayName, w.Description
		 FROM		tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.CompanyKey = sg.CompanyKey
									INNER JOIN tWidget w (NOLOCK) ON (sg.CompanyKey = w.CompanyKey OR w.CompanyKey IS NULL)		
		 WHERE		u.UserKey = @UserKey
					AND sg.Active = 1) a

		LEFT JOIN 

		(SELECT ws.SecurityGroupKey, ws.WidgetKey, ISNULL(ws.CanView, 0) as CanView, ISNULL(ws.CanEdit, 0) as CanEdit
		 FROM	tWidgetSecurity ws (NOLOCK) 
		) b ON a.SecurityGroupKey = b.SecurityGroupKey AND a.WidgetKey = b.WidgetKey

ORDER BY DisplayName
GO
