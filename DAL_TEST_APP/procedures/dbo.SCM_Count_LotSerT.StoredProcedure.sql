USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Count_LotSerT]    Script Date: 12/21/2015 13:57:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*	This procedure is used by INBR and will calculate the correct
	number for INTran.LotSerCntr
*/
create procedure [dbo].[SCM_Count_LotSerT]
	@InvtID		varchar (30),
	@BatNbr		varchar (10) As

	Select Count(*) from LotSerT
		Where 	LotSerT.BatNbr = @BatNbr
			And LotSerT.InvtID = @InvtID
GO
