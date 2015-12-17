USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_10530_Return]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[ADG_10530_Return]
	@ComputerName	VarChar(21),
	@CpnyID		VarChar(10)	/* Stored in ErrorInvtID */
As
/*	Since the IN10530_Return table does not have a CpnyID field, we will use
	ErrorInvtID for now.  This field is not populated by any of the 10530 routines
*/
	Select	*
		From	IN10530_Return (NoLock)
		Where	ComputerName = @ComputerName
			And (ErrorInvtID = @CpnyID
			Or RTrim(ErrorInvtID) = '')
GO
