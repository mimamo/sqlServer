USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Account_Curyid]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--mod 5/27/03
create proc [dbo].[x21kc_Account_Curyid] @parm1 varchar (10), @parm2 varchar (10) as
select a.acct from account a, account x where
(a.acct = @parm1 and a.curyid <> '')
and (x.acct = @parm2  and x.curyid <> '')
and a.curyid <> x.curyid
GO
