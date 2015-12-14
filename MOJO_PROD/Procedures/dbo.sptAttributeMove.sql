USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeMove]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeMove]

	(
		@Entity varchar(50),
		@EntityKey int,
		@AttributeKey int,
		@Direction varchar(10)
	)

AS --Encrypt

Declare @DisplayOrder int, @OtherKey int, @MaxOrder int

if @Direction = 'Up'
begin

	Select @DisplayOrder = DisplayOrder from tAttribute (nolock) Where AttributeKey = @AttributeKey
	if @DisplayOrder = 1
		return
	
	Update tAttribute Set DisplayOrder = @DisplayOrder Where DisplayOrder = @DisplayOrder -1 and Entity = @Entity and EntityKey = @EntityKey
	Update tAttribute Set DisplayOrder = @DisplayOrder -1 Where AttributeKey = @AttributeKey

end

if @Direction = 'Down'
begin

	Select @MaxOrder = Count(*) from tAttribute (nolock) Where Entity = @Entity and EntityKey = @EntityKey
	
	Select @DisplayOrder = DisplayOrder from tAttribute (nolock) Where AttributeKey = @AttributeKey
	if @DisplayOrder = @MaxOrder
		return
		
	Update tAttribute Set DisplayOrder = @DisplayOrder Where DisplayOrder = @DisplayOrder +1 and Entity = @Entity and EntityKey = @EntityKey
	Update tAttribute Set DisplayOrder = @DisplayOrder +1 Where AttributeKey = @AttributeKey

end
GO
