USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Upd_TrnsfrDoc_Status]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SCM_10400_Upd_TrnsfrDoc_Status]
	@BatNbr		varchar(10),
	@CpnyID		varchar(10) as

Update TrnsfrDoc
	Set 	Status = 'P'
	Where	BatNbr = @BatNbr
		And CpnyID = @CpnyID
GO
