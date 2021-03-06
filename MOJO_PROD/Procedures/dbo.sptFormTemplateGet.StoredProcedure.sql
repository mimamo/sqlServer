USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormTemplateGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormTemplateGet]

	 @CompanyKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@FormID varchar(50)

AS --Encrypt

	-- find the template for the entity if it exists
	if exists(select 1 from tFormTemplate (nolock)
	           where CompanyKey = @CompanyKey
	           and Entity = @Entity
	           and EntityKey = @EntityKey
	           and FormID = @FormID)
		select * from tFormTemplate (nolock)
		where CompanyKey = @CompanyKey
	          and Entity = @Entity
	          and EntityKey = @EntityKey
	          and FormID = @FormID
	else
		-- cannot find it for entity, return company level default
		select * from tFormTemplate (nolock)
		where CompanyKey = @CompanyKey
	          and Entity = 'company'
	          and FormID = @FormID
	
	return 1
GO
