USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_LCReceipt]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_LCReceipt]
	@Rcptnbr varchar(15)
as
Update LCReceipt
	set TranStatus = 'U',
	ApRefNbr = '',
	s4Future12 = '',
	INBatNbr = ''
WHERE
	Rcptnbr = @RcptNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
