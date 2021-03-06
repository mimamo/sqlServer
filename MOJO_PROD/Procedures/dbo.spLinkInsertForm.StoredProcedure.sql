USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLinkInsertForm]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLinkInsertForm]
  @AssociatedEntity VARCHAR(50)
 ,@EntityKey int
 ,@FormKey int
 ,@AddedBy int
AS --Encrypt
declare @ExistingLink int
 
 select @ExistingLink = LinkKey
   from tLink (nolock)
  where AssociatedEntity = @AssociatedEntity
    and EntityKey = @EntityKey
    and Type = 3
    and FormKey = @FormKey
 
 if @ExistingLink is null
  insert tLink
        (AssociatedEntity
        ,EntityKey
        ,Type
        ,FormKey
        ,AddedBy
        )
    values (
      @AssociatedEntity
        ,@EntityKey
        ,3
        ,@FormKey
        ,@AddedBy
        )
        
 return 1
GO
