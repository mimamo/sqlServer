USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_CountSiteID_C]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_CountSiteID_C]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(30),
	@parm3 VARCHAR(10)
AS
	SELECT count(*),  max(potran.invtid), max(potran.siteid), max(potran.specificcostid)
	FROM potran, inventory, site
	WHERE potran.rcptnbr = @parm1 -- bLCVoucher.rcptnbr
	and potran.invtid = @parm2 -- bLCVoucher.invtid
	and POTran.cpnyid = @parm3 -- bLCVoucher.cpnyid
	and potran.invtid = inventory.invtid
	and site.siteid = potran.siteid
	and potran.extcost > 0
GO
