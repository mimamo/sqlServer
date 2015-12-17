USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_DocAmt]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[LCVoucher_DocAmt]
	@parmBatNbr varchar(10),
	@parmRefNbr varchar(10)
as
	select
		sum(curytranamt)
	from aptran
	where
		LCCode <> ''
		and
		BatNbr = @parmBatNbr
		and
		RefNbr = @parmRefNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
