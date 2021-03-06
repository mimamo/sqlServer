USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecMove]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecMove]

	(
		@RequestDefSpecKey int,
		@Direction varchar(10)
	)

AS --Encrypt

Declare @RequestDefKey int
Declare @DisplayOrder int
Declare @MoveKey int

If @Direction = 'Up'
BEGIN

Select @DisplayOrder = DisplayOrder, @RequestDefKey = RequestDefKey from tRequestDefSpec (NOLOCK) Where RequestDefSpecKey = @RequestDefSpecKey
Select @MoveKey = RequestDefSpecKey from tRequestDefSpec (NOLOCK) Where RequestDefKey = @RequestDefKey and DisplayOrder = @DisplayOrder - 1

if @MoveKey is null
	return -1
	
Update tRequestDefSpec Set DisplayOrder = @DisplayOrder - 1 Where RequestDefSpecKey = @RequestDefSpecKey
Update tRequestDefSpec Set DisplayOrder = @DisplayOrder Where RequestDefSpecKey = @MoveKey

END


If @Direction = 'Down'
BEGIN

Select @DisplayOrder = DisplayOrder, @RequestDefKey = RequestDefKey from tRequestDefSpec (NOLOCK) Where RequestDefSpecKey = @RequestDefSpecKey
Select @MoveKey = RequestDefSpecKey from tRequestDefSpec (NOLOCK) Where RequestDefKey = @RequestDefKey and DisplayOrder = @DisplayOrder + 1

if @MoveKey is null
	return -1
	
Update tRequestDefSpec Set DisplayOrder = @DisplayOrder + 1 Where RequestDefSpecKey = @RequestDefSpecKey
Update tRequestDefSpec Set DisplayOrder = @DisplayOrder Where RequestDefSpecKey = @MoveKey

END
GO
