USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJText_GetTextForTime]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJText_GetTextForTime]
	@ApprovalAction int,
	@DocNbr varchar(10),
	@WEDate smalldatetime,
	@sWEDate varchar(10),
	@Subject varchar(255) OUTPUT,
	@MsgText varchar(800) OUTPUT
	
AS
	begin

	declare @TempStr varchar(800)
	declare @Employee varchar(10)
	declare @CommentKV varchar(64)
	declare @Notes1 varchar(255)


	-- If it is a rejected Timecard
	if(@ApprovalAction = 2)
		begin

		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0030'
		Select @Subject = @TempStr

		--Check if Notes exists for this timecard, if it does, get the last entered
		SELECT @Employee = employee from PJLabHdr where DocNbr = @DocNbr
		SELECT @CommentKV = RTrim(@Employee) + ' ' + Replace(CONVERT(varchar(10),@WEDate,101),'/','') 
		if exists(SELECT * from PJNOTES WHERE note_type_cd = 'TIME' and key_value = @CommentKV)
			BEGIN
 			--Get the last notes1 entered for this timecard
			SELECT @Notes1 = Notes1 from PJNOTES WHERE note_type_cd = 'TIME' and key_value = @CommentKV ORDER BY note_type_cd, key_value, key_index

			--Get the message text
			Select @TempStr = msg_text from PJText where msg_num = '0577'
			Select @TempStr = replace(@TempStr,'($1)',@DocNbr)		
			Select @TempStr = replace(@TempStr,'($2)',@sWEDate)		
			Select @TempStr = replace(@TempStr,'($3)',@Notes1)		
			Select @MsgText = @TempStr

			END
		else
			BEGIN
			--Get the message text
			Select @TempStr = msg_text from PJText where msg_num = '0576'
			Select @TempStr = replace(@TempStr,'($1)',@DocNbr)		
			Select @TempStr = replace(@TempStr,'($2)',@sWEDate)		
			Select @MsgText = @TempStr
			END
		end

	-- If it is a delegated Timecard
	if(@ApprovalAction = 3)
		begin
		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0028'
		Select @Subject = @TempStr
		end

	end
GO
