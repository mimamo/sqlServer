USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_APSetUp_PreNotes]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_APSetUp_PreNotes]
AS
	-- Do any Accounts require prenotes?
	if exists(	SELECT 	B.Acct
			FROM 	xddbank B (nolock) left outer join xddfileformat F (nolock)
				On B.FormatID = F.FormatID, xddsetup S (nolock)
			WHERE 	F.Prenote = 1	-- FileFormat requires prenotes
				-- Either Getting defaults from Setup and Setup Requires prenotes or
				-- Not getting from Setup and Company Paying Account requires prenotes
				and ((S.Achprenote = 'Y' and B.filefromsetup = 1)
				or (B.achprenote = 'Y' and B.filefromsetup = 0))
		)

		-- If One XDDBank record requires AP PreNotes, now check if A/P Dflt Checking has been setup
		-- Now find out if one Company Paying Account is the Default Chkg account
		-- If it doesn't exist, then return the APSetup record to put in user message
			if exists(SELECT B.acct
				FROM 	xddbank B (nolock), apsetup A (nolock)
				WHERE 	B.acct = A.ChkAcct and B.sub = A.ChkSub)
				-- Return empty record
				SELECT 	*
				FROM 	apsetup (nolock)
				WHERE 	SetupID = ''
			else
				-- APSetup for message
				SELECT	* from APSetup (nolock)
GO
