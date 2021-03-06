USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormCloseForm]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormCloseForm]
 (
  @FormKey int
 )
AS --Encrypt

Declare @Author int, @ReasignToAuthor tinyint, @FormDefKey int, @AssignedTo int

Select 
	@FormDefKey = FormDefKey, 
	@Author = Author, 
	@AssignedTo = AssignedTo
from tForm (nolock) Where FormKey = @FormKey

Select @ReasignToAuthor = OnlyAuthorCanClose from tFormDef (nolock) Where FormDefKey = @FormDefKey


If (@ReasignToAuthor = 1) and (@AssignedTo <> @Author)
	UPDATE 
	tForm
	SET 
	AssignedTo = @Author
	WHERE 
	FormKey = @FormKey
else
	UPDATE 
	tForm
	SET 
	DateClosed = GETDATE()
	WHERE 
	FormKey = @FormKey
GO
