USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_InvtID_C]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_InvtID_C]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(10),
	@parm3 VARCHAR(30)
AS
	SELECT DISTINCT  potran.invtid, potran.siteid
	FROM potran, inventory
	WHERE rcptnbr = @parm1
	and POTran.cpnyid = @parm2
	and potran.invtid like @parm3
	and potran.invtid = inventory.invtid
	and potran.extcost > 0
	ORDER BY potran.invtid

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
