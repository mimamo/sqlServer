USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditCheck_OrderBal]    Script Date: 12/21/2015 16:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditCheck_OrderBal]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select		h.UnshippedBalance
	from		SOHeader  h

	join		Terms	  t
	  on		t.TermsID = h.TermsID

	join		SOType    y
	  on		y.CpnyID = @CpnyID
	  and		y.SOTypeID = h.SOTypeID

	where		h.CpnyID = @CpnyID
	  and		h.OrdNbr = @OrdNbr
	  and		h.Status = 'O'
	  and		t.CreditChk = 1
	  and		y.Behavior in ('CM', 'CS', 'DM', 'INVC', 'MO', 'RMA', 'RMSH', 'SO', 'WC')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
