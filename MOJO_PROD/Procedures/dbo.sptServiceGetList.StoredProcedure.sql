USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceGetList]
 @CompanyKey int
AS --Encrypt
 SELECT 
	ServiceKey, Description, ServiceCode
 FROM tService (NOLOCK) 
 WHERE
  CompanyKey = @CompanyKey and Active = 1
 Order By
  Description
 RETURN 1
GO
