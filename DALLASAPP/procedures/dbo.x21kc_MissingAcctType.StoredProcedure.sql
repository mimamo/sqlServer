USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_MissingAcctType]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_MissingAcctType] as
select acct from accthist H
join kc21chg K on H.acct = K.fromkey and K.keyid = '0126'
and H.acct not in (select acct from account)
GO
