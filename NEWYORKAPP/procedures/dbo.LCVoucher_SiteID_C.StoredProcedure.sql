USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_SiteID_C]    Script Date: 12/21/2015 16:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_SiteID_C]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(30),
	@parm3 VARCHAR(10),
	@parm4 VARCHAR(10)
AS
	SELECT DISTINCT  potran.siteid, site.name
	FROM potran, inventory, site
	WHERE potran.rcptnbr = @parm1 -- bLCVoucher.rcptnbr
	and potran.invtid = @parm2 -- bLCVoucher.invtid
	and POTran.cpnyid = @parm3 -- bLCVoucher.cpnyid
	and potran.siteid LIKE @parm4 -- passed parameter
	and potran.invtid = inventory.invtid
	and site.siteid = potran.siteid
	and potran.extcost > 0
	ORDER BY potran.siteid

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
