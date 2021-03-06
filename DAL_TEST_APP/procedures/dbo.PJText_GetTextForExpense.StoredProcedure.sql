USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJText_GetTextForExpense]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJText_GetTextForExpense]
	@ApprovalAction int,
	@DocNbr varchar(10),
	@ReportDate varchar(10),
	@Subject varchar(255) OUTPUT,
	@MsgText varchar(255) OUTPUT
	
AS
	begin

	declare @TempStr varchar(255)


	-- If it is a rejected Expense report
	if(@ApprovalAction = 2)
		begin
		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0233'
		Select @Subject = @TempStr

		--Get the message text
		Select @TempStr = msg_text from PJText where msg_num = '0605'
		Select @TempStr = replace(@TempStr,'($1)',@DocNbr)		
		Select @TempStr = replace(@TempStr,'($2)',@ReportDate)		
		Select @MsgText = @TempStr
		end

	-- If it is a delegated Expense report
	if(@ApprovalAction = 3)
		begin
		--Get the subject text
		Select @TempStr = msg_text from PJText where msg_num = '0227'
		Select @Subject = @TempStr
		end

	end
GO
