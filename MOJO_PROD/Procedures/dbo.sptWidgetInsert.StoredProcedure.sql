USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptWidgetInsert]
(
	@companyKey			INT,
	@displayName		VARCHAR(50),
	@description		VARCHAR(500),
	@userEdit			INT, 
	@height				INT, 
	@width				INT,
	@resize				INT,
	@settings			VARCHAR(500),
	@file				VARCHAR(75)
)

AS
/*
|| When      Who Rel	    What
|| 04/30/08  QMD 10.0.0.2   Added 
|| 007/01/08 GWG 10.004     Added min key handling (10000)
*/

	DECLARE @widgetKey INT
	DECLARE @filePath VARCHAR(200)
	DECLARE @fileLocation VARCHAR(200)

	SELECT @widgetKey = MAX(WidgetKey) + 1 FROM tWidget (NOLOCK)
	if @widgetKey < 10000
		Select @widgetKey = 10000

	INSERT INTO tWidget (WidgetKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings,UserEdit, HasSettings, Height, Width, CompanyKey, CanResize)
	VALUES  (@widgetKey, @displayName, @description, 'main', 0, 'OtherSWFLoader.swf', 'widgetOther', REPLACE(@settings, @file, CONVERT(VARCHAR(10),@widgetKey) + '.swf') , @userEdit, 0, @height, @width, @companyKey, @resize)

	SELECT 	@widgetKey as widgetKey, REPLACE(@settings, @file, CONVERT(VARCHAR(10),@widgetKey) + '.swf') as settings--, @filePath as filePath
GO
