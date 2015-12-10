USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDetailInsert]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDetailInsert]
	@JournalEntryKey int,
	@GLAccountKey int,
	@ClassKey int,
	@ClientKey int,
	@ProjectKey int,
	@Memo varchar(500),
	@DebitAmount money,
	@CreditAmount money,
	@OfficeKey int,
	@DepartmentKey int,
	@TargetGLCompanyKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/17/07 BSH 8.5   (9659)Insert OfficeKey, DepartmentKey
|| 03/27/12 MFT 10.554 Added TargetGLCompanyKey
*/

if @ProjectKey is not null and @ClientKey is null
	Select @ClientKey = ClientKey from tProject (nolock) Where ProjectKey = @ProjectKey
	
	INSERT tJournalEntryDetail
		(
		JournalEntryKey,
		GLAccountKey,
		ClassKey,
		ClientKey,
		ProjectKey,
		Memo,
		DebitAmount,
		CreditAmount,
		OfficeKey,
		DepartmentKey,
		TargetGLCompanyKey
		)

	VALUES
		(
		@JournalEntryKey,
		@GLAccountKey,
		@ClassKey,
		@ClientKey,
		@ProjectKey,
		@Memo,
		@DebitAmount,
		@CreditAmount,
		@OfficeKey,
		@DepartmentKey,
		@TargetGLCompanyKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
