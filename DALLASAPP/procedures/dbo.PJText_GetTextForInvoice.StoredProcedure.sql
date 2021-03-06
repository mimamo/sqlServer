USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJText_GetTextForInvoice]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJText_GetTextForInvoice]
	@ApprovalAction int,
	@DraftNbr varchar(10),
	@Project varchar(16),
	@Subject varchar(255) OUTPUT,
	@MsgText varchar(255) OUTPUT
	
AS
	begin

	declare @TempStr varchar(255)


	-- If it is a rejected Invoice
	if(@ApprovalAction = 2)
		begin
		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0660'
		Select @TempStr = replace(@TempStr,'($1)',@DraftNbr)		
		Select @Subject = @TempStr

		--Get the message text
		Select @TempStr = msg_text from PJText where msg_num = '0643'
		Select @TempStr = replace(@TempStr,'($1)',@Project)		
		Select @MsgText = @TempStr
		end

	-- If it is a delegated Invoice
	if(@ApprovalAction = 3)
		begin
		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0636'
		Select @TempStr = replace(@TempStr,'($1)',@DraftNbr)		
		Select @Subject = @TempStr

		--Get the message text
		Select @TempStr = msg_text from PJText where msg_num = '0643'
		Select @TempStr = replace(@TempStr,'($1)',@Project)		
		Select @MsgText = @TempStr
		end

	end
GO
