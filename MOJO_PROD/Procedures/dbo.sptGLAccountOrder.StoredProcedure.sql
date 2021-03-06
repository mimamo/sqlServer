USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountOrder]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountOrder]

	(
		@CompanyKey int,
		@ParentAccountKey int,
		@CurrentOrder int,
		@CurrentLevel int
	)

AS --Encrypt

Declare @CurKey int
Declare @Rollup tinyint
Declare @CurAcctNum varchar(100)
Declare @ChildCount int
Select @CurrentLevel = @CurrentLevel + 1
Select @CurAcctNum = ''

While 1=1
BEGIN

	Select @CurAcctNum = Min(AccountNumber)
		From tGLAccount (nolock)
		Where	CompanyKey = @CompanyKey
		and		ISNULL(ParentAccountKey, 0) = @ParentAccountKey
		and		AccountNumber > @CurAcctNum
		
	if @CurAcctNum is null
		break
	
	Select @CurrentOrder = @CurrentOrder + 1
	
	Select @CurKey = GLAccountKey, @Rollup = ISNULL(Rollup, 0)
	from tGLAccount (nolock) 
	Where	CompanyKey = @CompanyKey and
			AccountNumber = @CurAcctNum
	
	Update tGLAccount
	Set 
		DisplayOrder = @CurrentOrder,
		DisplayLevel = @CurrentLevel
	Where
		CompanyKey = @CompanyKey and
		AccountNumber = @CurAcctNum
	
	if @Rollup = 1
	BEGIN
		Select @ChildCount = Count(GLAccountKey) from tGLAccount (nolock) Where ParentAccountKey = @CurKey
		if ISNULL(@ChildCount, 0) > 0
			exec @CurrentOrder = sptGLAccountOrder @CompanyKey, @CurKey, @CurrentOrder, @CurrentLevel

	END
	
END

Return @CurrentOrder
GO
