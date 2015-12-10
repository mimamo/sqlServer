USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetDelete]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptWidgetDelete]
(
	@widgetKey INT,
	@companyKey INT
)

AS

	DELETE	tWidget
	WHERE	WidgetKey = @widgetKey
			AND CompanyKey = @companyKey

	DELETE	ws
	FROM	tWidgetSecurity ws
	WHERE	ws.WidgetKey = @widgetKey
			AND EXISTS (SELECT	* 
						FROM	tSecurityGroup 
						WHERE	SecurityGroupKey = ws.SecurityGroupKey
								AND CompanyKey = @companyKey)
GO
