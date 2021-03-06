USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10530_Return]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pp_10530_Return]
            @UserAddress VARCHAR (21),	-- ComputerName
	    @CpnyID VARCHAR(10)	As   	-- Company ID
-- Purge Work Records
/*	Since the IN10530_Return table does not have a CpnyID field, we will use
	ErrorInvtID for now.  This field is not populated by any of the 10530 routines
*/
    Select * FROM IN10530_Return
          WHERE ((ComputerName = @UserAddress and ErrorInvtID = @CpnyID)
		 OR (ComputerName = @UserAddress and RTrim(ErrorInvtID) = ''))
GO
