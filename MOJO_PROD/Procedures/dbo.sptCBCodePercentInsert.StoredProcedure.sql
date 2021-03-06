USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentInsert]
	@CBCodeKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Percentage decimal(24,4),
	@oIdentity INT OUTPUT
AS --Encrypt


Declare @TotPercent decimal(24,4)

Select @TotPercent = Sum(Percentage) From tCBCodePercent (nolock) Where Entity = @Entity and EntityKey = @EntityKey
if ISNULL(@TotPercent, 0) + @Percentage > 100
	Return -1
	
If Exists (Select * From tCBCodePercent (nolock) 
			Where Entity =	@Entity 
			And EntityKey = @EntityKey 
			And CBCodeKey = @CBCodeKey)
	Return -2	
			
	INSERT tCBCodePercent
		(
		CBCodeKey,
		Entity,
		EntityKey,
		Percentage
		)

	VALUES
		(
		@CBCodeKey,
		@Entity,
		@EntityKey,
		@Percentage
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
