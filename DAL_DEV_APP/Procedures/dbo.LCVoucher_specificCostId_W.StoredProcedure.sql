USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_specificCostId_W]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_specificCostId_W]
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
	and potran.extweight > 0
	ORDER BY specificcostid
GO
