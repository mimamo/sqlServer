USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_AllLines]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810LineItem_AllLines]
	@CpnyId varchar(10),
	@EDIInvId varchar(10),
	@LineNbrBeg smallint,
	@LineNbrEnd smallint
As
	Select *
	From ED810LineItem
	Where 	CpnyId = @CpnyId And
		EDIInvId = @EDIInvId And
		LineNbr Between @LineNbrBeg And @LineNbrEnd
	Order By CpnyId, EDIInvId, LineNbr
GO
