USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WOAcctCategXRef_WIPAcct]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_WOAcctCategXRef_WIPAcct]
	@GLAcct	varchar(10)
AS
	select		X.WIPAcct_Mfg, X.WIPAcct_NonMfg
	from		Account GLA LEFT OUTER JOIN PJ_Account PA
				ON PA.gl_acct = GLA.Acct
				LEFT OUTER JOIN WOAcctCategXRef X
				ON X.Acct = PA.Acct
	Where		GLA.Active = 1 and
				GLA.Acct LIKE @GLAcct and
				(X.WIPAcct_Mfg <> '' or X.WIPAcct_NonMfg <> '')
GO
