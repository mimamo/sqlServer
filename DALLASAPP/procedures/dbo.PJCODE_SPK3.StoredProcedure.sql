USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_SPK3]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_SPK3]  
		    @Guid As UNIQUEIDENTIFIER,
		    @code_type as char(4)
as
BEGIN
	SET NOCOUNT ON

	DECLARE @PJCode_cursor cursor
	DECLARE @seq int
	DECLARE @code_value varchar(30)
	DECLARE @code_value_desc varchar(30)
	
	SET @seq = 0

	SET @PJCode_cursor = CURSOR FOR
	select code_value, code_value_desc from PJCODE
	where    code_type = @code_type
	order by code_type, code_value

	OPEN @PJCode_cursor



	FETCH NEXT FROM @PJCode_cursor INTO @code_value, @code_value_desc
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO StoredProcedureResultSet (ID, SequenceNumber, Body)
			VALUES (@Guid, @seq, '<PJCode><CodeType>'+RTRIM(@code_type)+'</CodeType><CodeValue>'+RTRIM(@code_value)+'</CodeValue><CodeValueDesc>'+dbo.XMLEncode(RTRIM(@code_value_desc))+'</CodeValueDesc></PJCode>')			

			SET @seq = @seq + 1
			FETCH NEXT FROM @PJCode_cursor INTO @code_value, @code_value_desc
		END	


	CLOSE @PJCode_cursor
	DEALLOCATE @PJCode_cursor
	
END
GO
