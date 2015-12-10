USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeInsert]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeInsert]
	@CompanyKey int,
	@Outcome varchar(200),
	@PositiveOutcome tinyint = 0, --Optional because of CMP90
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/30/09   CRG 10.5.0.0 Added PositiveOutcome
|| 06/24/14  GHL 10.5.8.1 Added checking of duplicate outcome
*/

	if exists (select 1 from tLeadOutcome (nolock)
				where CompanyKey = @CompanyKey
				and upper(ltrim(rtrim(Outcome))) = upper(ltrim(rtrim(@Outcome)))
				)
				return -1  
	
	 
	INSERT tLeadOutcome
		(
		CompanyKey,
		Outcome,
		PositiveOutcome
		)

	VALUES
		(
		@CompanyKey,
		@Outcome,
		@PositiveOutcome
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
