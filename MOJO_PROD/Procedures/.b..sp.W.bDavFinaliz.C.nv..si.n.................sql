USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFinalizeConversion]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFinalizeConversion]
	@CompanyKey int
AS

/*
|| When      Who Rel      What
|| 4/10/13   CRG 10.5.6.6 Created as a centralized SP for the conversion program to call
*/

	EXEC sptWebDavFileConvert @CompanyKey
GO
