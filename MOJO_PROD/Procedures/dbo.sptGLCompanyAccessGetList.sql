USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyAccessGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyAccessGetList]
	(
	@CompanyKey int,
	@Entity1 varchar(50) = null,
	@Entity2 varchar(50) = null,
	@Entity3 varchar(50) = null,
	@Entity4 varchar(50) = null,
	@Entity5 varchar(50) = null
	)
AS --Encrypt

/*
|| When     Who Rel       What
|| 06/07/12 GHL 10.5.5.6  Created for validations on flex transaction screens
|| 06/28/12 GHL 10.5.5.7  Added multiple Entity parameters so that we can pick and choose and reduce the # of records
*/
	SET NOCOUNT ON

	declare @AllEntities int
	if @Entity1 is null and @Entity2 is null and @Entity3 is null and @Entity4 is null and @Entity5 is null
		select @AllEntities = 1
	else
		select @AllEntities = 0
	
	if  @AllEntities = 1 
		select * from tGLCompanyAccess (nolock) where CompanyKey = @CompanyKey
	else
		select * from tGLCompanyAccess (nolock) where CompanyKey = @CompanyKey 
		and Entity in (@Entity1,@Entity2,@Entity3,@Entity4,@Entity5) 

	RETURN 1
GO
