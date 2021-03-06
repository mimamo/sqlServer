USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormTemplateUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormTemplateUpdate]

	 @CompanyKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@FormID varchar(50)
	,@FormTemplate text
	,@oIdentity int output

AS --Encrypt

	-- find the template for the entity, if it exists update it
	if exists(select 1 from tFormTemplate (nolock)
	           where CompanyKey = @CompanyKey
	           and Entity = @Entity
	           and EntityKey = @EntityKey
	           and FormID = @FormID)
		update tFormTemplate
		set FormTemplate = @FormTemplate
	    where CompanyKey = @CompanyKey
	    and Entity = @Entity
	    and EntityKey = @EntityKey
	    and FormID = @FormID
	else
		-- cannot find it for entity, add it
		insert tFormTemplate
			(
			 CompanyKey
			,Entity
			,EntityKey
			,FormID
			,FormTemplate
			)
		values
			(
			 @CompanyKey
			,@Entity
			,@EntityKey
			,@FormID
			,@FormTemplate
			)
	
	select @oIdentity = @@IDENTITY
	
	return 1
GO
