USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM11600_Wrk_ISequence_LUpd]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM11600_Wrk_ISequence_LUpd]
	@Screen varchar (5),
	@UserId varchar (47),
	@ISequenceBeg integer,
	@ISequenceEnd integer as
	Select * from BM11600_Wrk where
		LUpd_Prog = @Screen and
		LUpd_User = @UserId and
		ISequence BETWEEN @ISequenceBeg and @ISequenceEnd
	Order by ISequence
GO
