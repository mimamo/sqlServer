USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_YrVersSel2]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_YrVersSel2    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_YrVersSel2]
@parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10), @Parm4 varchar ( 24), @Parm5 varchar ( 10) AS
SELECT * FROM accthist, account WHERE Annbdgt <> 0 AND CpnyID = @parm1 AND fiscyr = @Parm2 AND ledgerid = @Parm3 AND sub = @Parm4 AND Accthist.Acct Like @Parm5 and accthist.acct = account.acct ORDER BY fiscyr, ledgerid, sub, accthist.Acct
GO
