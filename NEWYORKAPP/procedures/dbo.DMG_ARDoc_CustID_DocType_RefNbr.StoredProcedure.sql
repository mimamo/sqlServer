USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ARDoc_CustID_DocType_RefNbr]    Script Date: 12/21/2015 16:00:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ARDoc_CustID_DocType_RefNbr]
	@CustID varchar(15),
	@DocType varchar(2),
	@RefNbr varchar(10)
	as

	Select 	Count(*)
	from 	Ardoc
	where	ardoc.custid = @CustID and
	        ardoc.doctype = @DocType and
		ardoc.refnbr = @RefNbr

-- Copyright 2001 by Solomon Software, Ltd. All rights reserved.
GO
