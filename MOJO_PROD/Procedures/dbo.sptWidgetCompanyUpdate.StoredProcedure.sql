USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetCompanyUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWidgetCompanyUpdate]
(
	@WidgetKey INT,
	@CompanyKey INT,
	@Settings TEXT
)

AS
	IF EXISTS(SELECT 1 FROM tWidgetCompany (NOLOCK) WHERE WidgetKey = @WidgetKey AND CompanyKey = @CompanyKey)
		UPDATE	tWidgetCompany
		SET		Settings = @Settings
		WHERE	WidgetKey = @WidgetKey 
				AND CompanyKey = @CompanyKey
	ELSE 
		INSERT tWidgetCompany (WidgetKey, CompanyKey, Settings)
		VALUES (@WidgetKey, @CompanyKey, @Settings)
GO
