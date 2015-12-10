USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentUpdate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentUpdate]
	@CBCodePercentKey int,
	@CBCodeKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Percentage decimal(24,4)

AS --Encrypt

Declare @TotPercent decimal(24,4)

Select @TotPercent = Sum(Percentage) From tCBCodePercent (nolock) Where Entity = @Entity and EntityKey = @EntityKey and CBCodePercentKey <> @CBCodePercentKey
if ISNULL(@TotPercent, 0) + @Percentage > 100
	Return -1
	
If Exists (Select * From tCBCodePercent (nolock) 
			Where Entity =	@Entity 
			And EntityKey = @EntityKey 
			And CBCodeKey = @CBCodeKey
			And CBCodePercentKey <> @CBCodePercentKey)
	Return -2	
	
	UPDATE
		tCBCodePercent
	SET
		CBCodeKey = @CBCodeKey,
		Entity = @Entity,
		EntityKey = @EntityKey,
		Percentage = @Percentage
	WHERE
		CBCodePercentKey = @CBCodePercentKey 

	RETURN 1
GO
