USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyMapDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyMapDelete]
	@GLCompanyMapKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/26/12  MFT 10.554  Created
*/

DELETE
FROM tGLCompanyMap
WHERE GLCompanyMapKey = @GLCompanyMapKey
GO
