USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_CountSPID_W]    Script Date: 12/21/2015 16:13:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_CountSPID_W]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(30),
	@parm3 VARCHAR(10),
	@parm4 VARCHAR(10)
AS
	SELECT count(*),  max(potran.invtid), max(potran.siteid), max(potran.specificcostid)
	FROM potran, inventory, site
	WHERE potran.rcptnbr = @parm1 -- bLCVoucher.rcptnbr
	and potran.invtid = @parm2 -- bLCVoucher.invtid
	and POTran.cpnyid = @parm3 -- bLCVoucher.cpnyid
	and POTran.siteid = @parm4 -- bLCVoucher.siteid
	and potran.invtid = inventory.invtid
	and site.siteid = potran.siteid
	and potran.extweight > 0
GO
