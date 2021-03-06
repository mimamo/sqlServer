USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10250_ItemSite_PhysUpdate]    Script Date: 12/21/2015 13:57:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10250_ItemSite_PhysUpdate]
	@ABCCode VarChar(2),
	@CycleID VarChar (10),
	@Invtid VarChar(30),
	@Lupd_Prog VarChar(8),
	@Lupd_User VarChar(10),
	@MoveClass VarChar(10)
	AS
	Update	ItemSite
		Set
			MoveClass = @MoveClass,
			CycleID = @CycleID,
			ABCCode = @ABCCode,
			LUpd_DateTime = GetDate(),
			Lupd_Prog = @Lupd_Prog,
			Lupd_User = @Lupd_User
		Where
			InvtID = @InvtId
GO
