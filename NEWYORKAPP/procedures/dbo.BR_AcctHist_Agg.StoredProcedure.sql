USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_AcctHist_Agg]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[BR_AcctHist_Agg]
@parm1 char(10),
@parm2 char(10),
@parm3 char(4),
@parm4 char(10)	-- Added TLG - 4/8/02
as
Select *
from AcctHist
where cpnyid = @parm1 and Acct = @parm2
and FiscYr = @parm3
and LedgerId = @parm4   	-- Added TLG - 4/8/02
order by cpnyid, Acct, Sub, CuryID, FiscYr, LedgerId  	-- Modified TLG - 4/8/02
GO
