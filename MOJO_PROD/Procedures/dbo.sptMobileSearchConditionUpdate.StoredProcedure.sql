USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchConditionUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchConditionUpdate]
	@MobileSearchConditionKey int,
	@MobileSearchKey int,
	@FieldName varchar(200),
	@Condition varchar(100),
	@Value1 varchar(500),
	@Value2 varchar(500)

AS

IF @MobileSearchConditionKey <= 0
BEGIN

	INSERT tMobileSearchCondition
		(
		MobileSearchKey,
		FieldName,
		Condition,
		Value1,
		Value2
		)

	VALUES
		(
		@MobileSearchKey,
		@FieldName,
		@Condition,
		@Value1,
		@Value2
		)
		Select @MobileSearchConditionKey = @@IDENTITY
END
ELSE
BEGIN
	UPDATE
		tMobileSearchCondition
	SET
		FieldName = @FieldName,
		Condition = @Condition,
		Value1 = @Value1,
		Value2 = @Value2
	WHERE
			MobileSearchConditionKey = @MobileSearchConditionKey 

END

return @MobileSearchConditionKey
GO
