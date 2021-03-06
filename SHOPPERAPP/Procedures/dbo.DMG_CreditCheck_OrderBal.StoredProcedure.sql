USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditCheck_OrderBal]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CreditCheck_OrderBal]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@OrderBal	decimal(25,9) OUTPUT
as
	set @OrderBal = 0

	select		@OrderBal = h.UnshippedBalance
	from		SOHeader  h (NOLOCK)

	join		Terms	  t (NOLOCK)
	  on		t.TermsID = h.TermsID

	join		SOType    y (NOLOCK)
	  on		y.CpnyID = @CpnyID
	  and		y.SOTypeID = h.SOTypeID

	where		h.CpnyID = @CpnyID
	  and		h.OrdNbr = @OrdNbr
	  and		h.Status = 'O'
	  and		t.CreditChk = 1
	  and		y.Behavior in ('CM', 'CS', 'DM', 'INVC', 'RMSH', 'SO', 'WC')

	--select @OrderBal
GO
