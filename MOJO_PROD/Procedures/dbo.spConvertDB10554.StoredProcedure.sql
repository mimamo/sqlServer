USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10554]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10554]

AS


Update tPreference Set DefaultGLCompanySource = 0
Update tProject Set GLCompanySource = 0
GO
