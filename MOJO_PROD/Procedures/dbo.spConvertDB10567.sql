USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10567]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10567]
AS

	Update tVoucher Set InvoiceDate = dbo.fFormatDateNoTime(InvoiceDate) Where DATEPART(hh, InvoiceDate) > 0
    Update tVoucher Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(hh, PostingDate) > 0

-- if user has the right to view Project setup give them right to view project setup accounting tab
		
	Declare @CurKey int

	Select @CurKey = -1

	While 1=1
	begin
	 Select @CurKey = Min(EntityKey) from tRightAssigned (nolock) Where EntityKey > @CurKey and RightKey = 90200 and EntityType = 'Security Group'
	 if @CurKey is null
	  Break

	INSERT tRightAssigned
	  (
	  EntityType,
	  EntityKey,
	  RightKey
	  )
	SELECT 'Security Group',@CurKey,90924


	end
	
-- Fix for missing Reference on Time Sheets in the actionLog
	
	
	Declare @CurKey2 int
	Declare @UserKey int
	Declare @UserName varchar(300)

	Select @CurKey2 = -1
	While 1=1
	begin
	 Select @CurKey2 = Min(EntityKey) from tActionLog Where EntityKey > @CurKey2 and Entity = 'Time Sheet' and Reference = '' and EntityKey > 0
	 if @CurKey2 is null
	  Break
		select @UserKey = ISNULL(UserKey, 0) from tTimeSheet (nolock) where TimeSheetKey = @CurKey2
 
		if @UserKey > 0
			BEGIN
			select @UserName = ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') from tUser (nolock) where UserKey = @UserKey
		
			update tActionLog Set Reference = @UserName where Entity = 'Time Sheet' and Reference = '' and EntityKey = @CurKey2
		
			END


	end




	update tActionLog set Entity = 'Time Sheet' where Entity = 'TimeSheet'
GO
