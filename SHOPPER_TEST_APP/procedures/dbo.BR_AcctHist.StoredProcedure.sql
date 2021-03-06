USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_AcctHist]    Script Date: 12/21/2015 16:06:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_AcctHist]
@parm1 char(10),
@parm2 char(10),
@parm3 char(24),
@parm4 char(4),
@parm5 char(10)	-- Added TLG - 4/8/02
as
Select *
from AcctHist
where cpnyid = @parm1 and Acct = @parm2
and Sub = @parm3
and FiscYr = @parm4
and LedgerId = @parm5   	-- Added TLG - 4/8/02
order by cpnyid, Acct, Sub, CuryID, FiscYr, LedgerId  	-- Modified TLG - 4/8/02
GO
