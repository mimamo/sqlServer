USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_POReceipt_W]    Script Date: 12/21/2015 16:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCVoucher_POReceipt_W]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(10)
AS
	SELECT DISTINCT POReceipt.rcptnbr, POReceipt.ponbr, poreceipt.BatNbr
	FROM POReceipt, POTran
	WHERE POReceipt.rcptType = 'R'
	and POReceipt.rlsed = 1
	and POTran.purchasetype in ('GI', 'GS', 'GP', 'GN')
	and POTran.extweight > 0
	and POTran.cpnyid = @parm1
	and POReceipt.rcptnbr like @parm2
	and POReceipt.cpnyid = POTran.cpnyid
	and POReceipt.rcptnbr = POTran.rcptnbr
	ORDER BY POReceipt.rcptnbr DESC

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
