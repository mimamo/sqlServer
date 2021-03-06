USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkInsertFile]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLinkInsertFile]
  @AssociatedEntity VARCHAR(50)
 ,@EntityKey int
 ,@FileKey int
 ,@AddedBy int
 ,@ProjectKey int = null
 ,@WebDavPath varchar(2000) = null
 ,@WebDavFileName varchar(500) = null
 
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/25/12   CRG 10.5.6.0 (154738) Added ProjectKey, WebDavPath, WebDavFileName
*/

declare @ExistingLink int
 
 select @ExistingLink = LinkKey
   from tLink (nolock)
  where AssociatedEntity = @AssociatedEntity
    and EntityKey = @EntityKey
    and Type = 1
    and ((FileKey = @FileKey and @WebDavPath is null)
		or
		(ProjectKey = @ProjectKey and UPPER(WebDavPath) = UPPER(@WebDavPath)))
 
 if @ExistingLink is null
  insert tLink
        (AssociatedEntity
        ,EntityKey
        ,Type
        ,FileKey
        ,AddedBy
		,ProjectKey
		,WebDavPath
		,WebDavFileName
        )
    values (
		@AssociatedEntity
        ,@EntityKey
        ,1
        ,@FileKey
        ,@AddedBy
		,@ProjectKey
		,@WebDavPath
		,@WebDavFileName
        )
        
 return 1
GO
