USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_specificCostId_Q]    Script Date: 12/21/2015 15:42:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_specificCostId_Q]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(30),
	@parm3 VARCHAR(10),
	@parm4 VARCHAR(10),
	@parm5 VARCHAR(25)
AS
	SELECT DISTINCT specificcostid
	FROM potran
	WHERE rcptnbr = @parm1
	and invtid = @parm2
	and siteid = @parm3
	and POTran.Cpnyid = @parm4
	and specificcostid like @parm5
	and potran.qty > 0
	ORDER BY specificcostid
GO
